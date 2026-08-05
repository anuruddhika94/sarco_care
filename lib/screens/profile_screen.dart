import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';
import 'caretaker_screen.dart';
import 'personal_info_screen.dart';
import 'setup_app_screen.dart';

/// Profile tab — user summary, settings entries and Log Out.
/// Pure UI: rows open placeholders; Log Out returns to the app entry (Splash).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _entries = [
    (Icons.person_outline, 'Personal Info'),
    (Icons.people_alt_outlined, 'Caretaker'),
    (Icons.settings_outlined, 'Setup App'),
  ];

  void _open(BuildContext context, String title) {
    final WidgetBuilder builder = switch (title) {
      'Personal Info' => (_) => const PersonalInfoScreen(),
      'Caretaker' => (_) => const CaretakerScreen(),
      'Setup App' => (_) => const SetupAppScreen(),
      _ => (_) => PlaceholderScreen(title: title),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  void _logOut(BuildContext context) {
    // Unwind back to the first route (Splash), clearing the logged-in stack.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const SizedBox(height: 8),
          // Avatar placeholder.
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.elderly, size: 60, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mr. Somchai Jai-Dee',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Age: 72',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 28),
          for (final e in _entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SettingsRow(
                icon: e.$1,
                label: e.$2,
                onTap: () => _open(context, e.$2),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _logOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
