import 'dart:io';

import 'package:flow_focus/interface/notification_service.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService implements INotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  @override
  Future<void> initialize() async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await localNotifier.setup(
        appName: 'Flow Focus',
        shortcutPolicy: ShortcutPolicy.requireCreate,
      );
    }
  }

  @override
  Future<void> showTimerNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      LocalNotification notification = LocalNotification(
        title: title,
        body: body,
        silent: false,
      );

      if (Platform.isMacOS) {
        notification.actions = [LocalNotificationAction(text: 'OK')];
      }

      await notification.show();
    }
  }

  @override
  Future<void> showBreakNotification() async {
    await showTimerNotification(
      title: 'Break Time! 🎉',
      body: 'Time for a well-deserved break. Step away from your work.',
    );
  }

  @override
  Future<void> showFocusNotification() async {
    await showTimerNotification(
      title: 'Focus Time! 🎯',
      body: 'Break is over. Time to get back to focused work.',
    );
  }

  @override
  Future<void> showSessionCompleteNotification() async {
    await showTimerNotification(
      title: 'Session Complete! ✨',
      body: 'Great job! You\'ve completed your focus session.',
    );
  }

  @override
  Future<void> showPomodoroCompleteNotification(int completedPomodoros) async {
    await showTimerNotification(
      title: 'Pomodoro Complete! 🍅',
      body:
          'You\'ve completed $completedPomodoros pomodoro${completedPomodoros > 1 ? 's' : ''}.',
    );
  }

  @override
  Future<void> showSystemTrayNotification({
    required String title,
    required String body,
  }) async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      LocalNotification notification = LocalNotification(
        title: title,
        body: body,
        silent: false,
      );

      await notification.show();
    }
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await showTimerNotification(title: title, body: body, payload: payload);
  }

  @override
  Future<void> cancelNotification(int id) async {}

  @override
  Future<void> cancelAllNotifications() async {}

  @override
  Future<bool> areNotificationsEnabled() async {
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  @override
  Future<bool> requestNotificationPermissions() async {
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }
}
