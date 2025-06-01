import 'package:flow_focus/config/theme.dart';
import 'package:flow_focus/providers/config_provider.dart';
import 'package:flow_focus/providers/timer_provider.dart';
import 'package:flow_focus/screens/home.dart';
import 'package:flow_focus/services/notification_service.dart';
import 'package:flow_focus/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();
  final settingsService = SettingsService();

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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FocusFlowLightTheme.theme,
      darkTheme: FocusFlowDarkTheme.theme,
      home: const HomeScreen(),
    );
  }
}
