import 'package:flutter/material.dart';

abstract class IThemeProvider {
  Future<void> init();

  ThemeMode get currentTheme;

  Future<void> onChangeThemeMode(ThemeMode input);
}
