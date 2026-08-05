import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Add Patient (caretaker side) — find a patient by phone and send a link
/// request. Pure UI: mock search reveals a result card; sending a request
/// moves it to a pending state (the patient approves on their device).
class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _searched = false;
  bool _requestSent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searched = true;
      _requestSent = false;
    });
  }

  void _sendRequest() {
    setState(() => _requestSent = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Request sent · waiting for approval'),
          backgroundColor: AppColors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _controller.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Add Patient',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Find a patient by their phone number. They will get a request to '
            'approve you as their caretaker.',
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
              hintText: 'Phone number',
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
              onPressed: hasQuery ? _search : null,
              child: const Text('Search'),
            ),
          ),
          const SizedBox(height: 24),
          if (_searched) _ResultCard(
            sent: _requestSent,
            onSendRequest: _sendRequest,
          ),
        ],
      ),
    );
  }
}

/// Mock search result — one found patient. Name is shown so the caretaker can
/// confirm the right person before sending a request.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.sent, required this.onSendRequest});
  final bool sent;
  final VoidCallback onSendRequest;

  @override
  Widget build(BuildContext context) {
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
                      'Somchai Jai-Dee',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Age 72',
                      style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                    ),
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
                          'Pending approval',
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
                    onPressed: onSendRequest,
                    child: const Text('Send Request'),
                  ),
          ),
        ],
      ),
    );
  }
}
