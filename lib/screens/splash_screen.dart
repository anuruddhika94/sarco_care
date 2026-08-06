import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'login_screen.dart';

/// Screen #1 — Splash / welcome screen.
/// Pure UI: branded logo, tagline, elderly illustration placeholder and a
/// "Get Started" button that moves the user forward into the app.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _Logo(),
              const SizedBox(height: 40),
              const _CoupleIllustration(),
              const SizedBox(height: 40),
              Text(
                'App that cares for muscle\nhealth in the elderly',
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
                  child: const Text('Get Started'),
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
