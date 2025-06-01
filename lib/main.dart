import 'package:flow_focus/config/theme.dart';
import 'package:flow_focus/providers/config_provider.dart';
import 'package:flow_focus/providers/timer_provider.dart';
import 'package:flow_focus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigModelProvider()),

        ChangeNotifierProxyProvider<ConfigModelProvider, TimerModelProvider>(
          create: (context) {
            Provider.of<ConfigModelProvider>(context, listen: false).load();

            return TimerModelProvider(
              Provider.of<ConfigModelProvider>(context, listen: false),
            );
          },
          update: (context, config, previousTimer) {
            return previousTimer ?? TimerModelProvider(config);
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
