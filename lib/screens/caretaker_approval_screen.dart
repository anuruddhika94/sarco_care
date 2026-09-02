import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Caretaker Request (patient side) — approve or decline a caretaker who asked
/// to link. Pure UI: returns true (approved) or false (declined) to the caller.
class CaretakerApprovalScreen extends StatelessWidget {
  const CaretakerApprovalScreen({super.key, required this.caretakerName});

  final String caretakerName;

  void _respond(BuildContext context, bool approved) {
    Navigator.of(context).pop(approved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final access = [
      l10n.access1,
      l10n.access2,
      l10n.access3,
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.caretakerRequest,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_alt, size: 48, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.caretakerWantsToBe(caretakerName),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.3,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ifApproveThey,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEAEFEA)),
            ),
            child: Column(
              children: [
                for (final line in access) _AccessLine(text: line),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => _respond(context, true),
            child: Text(l10n.approve),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _respond(context, false),
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
            child: Text(l10n.decline),
          ),
        ],
      ),
    );
  }
}

class _AccessLine extends StatelessWidget {
  const _AccessLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.3,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
