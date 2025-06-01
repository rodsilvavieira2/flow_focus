import 'dart:io';

import 'package:flow_focus/interface/notification_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService implements INotificationService {
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
    required List<PomoNotificationAction> actions,
  }) async {
    LocalNotification notification = LocalNotification(
      title: title,
      body: body,
    );

    if (actions.isNotEmpty) {
      notification.actions = actions
          .map(
            (action) =>
                LocalNotificationAction(text: action.label, type: action.type),
          )
          .toList();

      notification.onClickAction = (indexAction) {
        var action = notification.actions?[indexAction];

        if (action == null) return;

        PomoNotificationAction configAction = actions.firstWhere(
          (it) => it.type == action.type,
        );

        configAction.onAction();
      };
    }

    await notification.show();
  }

  @override
  Future<void> showBreakNotification({VoidCallback? onAction}) async {
    await showTimerNotification(
      title: 'Break Time! 🎉',
      body: 'Time for a well-deserved break. Step away from your work.',
      actions: [],
    );
  }

  @override
  Future<void> showFocusNotification({VoidCallback? onAction}) async {
    await showTimerNotification(
      title: 'Focus Time! 🎯',
      body: 'Break is over. Time to get back to focused work.',
      actions: [],
    );
  }

  @override
  Future<void> showSessionCompleteNotification({VoidCallback? onAction}) async {
    await showTimerNotification(
      title: 'Session Complete! ✨',
      body: 'Great job! You\'ve completed your focus session.',
      actions: [],
    );
  }

  @override
  Future<void> showPomodoroCompleteNotification({
    required int completedPomodoros,
    VoidCallback? onAction,
  }) async {
    await showTimerNotification(
      title: 'Pomodoro Complete! 🍅',
      body:
          'You\'ve completed $completedPomodoros pomodoro${completedPomodoros > 1 ? 's' : ''}.',
      actions: [],
    );
    if (onAction != null) {
      onAction();
    }
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
