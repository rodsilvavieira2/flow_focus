import 'package:flow_focus/interface/settings_service.dart';
import 'package:flow_focus/interface/theme_provider.dart';
import 'package:flutter/material.dart';

class ThemeModelProvider extends ChangeNotifier implements IThemeProvider {
  final ISettingsService _settingsService;

  ThemeModelProvider(this._settingsService);

  @override
  get currentTheme => _settingsService.getThemeMode();

  @override
  Future<void> onChangeThemeMode(ThemeMode mode) async {
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }
}
