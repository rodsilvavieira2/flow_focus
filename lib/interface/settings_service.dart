abstract class ISettingsService {
  Future<int> getWorkTime();
  Future<int> getShortBreakTime();
  Future<int> getLongBreakTime();
  Future<int> getSessionUntilLongBreak();

  Future<void> setWorkTime(int value);
  Future<void> setShortBreakTime(int value);
  Future<void> setLongBreakTime(int value);
  Future<void> setSessionUntilLongBreak(int value);

  Future<void> resetToDefaults();
}
