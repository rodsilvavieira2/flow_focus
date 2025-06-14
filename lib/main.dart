import 'package:flow_focus/config/theme.dart';
import 'package:flow_focus/providers/config_provider.dart';
import 'package:flow_focus/providers/theme_provider.dart';
import 'package:flow_focus/providers/timer_provider.dart';
import 'package:flow_focus/screens/home.dart';
import 'package:flow_focus/services/notification_service.dart';
import 'package:flow_focus/services/settings_service.dart';
import 'package:flow_focus/services/tray_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';

final NotificationService notificationService = NotificationService();
final TrayService trayService = TrayService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);

  await notificationService.initialize();
  final settingsService = SettingsService();

  WindowOptions windowOptions = WindowOptions(
    size: const Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'FlowFocus',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await windowManager.setPreventClose(true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ConfigModelProvider(settingsService: settingsService);
          },
        ),

        ChangeNotifierProxyProvider<ConfigModelProvider, TimerModelProvider>(
          create: (context) {
            return TimerModelProvider(
              Provider.of<ConfigModelProvider>(context, listen: false),
              notificationService,
            );
          },
          update: (context, config, previousTimer) {
            return previousTimer ??
                TimerModelProvider(config, notificationService);
          },
        ),

        ChangeNotifierProvider(
          create: (_) => ThemeModelProvider(settingsService),
        ),
      ],
      child: MyApp(notificationService: notificationService),
    ),
  );
}

class MyApp extends StatefulWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WindowListener {
  final SystemTray _tray = SystemTray();
  final Menu _menu = Menu();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initTray();
  }

  Future<void> _initTray() async {
    final String iconPath = Platform.isWindows
        ? 'assets/icons/app_icon.png'
        : 'assets/icons/app_icon.png';

    await _tray.initSystemTray(
      title: 'Flow Focus',
      iconPath: iconPath,
    );

    await _menu.buildFrom([
      MenuItemLabel(
          label: 'Show',
          onClicked: (menuItem) async {
            await windowManager.show();
            await windowManager.focus();
          }),
      MenuItemLabel(
          label: 'Exit',
          onClicked: (menuItem) async {
            await windowManager.destroy();
          }),
    ]);

    await _tray.setContextMenu(_menu);

    _tray.registerSystemTrayEventHandler((eventName) async {
      if (eventName == kSystemTrayEventClick) {
        await windowManager.show();
        await windowManager.focus();
      }
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _tray.destroy();
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool preventClose = await windowManager.isPreventClose();
    if (preventClose) {
      await windowManager.hide();
      await widget.notificationService.showSystemTrayNotification(
        title: 'Flow Focus',
        body: 'Running in system tray',
      );
    }
  }
  @override
  void initState() {
    trayService.initialize(
      onShow: () async {
        await windowManager.show();
        await windowManager.focus();
      },
      onQuit: () async {
        await trayService.destroy();
        await windowManager.destroy();
      },
    );

    super.initState();

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    await windowManager.hide();
    await notificationService.showSystemTrayNotification(
      title: 'Flow Focus',
      body: 'Still running in the background.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModelProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FocusFlowLightTheme.theme,
          darkTheme: FocusFlowDarkTheme.theme,
          themeMode: provider.currentTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
