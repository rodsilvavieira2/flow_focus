import 'package:flow_focus/interface/settings_service.dart';
import 'package:flutter/material.dart';

class ConfigModelProvider extends ChangeNotifier {
  final ISettingsService settingsService;

  ConfigModelProvider({required this.settingsService}) {
    load();
  }

  int _workTime = 25;
  int _shortBreakTime = 5;
  int _longBreakTime = 15;
  int _sessionUntilLongBreak = 4;

  get workTime => _workTime;
  get shortBreakTime => _shortBreakTime;
  get longBreakTime => _longBreakTime;
  get sessionUntilLongBreak => _sessionUntilLongBreak;

  Future<void> load() async {
    final workTime = await settingsService.getWorkTime();
    final shortBreakTime = await settingsService.getShortBreakTime();
    final longBreakTime = await settingsService.getLongBreakTime();
    final sessionUntilLongBreak = await settingsService
        .getSessionUntilLongBreak();

    _workTime = workTime;
    _shortBreakTime = shortBreakTime;
    _longBreakTime = longBreakTime;
    _sessionUntilLongBreak = sessionUntilLongBreak;

    notifyListeners();
  }

  Future<void> onChangeWorkTime(int value) async {
    _workTime = value;
    await settingsService.setWorkTime(value);
    notifyListeners();
  }

  Future<void> onChangeShortBreakTime(int value) async {
    _shortBreakTime = value;
    await settingsService.setShortBreakTime(value);
    notifyListeners();
  }

  Future<void> onChangeLongBreakTime(int value) async {
    _longBreakTime = value;
    await settingsService.setLongBreakTime(value);
    notifyListeners();
  }

  Future<void> onChangeSessionUntilLongBreak(int value) async {
    _sessionUntilLongBreak = value;
    await settingsService.setSessionUntilLongBreak(value);
    notifyListeners();
  }
}
