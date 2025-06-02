import 'package:flutter/material.dart';

/// Interface for managing application settings and configuration persistence.
///
/// This interface defines the contract for storing and retrieving user preferences
/// related to Pomodoro timer configuration. All time values are in minutes.
///
/// Example usage:
/// ```dart
/// final settingsService = SettingsService();
/// await settingsService.setWorkTime(30);
/// final workTime = await settingsService.getWorkTime(); // Returns 30
/// ```
abstract class ISettingsService {
  /// Retrieves the work session duration in minutes.
  ///
  /// Returns the configured work time or a default value if not set.
  /// Default value is typically 25 minutes.
  Future<int> getWorkTime();

  /// Retrieves the short break duration in minutes.
  ///
  /// Returns the configured short break time or a default value if not set.
  /// Default value is typically 5 minutes.
  Future<int> getShortBreakTime();

  /// Retrieves the long break duration in minutes.
  ///
  /// Returns the configured long break time or a default value if not set.
  /// Default value is typically 15 minutes.
  Future<int> getLongBreakTime();

  /// Retrieves the number of work sessions required before a long break.
  ///
  /// Returns the configured session count or a default value if not set.
  /// Default value is typically 4 sessions.
  Future<int> getSessionUntilLongBreak();

  /// Sets the work session duration in minutes.
  ///
  /// [value] The work duration in minutes. Should be a positive integer.
  ///
  /// Throws [ArgumentError] if value is negative or zero.
  Future<void> setWorkTime(int value);

  /// Sets the short break duration in minutes.
  ///
  /// [value] The short break duration in minutes. Should be a positive integer.
  ///
  /// Throws [ArgumentError] if value is negative or zero.
  Future<void> setShortBreakTime(int value);

  /// Sets the long break duration in minutes.
  ///
  /// [value] The long break duration in minutes. Should be a positive integer.
  ///
  /// Throws [ArgumentError] if value is negative or zero.
  Future<void> setLongBreakTime(int value);

  /// Sets the number of work sessions required before a long break.
  ///
  /// [value] The session count. Should be a positive integer.
  ///
  /// Throws [ArgumentError] if value is negative or zero.
  Future<void> setSessionUntilLongBreak(int value);

  /// Resets all settings to their default values.
  ///
  /// This will remove all stored preferences and revert to application defaults:
  /// - Work time: 25 minutes
  /// - Short break: 5 minutes
  /// - Long break: 15 minutes
  /// - Sessions until long break: 4
  Future<void> resetToDefaults();

  Future<void> setThemeMode(ThemeMode input);

  Future<ThemeMode> getThemeMode();
}
