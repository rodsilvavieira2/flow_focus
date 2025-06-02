import 'package:flow_focus/interface/settings_service.dart';
import 'package:flow_focus/interface/theme_provider.dart';
import 'package:flutter/material.dart';

class ThemeModelProvider extends ChangeNotifier implements IThemeProvider {
  ThemeMode _themeMode = ThemeMode.system;

  final ISettingsService _settingsService;

  ThemeModelProvider(this._settingsService) {
    init();
  }

  @override
  ThemeMode get currentTheme => _themeMode;

  @override
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  bool get isLightMode => _themeMode == ThemeMode.light;

  @override
  bool get isSystemMode => _themeMode == ThemeMode.system;

  @override
  Future<void> onChangeThemeMode(ThemeMode mode) async {
    await _settingsService.setThemeMode(mode);
    _themeMode = mode;
    notifyListeners();
  }

  @override
  Future<void> init() async {
    var themeMode = await _settingsService.getThemeMode();

    _themeMode = themeMode;

    notifyListeners();
  }

  @override
  Image loadThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Image.asset("assets/icons/app_icon.png", height: 32, width: 32);
      case ThemeMode.dark:
        return Image.asset("assets/icons/app_icon.png", height: 32, width: 32);
      case ThemeMode.system:
        return Image.asset("assets/icons/app_icon.png", height: 32, width: 32);
    }
  }
}
