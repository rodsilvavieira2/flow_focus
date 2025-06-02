import 'dart:io';

import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class SystemTrayService {
  final SystemTray _systemTray = SystemTray();
  bool _isInitialized = false;

  Future<void> initSystemTray() async {
    if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) {
      return;
    }

    if (_isInitialized) return;

    await _systemTray.initSystemTray(
      title: "Flow Focus",
      iconPath: _getIconPath(),
    );

    // Create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Mostrar', onClicked: (menuItem) => _showWindow()),
      MenuItemLabel(label: 'Sair', onClicked: (menuItem) => _exitApp()),
    ]);

    await _systemTray.setContextMenu(menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        _showWindow();
      }
    });

    _isInitialized = true;
  }

  String _getIconPath() {
    if (Platform.isLinux) {
      // Try to use a system icon or absolute path in release builds
      final iconPath = Platform.resolvedExecutable.replaceAll(
        '/flow_focus',
        '/data/flutter_assets/assets/icons/focusFlow.png',
      );
      if (File(iconPath).existsSync()) {
        return iconPath;
      }
      // Fallback to a system icon
      return '/usr/share/icons/hicolor/48x48/apps/application-default-icon.png';
    }
    return 'assets/icons/focusFlow.png';
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _exitApp() async {
    await _systemTray.destroy();
    exit(0);
  }

  Future<void> hideToTray() async {
    await windowManager.hide();
  }

  Future<void> destroy() async {
    if (_isInitialized) {
      await _systemTray.destroy();
      _isInitialized = false;
    }
  }
}
