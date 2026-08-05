import 'package:flutter/material.dart';

/// Central colors + theme for SarcoCare.
/// Kept in one place so every screen we build stays visually consistent.
class AppColors {
  AppColors._();

  /// Primary forest green used for buttons, logo and headings.
  static const Color primary = Color(0xFF3B8B5F);
  static const Color primaryDark = Color(0xFF2E6B49);

  /// Warm cream app background from the design.
  static const Color background = Color(0xFFFAF6EC);

  /// Card / surface background.
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textDark = Color(0xFF2B3A2F);
  static const Color textMuted = Color(0xFF6B7B70);

  /// Soft green used for illustration/placeholder blocks.
  static const Color softGreen = Color(0xFFE4EFE7);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      // Large, high-contrast defaults suit the elderly audience.
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
