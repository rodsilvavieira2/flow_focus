import 'dart:ui';

/// Interface for managing application notifications across different platforms.
///
/// This interface provides a contract for implementing notification services
/// that can display system notifications to users. It's designed to work
/// across desktop platforms (Linux, macOS, Windows) and provides methods
/// for different types of notifications related to Pomodoro timer events.
///
/// The interface supports:
/// - Basic notifications with title and body
/// - Timer-specific notifications (work complete, break time, etc.)
/// - System tray notifications
/// - Initialization and cleanup
///
/// Example usage:
/// ```dart
/// final notificationService = NotificationService();
/// await notificationService.initialize();
///
/// await notificationService.showTimerNotification(
///   title: 'Work Complete!',
///   body: 'Time for a break',
/// );
/// ```
abstract class INotificationService {
  /// Initializes the notification service.
  ///
  /// This method should be called once during application startup to set up
  /// the notification system, request necessary permissions, and configure
  /// platform-specific settings.
  ///
  /// On desktop platforms, this typically involves:
  /// - Setting up the local notification system
  /// - Configuring the app name and icon
  /// - Requesting notification permissions if needed
  ///
  /// Throws [PlatformException] if initialization fails.
  Future<void> initialize();

  /// Shows a basic notification with title and body.
  ///
  /// [title] The notification title (required)
  /// [body] The notification message content (required)
  /// [payload] Optional data that can be retrieved when notification is tapped
  ///
  /// This is the most basic notification method that can be used for
  /// any type of notification content.
  Future<void> showTimerNotification({
    required String title,
    required String body,
    required List<PomoNotificationAction> actions,
  });

  /// Shows a notification when a work session breaks starts.
  ///
  /// This is a convenience method that displays a pre-configured notification
  /// to inform the user that their work session has ended and it's time
  /// for a break.
  Future<void> showBreakNotification({VoidCallback? onAction});

  /// Shows a notification when break time ends and work should resume.
  ///
  /// This is a convenience method that displays a pre-configured notification
  /// to inform the user that their break is over and they should return
  /// to focused work.
  Future<void> showFocusNotification({VoidCallback? onAction});

  /// Shows a notification when an entire Pomodoro session is complete.
  ///
  /// This is displayed when the user has completed all work sessions
  /// and breaks in a full Pomodoro cycle.
  Future<void> showSessionCompleteNotification({VoidCallback? onAction});

  /// Shows a notification when a single Pomodoro work period is complete.
  ///
  /// [completedPomodoros] The total number of Pomodoros completed in the session
  ///
  /// This helps users track their progress through multiple Pomodoro cycles.
  Future<void> showPomodoroCompleteNotification({
    required int completedPomodoros,
    VoidCallback? onAction,
  });

  /// Shows a system tray notification for background app events.
  ///
  /// [title] The notification title (required)
  /// [body] The notification message content (required)
  ///
  /// This type of notification is typically used when the app is minimized
  /// or running in the background, ensuring the user still receives
  /// important timer notifications.
  Future<void> showSystemTrayNotification({
    required String title,
    required String body,
  });

  /// Cancels a specific notification by ID.
  ///
  /// [id] The unique identifier of the notification to cancel
  ///
  /// This can be used to remove scheduled notifications or dismiss
  /// active notifications programmatically.
  Future<void> cancelNotification(int id);

  /// Cancels all active and scheduled notifications.
  ///
  /// This is useful when the user wants to clear all pending notifications
  /// or when the app is being closed/reset.
  Future<void> cancelAllNotifications();

  /// Checks if notifications are enabled/permitted on the current platform.
  ///
  /// Returns `true` if the app has permission to show notifications,
  /// `false` otherwise. This can be used to prompt users to enable
  /// notifications if they're disabled.
  Future<bool> areNotificationsEnabled();

  /// Requests notification permissions from the user.
  ///
  /// Returns `true` if permission was granted, `false` if denied.
  /// On some platforms, this may open a system dialog asking for permission.
  ///
  /// This should be called if [areNotificationsEnabled] returns `false`
  /// and the app needs to show notifications.
  Future<bool> requestNotificationPermissions();
}

class PomoNotificationAction {
  final VoidCallback onAction;
  final String label;
  final String type;

  PomoNotificationAction({
    required this.onAction,
    required this.label,
    required this.type,
  });
}
