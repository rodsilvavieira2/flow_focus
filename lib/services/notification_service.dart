import 'dart:io';

import 'package:flow_focus/interface/notification_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService implements INotificationService {
  @override
  Future<void> initialize() async {
    await localNotifier.setup(appName: 'Flow Focus');
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
      silent: false,
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
    var actions = <PomoNotificationAction>[];

    if (onAction != null) {
      actions.add(
        PomoNotificationAction(
          label: 'Start',
          type: "start_action",
          onAction: onAction,
        ),
      );
    }

    await showTimerNotification(
      title: 'Break Time! 🎉',
      body: 'Time for a well-deserved break. Step away from your work.',
      actions: actions,
    );
  }

  @override
  Future<void> showFocusNotification({VoidCallback? onAction}) async {
    var actions = <PomoNotificationAction>[];

    if (onAction != null) {
      actions.add(
        PomoNotificationAction(
          label: 'Start',
          type: "start_action",
          onAction: onAction,
        ),
      );
    }

    await showTimerNotification(
      title: 'Focus Time! 🎯',
      body: 'Break is over. Time to get back to focused work.',
      actions: actions,
    );
  }

  @override
  Future<void> showSessionCompleteNotification({VoidCallback? onAction}) async {
    var actions = <PomoNotificationAction>[];

    if (onAction != null) {
      actions.add(
        PomoNotificationAction(
          label: 'Start',
          type: "start_action",
          onAction: onAction,
        ),
      );
    }

    await showTimerNotification(
      title: 'Session Complete! ✨',
      body: 'Great work! You have completed your focus session.',
      actions: actions,
    );
  }

  @override
  Future<void> showPomodoroCompleteNotification({
    required int completedPomodoros,
    VoidCallback? onAction,
  }) async {
    var actions = <PomoNotificationAction>[];

    if (onAction != null) {
      actions.add(
        PomoNotificationAction(
          label: 'Start',
          type: "start_action",
          onAction: onAction,
        ),
      );
    }

    await showTimerNotification(
      title: 'Pomodoro Complete! 🍅',
      body:
          'You completed $completedPomodoros pomodoro${completedPomodoros > 1 ? 's' : ''}.',
      actions: actions,
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
