import 'package:flutter/material.dart';

abstract class IThemeProvider {
  Future<ThemeMode> get currentTheme;

  Future<void> onChangeThemeMode(ThemeMode input);
}
