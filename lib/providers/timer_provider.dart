import 'dart:async';

import 'package:flow_focus/providers/config_provider.dart';
import 'package:flow_focus/widgets/step_type.dart';
import 'package:flutter/material.dart';

class TimerModelProvider extends ChangeNotifier {
  final ConfigModelProvider _configModelProvider;

  TimerModelProvider(this._configModelProvider) {
    _configModelProvider.addListener(_onConfigChanged);
    _initializeFormConfig();
  }

  Timer? _timer;
  Duration _currentDuration = const Duration(minutes: 25);
  Duration _totalDuration = const Duration(minutes: 25);
  bool _isRunning = false;
  PomoStepType _currentStep = PomoStepType.work;
  int _completedSessions = 0;

  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isRunning => _isRunning;
  PomoStepType get currentStep => _currentStep;
  double get progress =>
      1.0 - (_currentDuration.inSeconds / _totalDuration.inSeconds);

  void _initializeFormConfig() {
    _totalDuration = Duration(minutes: _configModelProvider.workTime);
    _currentDuration = _totalDuration;
  }

  void onStartTimer() {
    if (_isRunning) return;

    _isRunning = true;

    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentDuration.inSeconds > 0) {
        _currentDuration = Duration(seconds: _currentDuration.inSeconds - 1);
        notifyListeners();
      } else {
        onCompleteStep();
      }
    });
  }

  void _onConfigChanged() {
    if (isRunning) return;

    switch (_currentStep) {
      case PomoStepType.work:
        _totalDuration = Duration(minutes: _configModelProvider.workTime);
      case PomoStepType.shortBreak:
        _totalDuration = Duration(minutes: _configModelProvider.shortBreakTime);
      case PomoStepType.longBreak:
        _totalDuration = Duration(minutes: _configModelProvider.longBreakTime);
    }

    _currentDuration = _totalDuration;

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;

    notifyListeners();
  }

  void onCompleteStep() {
    _timer?.cancel();
    _isRunning = false;

    if (_currentStep == PomoStepType.work) {
      _completedSessions++;

      _currentStep =
          _completedSessions % _configModelProvider.sessionUntilLongBreak == 0
          ? PomoStepType.longBreak
          : PomoStepType.shortBreak;

      _totalDuration = _currentStep == PomoStepType.longBreak
          ? Duration(minutes: _configModelProvider.longBreakTime)
          : Duration(minutes: _configModelProvider.shortBreakTime);
    } else {
      _currentStep = PomoStepType.work;
      _totalDuration = Duration(minutes: _configModelProvider.workTime);
    }

    _currentDuration = _totalDuration;

    notifyListeners();
  }

  void onRestartTimer() {
    _timer?.cancel();
    _isRunning = false;

    switch (_currentStep) {
      case PomoStepType.work:
        _totalDuration = Duration(minutes: _configModelProvider.workTime);
      case PomoStepType.shortBreak:
        _totalDuration = Duration(minutes: _configModelProvider.shortBreakTime);
      case PomoStepType.longBreak:
        _totalDuration = Duration(minutes: _configModelProvider.longBreakTime);
    }

    _currentDuration = _totalDuration;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _configModelProvider.removeListener(_onConfigChanged);
    super.dispose();
  }
}
