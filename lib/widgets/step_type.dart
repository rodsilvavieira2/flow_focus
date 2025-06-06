import 'package:flutter/material.dart';

enum PomoStepType { work, shortBreak, longBreak }

class StepType extends StatelessWidget {
  final PomoStepType step;

  const StepType({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _getStepIcon(step),
                SizedBox(width: 8),
                _getStepText(step),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _getStepText(PomoStepType input) {
    return switch (input) {
      PomoStepType.work => Text("Focus!"),
      PomoStepType.shortBreak => Text("Take a short break"),
      PomoStepType.longBreak => Text("Grab some coffee and relax"),
    };
  }

  _getStepIcon(PomoStepType input) {
    return switch (input) {
      PomoStepType.work => Icon(Icons.work_outline),
      PomoStepType.shortBreak => Icon(Icons.timer),
      PomoStepType.longBreak => Icon(Icons.hourglass_bottom),
    };
  }
}
