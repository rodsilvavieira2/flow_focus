abstract class IConfigProvider {
  // Getters
  int get workTime;
  int get shortBreakTime;
  int get longBreakTime;
  int get sessionUntilLongBreak;

  // Methods
  Future<void> load();
  Future<void> onChangeWorkTime(int value);
  Future<void> onChangeShortBreakTime(int value);
  Future<void> onChangeLongBreakTime(int value);
  Future<void> onChangeSessionUntilLongBreak(int value);
}
