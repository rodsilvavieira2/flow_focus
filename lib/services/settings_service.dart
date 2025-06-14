import 'package:flow_focus/interface/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService implements ISettingsService {
  static const String _workTimeKey = "work_time";
  static const String _shortBreakTimeKey = "short_break_time";
  static const String _longBreakTimeKey = "long_break_time";
  static const String _sessionUntilLongBreakKey = "session_until_long";
  static const String _settingsVersionKey = "theme_mode";

  static const int defaultWorkTime = 25;
  static const int defaultShortBreakTime = 5;
  static const int defaultLongBreakTime = 15;
  static const int defaultSessionUntilLongBreak = 4;

  @override
  Future<int> getWorkTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_workTimeKey) ?? defaultWorkTime;
  }

  @override
  Future<int> getShortBreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_shortBreakTimeKey) ?? defaultShortBreakTime;
  }

  @override
  Future<int> getLongBreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_longBreakTimeKey) ?? defaultLongBreakTime;
  }

  @override
  Future<int> getSessionUntilLongBreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionUntilLongBreakKey) ??
        defaultSessionUntilLongBreak;
  }

  @override
  Future<void> setWorkTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_workTimeKey, value);
  }

  @override
  Future<void> setShortBreakTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shortBreakTimeKey, value);
  }

  @override
  Future<void> setLongBreakTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_longBreakTimeKey, value);
  }

  @override
  Future<void> setSessionUntilLongBreak(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionUntilLongBreakKey, value);
  }

  @override
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workTimeKey);
    await prefs.remove(_shortBreakTimeKey);
    await prefs.remove(_longBreakTimeKey);
    await prefs.remove(_sessionUntilLongBreakKey);
  }

  @override
  Future<void> setThemeMode(ThemeMode input) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_settingsVersionKey, input.name.toString());
  }

  @override
  Future<ThemeMode> getThemeMode() {
    return SharedPreferences.getInstance().then((prefs) {
      final themeModeString = prefs.getString(_settingsVersionKey);

      if (themeModeString == null) {
        return ThemeMode.system;
      }

      switch (themeModeString) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    });
  }
}
