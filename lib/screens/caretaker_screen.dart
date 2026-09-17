import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../auth/auth_controller.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';

/// Caretaker — the linked caregiver(s) opened from Profile, loaded from
/// `GET /care_links?status=approved`. A caretaker links to a patient (not
/// the other way around, see AddPatientScreen), so "Add Caretaker" shows the
/// patient's own phone number to share instead of sending a request.
class CaretakerScreen extends StatefulWidget {
  const CaretakerScreen({super.key});

  @override
  State<CaretakerScreen> createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
  List<Map<String, dynamic>>? _links;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await apiClient.get('/care_links', query: {'status': 'approved'});
      if (!mounted) return;
      setState(() => _links = (data as List).cast<Map<String, dynamic>>());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  void _showPhoneNumber(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = authController.currentUser?.phoneNumber ?? '';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareYourPhoneTitle),
        content: Text(l10n.shareYourPhoneBody(phone)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
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
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }
    final links = _links;
    if (links == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.linkedCaretaker,
          style: TextStyle(fontSize: 15, color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        if (links.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l10n.noCaretakersYet,
              style: TextStyle(color: AppColors.textMuted, fontSize: 15),
            ),
          )
        else
          for (final link in links)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CaretakerCard(
                name: (link['caretaker'] as Map<String, dynamic>)['full_name'] as String,
                relationship: link['relationship'] as String?,
              ),
            ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showPhoneNumber(context),
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
    );
  }
}

class _CaretakerCard extends StatelessWidget {
  const _CaretakerCard({required this.name, required this.relationship});

  final String name;
  final String? relationship;

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
            asset: null,
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
                if (relationship != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    relationship!,
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
