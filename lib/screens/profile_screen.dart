import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';
import 'caretaker_screen.dart';
import 'personal_info_screen.dart';
import 'setup_app_screen.dart';
import 'usage_summary_screen.dart';

/// The Profile settings rows. The enum keeps navigation independent of the
/// (translated) row label.
enum ProfileEntry { personalInfo, usageSummary, caretaker, setupApp }

/// Profile tab — user summary, settings entries and Log Out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _entryIcons = {
    ProfileEntry.personalInfo: Icons.person_outline,
    ProfileEntry.usageSummary: Icons.insights_outlined,
    ProfileEntry.caretaker: Icons.people_alt_outlined,
    ProfileEntry.setupApp: Icons.settings_outlined,
  };

  String _label(AppLocalizations l10n, ProfileEntry entry) => switch (entry) {
        ProfileEntry.personalInfo => l10n.entryPersonalInfo,
        ProfileEntry.usageSummary => l10n.entryUsageSummary,
        ProfileEntry.caretaker => l10n.entryCaretaker,
        ProfileEntry.setupApp => l10n.entrySetupApp,
      };

  void _open(BuildContext context, ProfileEntry entry) {
    final WidgetBuilder builder = switch (entry) {
      ProfileEntry.personalInfo => (_) => const PersonalInfoScreen(),
      ProfileEntry.usageSummary => (_) => const UsageSummaryScreen(),
      ProfileEntry.caretaker => (_) => const CaretakerScreen(),
      ProfileEntry.setupApp => (_) => const SetupAppScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  void _logOut(BuildContext context) {
    // Unwind back to the first route (Splash), clearing the logged-in stack.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.navProfile,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: AppAvatar(
              asset: 'assets/images/avatars/somchai.png',
              fallbackIcon: Icons.elderly,
              size: 110,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.userFullNameTitled,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.profileAge(72),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 28),
          for (final entry in ProfileEntry.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SettingsRow(
                icon: _entryIcons[entry]!,
                label: _label(l10n, entry),
                onTap: () => _open(context, entry),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _logOut(context),
              icon: const Icon(Icons.logout),
              label: Text(l10n.logOut),
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
