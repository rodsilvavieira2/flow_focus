import 'package:flow_focus/widgets/progesss_bar.dart';
import 'package:flow_focus/widgets/step_type.dart';
import 'package:flow_focus/widgets/timer.dart';
import 'package:flow_focus/widgets/timer_controls.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusFlow'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              print("got to settins");
            },
            icon: Icon(Icons.settings),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepType(step: PomoStepType.work),
            const SizedBox(height: 22),
            Timer(duration: Duration(hours: 0, minutes: 25, seconds: 0)),
            const SizedBox(height: 22),
            TimeControls(
              onPause: () {},
              onRestart: () {},
              onStart: () {},
              onSkip: () {},
              isStated: true,
            ),
            const SizedBox(height: 22),
            ProgressBar(percent: 0.05),
          ],
        ),
      ),
    );
  }
}
