import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';

/// Caretaker — the linked caregiver account opened from Profile.
/// Pure UI: a linked caretaker card and an Add Caretaker action.
class CaretakerScreen extends StatelessWidget {
  const CaretakerScreen({super.key});

  void _addCaretaker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.inviteSent),
          backgroundColor: AppColors.primary,
        ),
      );
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
        title: Text(
          l10n.entryCaretaker,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.linkedCaretaker,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          _CaretakerCard(
            name: l10n.caretakerFullName,
            relationship: l10n.relationshipDaughter,
            phone: '089 876 5432',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _addCaretaker(context),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.addCaretaker),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(56),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaretakerCard extends StatelessWidget {
  const _CaretakerCard({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  final String name;
  final String relationship;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          const AppAvatar(
            asset: 'assets/images/avatars/malee.png',
            fallbackIcon: Icons.person,
            size: 56,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  relationship,
                  style: TextStyle(fontSize: 14, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.call_outlined, color: AppColors.primary),
        ],
      ),
    );
  }
}
