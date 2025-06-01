import 'dart:async';

import 'package:flow_focus/widgets/step_type.dart';
import 'package:flutter/material.dart';

enum StepTypes { work, shortBreak, longBreak }

class TimeModel extends ChangeNotifier {
  Timer? _timer;
  Duration _currentDuration = const Duration(minutes: 25);
  Duration _totalDuration = const Duration(minutes: 25);
  bool _isRunning = false;
  StepTypes _currentStep = StepTypes.work;
  int _completedSessions = 0;

  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isRunning => _isRunning;
  PomoStepType get currentStep => currentStep;
  double get progress =>
      1.0 - (_currentDuration.inSeconds / _totalDuration.inSeconds);

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentDuration.inSeconds > 0) {
        _currentDuration = Duration(seconds: _currentDuration.inSeconds - 1);
        notifyListeners();
      } else {
        _completeStep();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    _currentDuration = _totalDuration;

    notifyListeners();
  }

  void _completeStep() {
    _timer?.cancel();
    _isRunning = false;

    if (_currentStep == StepTypes.work) {
      _completedSessions++;

      _currentStep = _completedSessions % 4 == 0
          ? StepTypes.longBreak
          : StepTypes.shortBreak;

      _totalDuration = _currentStep == StepTypes.longBreak
          ? const Duration(minutes: 15)
          : const Duration(minutes: 5);
    } else {
      _currentStep = StepTypes.work;
      _totalDuration = const Duration(minutes: 25);
    }

    _currentDuration = _totalDuration;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
