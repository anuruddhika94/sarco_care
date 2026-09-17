import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Add Patient (caretaker side) — find a patient by phone (`GET
/// /care_links/lookup`) and send a link request (`POST /care_links`). The
/// patient approves on their own device (see HomeScreen's request banner).
class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _searching = false;
  bool _sending = false;
  bool _requestSent = false;
  Map<String, dynamic>? _found;
  String? _searchError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _searching = true;
      _searchError = null;
      _found = null;
      _requestSent = false;
    });
    try {
      final patient = await apiClient.get('/care_links/lookup', query: {
        'phone_number': _controller.text.trim(),
      }) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() => _found = patient);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _searchError = e.message);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _sendRequest() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      await apiClient.post('/care_links', body: {
        'phone_number': _found!['phone_number'],
      });
      if (!mounted) return;
      setState(() => _requestSent = true);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.requestSentWaiting),
            backgroundColor: AppColors.primary,
          ),
        );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasQuery = _controller.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.addPatient,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.findByPhoneDesc,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: l10n.phoneNumber,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE4DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (hasQuery && !_searching) ? _search : null,
              child: _searching
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(l10n.search),
            ),
          ),
          const SizedBox(height: 24),
          if (_searchError != null)
            Text(
              _searchError!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          if (_found != null)
            _ResultCard(
              patient: _found!,
              sent: _requestSent,
              sending: _sending,
              onSendRequest: _sendRequest,
            ),
        ],
      ),
    );
  }
}

/// The found patient card, with a "Send Request" action.
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.patient,
    required this.sent,
    required this.sending,
    required this.onSendRequest,
  });
  final Map<String, dynamic> patient;
  final bool sent;
  final bool sending;
  final VoidCallback onSendRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final age = patient['age'] as int?;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.softGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.elderly, color: AppColors.primary, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['full_name'] as String,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.ageLabel(age),
                        style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: sent
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          l10n.pendingApproval,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: sending ? null : onSendRequest,
                    child: sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : Text(l10n.sendRequest),
                  ),
          ),
        ],
      ),
    );
  }
}
