import 'package:flow_focus/widgets/step_type.dart';

abstract class ITimerProvider {
  Duration get currentDuration;
  Duration get totalDuration;
  bool get isRunning;
  PomoStepType get currentStep;
  double get progress;

  void onStartTimer();
  void pauseTimer();
  void onCompleteStep();
  void onRestartTimer();
}
