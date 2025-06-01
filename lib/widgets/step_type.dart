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
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            children: [
              _getStepIcon(step),
              SizedBox(width: 8),
              _getStepText(step),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  _getStepText(PomoStepType input) {
    return switch (input) {
      PomoStepType.work => Text("Foco!"),
      PomoStepType.shortBreak => Text("Um pouco de descanso"),
      PomoStepType.longBreak => Text("Pegue um cafe e relaxe"),
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
