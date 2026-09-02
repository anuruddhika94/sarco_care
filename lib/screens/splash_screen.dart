import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

/// Screen #1 — Splash / welcome screen.
/// Pure UI: branded logo, tagline, elderly illustration placeholder and a
/// "Get Started" button that moves the user forward into the app.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: _LanguageToggle(),
              ),
              const Spacer(flex: 2),
              const _Logo(),
              const SizedBox(height: 40),
              const _CoupleIllustration(),
              const SizedBox(height: 40),
              Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onGetStarted(context),
                  child: Text(l10n.getStarted),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _onGetStarted(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

/// Compact English/Thai toggle shown on the splash so users can pick their
/// language before entering the app. Switching rebuilds the whole app live.
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final locale in LocaleController.supported)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => localeController.setLocale(locale),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: locale.languageCode == current.languageCode
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  LocaleController.nativeName(locale),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: locale.languageCode == current.languageCode
                        ? Colors.white
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// SARCO CARE wordmark with a leaf accent.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SARCO',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'CARE',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.eco, color: AppColors.primary, size: 30),
      ],
    );
  }
}

/// Placeholder for the elderly-couple artwork in the design.
/// Swap for an Image asset once the illustration is available.
class _CoupleIllustration extends StatelessWidget {
  const _CoupleIllustration();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/splash_couple.png',
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.elderly_woman, size: 96, color: AppColors.primary),
              Icon(Icons.elderly, size: 96, color: AppColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }
}
