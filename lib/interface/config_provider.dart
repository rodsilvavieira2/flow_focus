/// Interface for managing application configuration state and change notifications.
///
/// This interface extends the functionality of [ISettingsService] by providing
/// reactive state management with change notifications. It acts as a bridge
/// between the UI and the settings persistence layer.
///
/// The provider automatically notifies listeners when configuration values change,
/// making it suitable for use with state management solutions like Provider.
///
/// Example usage:
/// ```dart
/// final configProvider = ConfigModelProvider(settingsService: settingsService);
/// configProvider.addListener(() {
///   print('Configuration changed!');
/// });
/// await configProvider.onChangeWorkTime(30);
/// ```
abstract class IConfigProvider {
  /// Current work session duration in minutes.
  ///
  /// This value is synchronized with the underlying settings service
  /// and reflects the latest configuration.
  int get workTime;

  /// Current short break duration in minutes.
  ///
  /// This value is synchronized with the underlying settings service
  /// and reflects the latest configuration.
  int get shortBreakTime;

  /// Current long break duration in minutes.
  ///
  /// This value is synchronized with the underlying settings service
  /// and reflects the latest configuration.
  int get longBreakTime;

  /// Current number of work sessions required before a long break.
  ///
  /// This value is synchronized with the underlying settings service
  /// and reflects the latest configuration.
  int get sessionUntilLongBreak;

  /// Loads configuration from the underlying settings service.
  ///
  /// This method should be called during initialization to ensure
  /// the provider state is synchronized with persisted settings.
  /// Notifies listeners after loading is complete.
  Future<void> load();

  /// Updates the work session duration and persists the change.
  ///
  /// [value] The new work duration in minutes. Should be a positive integer.
  ///
  /// This method updates both the local state and the underlying settings,
  /// then notifies all listeners of the change.
  Future<void> onChangeWorkTime(int value);

  /// Updates the short break duration and persists the change.
  ///
  /// [value] The new short break duration in minutes. Should be a positive integer.
  ///
  /// This method updates both the local state and the underlying settings,
  /// then notifies all listeners of the change.
  Future<void> onChangeShortBreakTime(int value);

  /// Updates the long break duration and persists the change.
  ///
  /// [value] The new long break duration in minutes. Should be a positive integer.
  ///
  /// This method updates both the local state and the underlying settings,
  /// then notifies all listeners of the change.
  Future<void> onChangeLongBreakTime(int value);

  /// Updates the session count before long break and persists the change.
  ///
  /// [value] The new session count. Should be a positive integer.
  ///
  /// This method updates both the local state and the underlying settings,
  /// then notifies all listeners of the change.
  Future<void> onChangeSessionUntilLongBreak(int value);

  /// Adds a listener to be notified when configuration changes.
  ///
  /// [listener] A callback function that will be called whenever
  /// the configuration state changes.
  void addListener(void Function() listener);

  /// Removes a previously added listener.
  ///
  /// [listener] The callback function to remove from the notification list.
  void removeListener(void Function() listener);

  /// Disposes of the provider and cleans up resources.
  ///
  /// This method should be called when the provider is no longer needed
  /// to prevent memory leaks. It will remove all listeners and clean up
  /// any internal resources.
  void dispose();
}
