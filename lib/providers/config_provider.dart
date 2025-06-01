import 'package:flow_focus/services/settings_service.dart';
import 'package:flutter/material.dart';

class ConfigModelProvider extends ChangeNotifier {
  int _workTime = 25;
  int _shortBreakTime = 5;
  int _longBreakTime = 15;
  int _sessionUntilLongBreak = 4;

  get workTime => _workTime;
  get shortBreakTime => _shortBreakTime;
  get longBreakTime => _longBreakTime;
  get sessionUntilLongBreak => _sessionUntilLongBreak;

  Future<void> load() async {
    final workTime = await SettingsService.getWorkTime();
    final shortBreakTime = await SettingsService.getShortBreakTime();
    final longBreakTime = await SettingsService.getLongBreakTime();
    final sessionUntilLongBreak =
        await SettingsService.getSessionUntilLongBreak();

    _workTime = workTime;
    _shortBreakTime = shortBreakTime;
    _longBreakTime = longBreakTime;
    _sessionUntilLongBreak = sessionUntilLongBreak;
  }

  Future<void> onChangeWorkTime(int value) async {
    _workTime = value;
    await SettingsService.setWorkTime(value);
    notifyListeners();
  }

  Future<void> onChangeShortBreakTime(int value) async {
    _shortBreakTime = value;
    await SettingsService.setShortBreakTime(value);
    notifyListeners();
  }

  Future<void> onChangeLongBreakTime(int value) async {
    _longBreakTime = value;
    await SettingsService.setLongBreakTime(value);
    notifyListeners();
  }

  Future<void> onChangeSessionUntilLongBreak(int value) async {
    _sessionUntilLongBreak = value;
    await SettingsService.setSessionUntilLongBreak(value);
    notifyListeners();
  }
}
