import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_theme.dart';

/// Setup App — device and app settings opened from Profile.
/// The Language row switches the whole app between English and Thai.
class SetupAppScreen extends StatefulWidget {
  const SetupAppScreen({super.key});

  @override
  State<SetupAppScreen> createState() => _SetupAppScreenState();
}

class _SetupAppScreenState extends State<SetupAppScreen> {
  bool _largeText = true;
  bool _sound = true;

  Future<void> _pickLanguage() async {
    final current = Localizations.localeOf(context);
    final picked = await showModalBottomSheet<Locale>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _LanguagePicker(current: current),
    );
    if (picked != null) {
      await localeController.setLocale(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.entrySetupApp,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _ValueRow(
            icon: Icons.language,
            label: l10n.setupLanguage,
            value: LocaleController.nativeName(locale),
            onTap: _pickLanguage,
          ),
          const SizedBox(height: 12),
          _ValueRow(
            icon: Icons.devices_other,
            label: l10n.setupDeviceSetup,
            value: '',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ToggleRow(
            icon: Icons.text_fields,
            label: l10n.setupLargeText,
            value: _largeText,
            onChanged: (v) => setState(() => _largeText = v),
          ),
          const SizedBox(height: 12),
          _ToggleRow(
            icon: Icons.volume_up_outlined,
            label: l10n.setupSound,
            value: _sound,
            onChanged: (v) => setState(() => _sound = v),
          ),
        ],
      ),
    );
  }
}

/// Bottom-sheet language chooser. Returns the picked [Locale] (or null).
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.current});
  final Locale current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectLanguage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            for (final locale in LocaleController.supported)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  LocaleController.nativeName(locale),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                trailing: locale.languageCode == current.languageCode
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(locale),
              ),
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
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
              _IconBox(icon: icon),
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
              if (value.isNotEmpty)
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted),
                ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          _IconBox(icon: icon),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary, size: 24),
    );
  }
}
