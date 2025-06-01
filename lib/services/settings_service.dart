import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _workTimeKey = "work_time";
  static const String _shortBreakTimeKey = "short_break_time";
  static const String _longBreakTimeKey = "long_break_time";
  static const String _sessionUntilLongBreakKey = "session_until_long";

  static const int defaultWorkTime = 25;
  static const int defaultShortBreakTime = 5;
  static const int defaultLongBreakTime = 15;
  static const int defaultSessionUntilLongBreak = 4;

  static Future<int> getWorkTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_workTimeKey) ?? defaultWorkTime;
  }

  static Future<int> getShortBreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_shortBreakTimeKey) ?? defaultShortBreakTime;
  }

  static Future<int> getLongBreakTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_longBreakTimeKey) ?? defaultLongBreakTime;
  }

  static Future<int> getSessionUntilLongBreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionUntilLongBreakKey) ??
        defaultSessionUntilLongBreak;
  }

  static Future<void> setWorkTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_workTimeKey, value);
  }

  static Future<void> setShortBreakTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shortBreakTimeKey, value);
  }

  static Future<void> setLongBreakTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_longBreakTimeKey, value);
  }

  static Future<void> setSessionUntilLongBreak(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionUntilLongBreakKey, value);
  }

  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workTimeKey);
    await prefs.remove(_shortBreakTimeKey);
    await prefs.remove(_longBreakTimeKey);
    await prefs.remove(_sessionUntilLongBreakKey);
  }
}
