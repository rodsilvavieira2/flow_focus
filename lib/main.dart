import 'package:flow_focus/config/theme.dart';
import 'package:flow_focus/providers/config_provider.dart';
import 'package:flow_focus/providers/theme_provider.dart';
import 'package:flow_focus/providers/timer_provider.dart';
import 'package:flow_focus/screens/home.dart';
import 'package:flow_focus/services/notification_service.dart';
import 'package:flow_focus/services/settings_service.dart';
import 'package:flow_focus/services/system_tray.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  final notificationService = NotificationService();
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WindowListener {
  final SystemTrayService _systemTrayService = SystemTrayService();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initSystemTray();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _systemTrayService.destroy();
    super.dispose();
  }

  Future<void> _initSystemTray() async {
    await _systemTrayService.initSystemTray();
  }

  @override
  void onWindowClose() async {
    await _systemTrayService.hideToTray();
  }

  @override
  Widget build(BuildContext context) {
    _initSystemTray();

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
