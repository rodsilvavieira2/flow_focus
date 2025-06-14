import 'dart:io';

import 'package:flow_focus/interface/tray_service.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayService with TrayListener implements ITrayService {
  VoidCallback? _onShow;
  VoidCallback? _onQuit;

  @override
  Future<void> initialize({
    required VoidCallback onShow,
    required VoidCallback onQuit,
  }) async {
    _onShow = onShow;
    _onQuit = onQuit;
    trayManager.addListener(this);

    final String iconPath = Platform.isWindows
        ? 'assets/icons/app_icon.ico'
        : 'assets/icons/app_icon.png';
    await trayManager.setIcon(iconPath);
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'show', label: 'Show'),
          MenuItem.separator(),
          MenuItem(key: 'quit', label: 'Quit'),
        ],
      ),
    );
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        _onShow?.call();
        break;
      case 'quit':
        _onQuit?.call();
        break;
    }
  }

  @override
  Future<void> destroy() async {
    trayManager.removeListener(this);
    await trayManager.destroy();
  }
}
