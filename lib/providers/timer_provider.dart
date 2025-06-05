import 'dart:async';

import 'package:flow_focus/interface/config_provider.dart';
import 'package:flow_focus/interface/notification_service.dart';
import 'package:flow_focus/interface/timer_provider.dart';
import 'package:flow_focus/widgets/step_type.dart';
import 'package:flutter/material.dart';

class TimerModelProvider extends ChangeNotifier implements ITimerProvider {
  final IConfigProvider _configModelProvider;
  final INotificationService _notificationService;

  TimerModelProvider(this._configModelProvider, this._notificationService) {
    _configModelProvider.addListener(_onConfigChanged);
    _initializeFormConfig();
  }

  Timer? _timer;
  Duration _currentDuration = const Duration(minutes: 25);
  Duration _totalDuration = const Duration(minutes: 25);
  bool _isRunning = false;
  PomoStepType _currentStep = PomoStepType.work;
  int _completedSessions = 1;

  @override
  Duration get currentDuration => _currentDuration;

  @override
  Duration get totalDuration => _totalDuration;

  @override
  bool get isRunning => _isRunning;

  @override
  PomoStepType get currentStep => _currentStep;

  @override
  int get completedSessions => _completedSessions;

  @override
  int get totalOfSessions => _configModelProvider.sessionUntilLongBreak;

  @override
  double get progress =>
      1.0 - (_currentDuration.inSeconds / _totalDuration.inSeconds);

  void _initializeFormConfig() {
    _totalDuration = Duration(minutes: _configModelProvider.workTime);
    _currentDuration = _totalDuration;
  }

  @override
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

  @override
  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;

    notifyListeners();
  }

  @override
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

      _notificationService.showBreakNotification();
    } else {
      _currentStep = PomoStepType.work;
      _totalDuration = Duration(minutes: _configModelProvider.workTime);

      _notificationService.showFocusNotification(onAction: onStartTimer);
    }

    _currentDuration = _totalDuration;

    notifyListeners();
  }

  @override
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
