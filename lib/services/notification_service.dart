import 'dart:io';

import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  static late LocalNotifier _notificationService;

  Future<void> setup() async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      _notificationService = LocalNotifier.instance;

      await _notificationService.setup(appName: 'Flow Focus');
    }
  }
}
