import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AskBytes visual language: dark, high contrast, one electric accent.
class AppColors {
  static const background = Color(0xFF0B0F1A);
  static const surface = Color(0xFF131A2B);
  static const surfaceHigh = Color(0xFF1B2440);
  static const outline = Color(0xFF2A3558);
  static const accent = Color(0xFF5EE1FF);
  static const accentAlt = Color(0xFF8B7BFF);
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const textMuted = Color(0xFF93A0C4);

  static const gradient = LinearGradient(
    colors: [accent, accentAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

ThemeData buildTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
      ).copyWith(
        surface: AppColors.surface,
        primary: AppColors.accent,
        onPrimary: AppColors.background,
        secondary: AppColors.accentAlt,
        error: AppColors.danger,
      );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.outline),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.6),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
