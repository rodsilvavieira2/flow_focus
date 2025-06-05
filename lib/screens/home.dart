import 'package:flow_focus/providers/theme_provider.dart';
import 'package:flow_focus/providers/timer_provider.dart';
import 'package:flow_focus/screens/settings.dart';
import 'package:flow_focus/widgets/progesss_bar.dart';
import 'package:flow_focus/widgets/step_type.dart';
import 'package:flow_focus/widgets/theme_switch.dart';
import 'package:flow_focus/widgets/timer.dart';
import 'package:flow_focus/widgets/timer_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ThemeModelProvider>(
          builder: (context, value, child) {
            return Row(
              children: [
                value.loadThemeIcon(value.currentTheme),
                const SizedBox(width: 8),
                const Text('FocusFlow'),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          const ThemeSwitch(),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<TimerModelProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepType(step: provider.currentStep),

                const SizedBox(height: 22),

                Timer(duration: provider.currentDuration),

                const SizedBox(height: 22),

                TimeControls(
                  onPause: provider.pauseTimer,
                  onRestart: provider.onRestartTimer,
                  onStart: provider.onStartTimer,
                  onSkip: provider.onCompleteStep,
                  isRunning: provider.isRunning,
                ),

                const SizedBox(height: 22),

                ProgressBar(percent: provider.progress),
              ],
            ),
          );
        },
      ),
    );
  }
}
