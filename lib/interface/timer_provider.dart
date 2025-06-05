import 'package:flow_focus/widgets/step_type.dart';

/// Interface for managing Pomodoro timer state and operations.
///
/// This interface provides a contract for implementing a Pomodoro timer that
/// manages work sessions, short breaks, and long breaks according to the
/// Pomodoro Technique. It tracks the current state, progress, and provides
/// methods for controlling timer execution.
///
/// The timer automatically transitions between different phases:
/// - Work sessions
/// - Short breaks (after each work session)
/// - Long breaks (after a configured number of work sessions)
///
/// Example usage:
/// ```dart
/// final timerProvider = TimerModelProvider(configProvider);
/// timerProvider.addListener(() {
///   print('Timer state changed: ${timerProvider.currentStep}');
/// });
/// timerProvider.onStartTimer();
/// ```
abstract class ITimerProvider {
  /// The remaining time in the current timer phase.
  ///
  /// This value decreases as the timer runs and represents the time
  /// left before the current phase (work, short break, or long break) completes.
  /// When this reaches zero, the timer automatically transitions to the next phase.
  Duration get currentDuration;

  /// The total duration for the current timer phase.
  ///
  /// This represents the full duration of the current phase and is used
  /// to calculate progress. The value is determined by the current step type
  /// and the configuration settings.
  Duration get totalDuration;

  /// Whether the timer is currently running.
  ///
  /// Returns `true` if the timer is actively counting down,
  /// `false` if it's paused or stopped.
  bool get isRunning;

  /// The current phase of the Pomodoro cycle.
  ///
  /// Indicates whether the user is currently in a work session,
  /// short break, or long break period.
  PomoStepType get currentStep;

  /// The completion progress of the current timer phase as a percentage.
  ///
  /// Returns a value between 0.0 (just started) and 1.0 (completed).
  /// This is calculated as: 1.0 - (currentDuration / totalDuration)
  double get progress;

  /// Starts or resumes the timer countdown.
  ///
  /// If the timer is already running, this method has no effect.
  /// The timer will count down from the current duration and automatically
  /// transition to the next phase when it reaches zero.
  void onStartTimer();

  /// Pauses the timer countdown.
  ///
  /// The timer can be resumed later by calling [onStartTimer].
  /// The current duration and progress are preserved.
  void pauseTimer();

  /// Manually completes the current timer phase and transitions to the next.
  ///
  /// This method stops the current timer and immediately moves to the next
  /// phase in the Pomodoro cycle. It's equivalent to letting the timer
  /// naturally count down to zero.
  ///
  /// The transition logic follows the Pomodoro Technique:
  /// - After work: transitions to short break or long break
  /// - After break: transitions back to work
  void onCompleteStep();

  /// Restarts the current timer phase from the beginning.
  ///
  /// This method stops the timer and resets the current duration
  /// to the full duration for the current phase. The phase type
  /// (work/break) remains unchanged.
  void onRestartTimer();

  int get completedSessions;

  int get totalOfSessions;
}
