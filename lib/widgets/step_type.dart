import 'package:flutter/material.dart';

enum Step { work, interval, lagerInterval }

class StepType extends StatelessWidget {
  final Step step;

  const StepType({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(children: [_getStepText(step)]);
  }

  _getStepText(Step input) {
    return switch (input) {
      Step.work => Text("Foco!"),
      Step.interval => Text("Um pouco de descanso"),
      Step.lagerInterval => Text("Pegue um cafe e relaxe"),
    };
  }
}
