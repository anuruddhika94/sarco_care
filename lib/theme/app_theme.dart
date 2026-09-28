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

  /// Hairline borders and dividers.
  static const Color border = Color(0xFFE8EDE8);

  /// Destructive actions and error states.
  static const Color danger = Color(0xFFB0524B);

  /// Bright blue used for the floating chat bubble so it stands out against
  /// the green-dominant palette.
  static const Color accent = Color(0xFF2F80ED);
}


/// Corner radii. Four steps instead of the eight ad-hoc values the screens
/// grew: chips and fields, buttons and small cards, cards, and hero blocks.
class AppRadius {
  AppRadius._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;

  static BorderRadius get small => BorderRadius.circular(sm);
  static BorderRadius get medium => BorderRadius.circular(md);
  static BorderRadius get large => BorderRadius.circular(lg);
  static BorderRadius get extraLarge => BorderRadius.circular(xl);
}

/// The spacing scale. Gaps between elements should come from here so screens
/// share a rhythm rather than each picking its own numbers.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// The standard left/right page margin.
  static const double page = 20;
}

/// Soft, warm-tinted elevation. Pure black shadows look grey and dirty on the
/// cream background, so these are tinted with the text colour instead.
class AppShadows {
  AppShadows._();

  /// Cards at rest.
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F2B3A2F), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x0A2B3A2F), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Something lifted: a pressed card, a bottom sheet, a floating control.
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x1A2B3A2F), blurRadius: 28, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x0D2B3A2F), blurRadius: 3, offset: Offset(0, 1)),
  ];
}

/// The type scale. Sizes are deliberately a step larger than a typical app:
/// the audience is older adults, and Large Text is on by default on top of
/// this.
class AppText {
  AppText._();

  static const TextStyle display = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800, height: 1.2,
    letterSpacing: -0.4, color: AppColors.textDark,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w800, height: 1.25,
    letterSpacing: -0.2, color: AppColors.textDark,
  );
  static const TextStyle title = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, height: 1.3,
    color: AppColors.textDark,
  );
  static const TextStyle body = TextStyle(
    fontSize: 16, height: 1.45, color: AppColors.textDark,
  );
  static const TextStyle bodyMuted = TextStyle(
    fontSize: 15, height: 1.4, color: AppColors.textMuted,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600, height: 1.2,
    letterSpacing: 0.1, color: AppColors.textMuted,
  );
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
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      // Flat, filled fields read more clearly than outlined ones at this text
      // size, and the focus ring is unmistakable.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppText.bodyMuted,
        border: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        contentTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        titleTextStyle: AppText.title,
        contentTextStyle: AppText.body,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border, thickness: 1, space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: AppText.body,
        subtitleTextStyle: AppText.bodyMuted,
        iconColor: AppColors.primary,
      ),
    );
  }
}
