import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusFlowDarkTheme {
  static const _background = Color(0xFF101323);
  static const _surface = Color(0xFF1C223C);
  static const _onSurface = Color(0xFFBFC2D1);
  static const _primary = Color(0xFF4F46E5);
  static const _track = Color(0xFF2E3868);
  static const _subtleText = Colors.white;
  static const _onPrimary = Colors.white;

  static ThemeData get theme {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: _onPrimary,
      secondary: _surface,
      onSecondary: _onPrimary,
      surface: _surface,
      onSurface: _onSurface,
      error: Colors.redAccent,
      onError: _onPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _background,
      colorScheme: colorScheme,

      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        bodyMedium: const TextStyle(color: _subtleText),
        labelLarge: const TextStyle(fontWeight: FontWeight.w600),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 48,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: _onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _primary,
        linearTrackColor: colorScheme.surface,
        linearMinHeight: 6,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: _surface,
          foregroundColor: _onPrimary,
          shape: const StadiumBorder(),
          side: const BorderSide(color: _track),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      iconTheme: const IconThemeData(color: _onPrimary),
      dividerColor: _track,
    );
  }
}

class FocusFlowLightTheme {
  // ─────────────────── Paleta extraída do mock ───────────────────
  static const _background = Color(0xFFF8F9FC); // cinza-gelo (#f8f9fc)
  static const _surface = Color(0xFFE6E9F3); // pill Skip + AppBar (#e6e9f3)
  static const _onSurface = Color(
    0xFF0F111E,
  ); // texto/ícone principal (quase-preto)
  static const _primary = Color(0xFF607AFB); // azul principal (#607afb)
  static const _secondary = Color(0xFFB0B5C9); // cinza claro (#b0b5c9)
  static const _onSecondary = Color(
    0xFF0F111E,
  ); // texto/ícone secundário (preto)
  static const _track = Color(0xFFD1D5EB); // trilho da barra de progresso
  static const _subtleText = Color(0xFF0F111E); // texto secundário
  static const _onPrimary = Colors.white;
  static const _onBg = Color(0xFF0F111E); // texto/ícone principal (quase-preto)

  static ThemeData get theme {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: _onPrimary,
        secondary: _secondary,
        onSecondary: _onSecondary,
        surface: _surface,
        onSurface: _onSurface,
        error: Colors.red,
        onError: _onPrimary,
      ),

      scaffoldBackgroundColor: _background,

      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        bodyMedium: const TextStyle(color: _subtleText),
        labelLarge: const TextStyle(fontWeight: FontWeight.w600),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 48,
          color: _subtleText,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _onBg,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: _onBg,
        ),
      ),

      // Barra de progresso
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primary,
        linearTrackColor: _track,
        linearMinHeight: 6,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: _surface,
          foregroundColor: _onBg,
          shape: const StadiumBorder(),
          side: const BorderSide(color: _track),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      iconTheme: const IconThemeData(color: _onBg),
      dividerColor: _track,
    );
  }
}
