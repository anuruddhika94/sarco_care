import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Personal Info — editable profile fields opened from Profile, loaded from
/// and saved to `GET`/`PATCH /me`.
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

const _genders = ['male', 'female', 'other'];

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  String? _gender;
  String _phoneNumber = '';
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final me = await apiClient.get('/me') as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _nameController.text = me['full_name'] as String;
        _emailController.text = (me['email'] as String?) ?? '';
        _ageController.text = me['age'] == null ? '' : (me['age'] as int).toString();
        _gender = me['gender'] as String?;
        _phoneNumber = me['phone_number'] as String;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final age = int.tryParse(_ageController.text.trim());
    try {
      await apiClient.patch('/me', body: {
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'gender': _gender,
        if (age != null) 'date_of_birth': _dateOfBirthFor(age),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.profileUpdated), backgroundColor: AppColors.primary),
        );
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  String _dateOfBirthFor(int age) {
    final now = DateTime.now();
    return DateTime(now.year - age, now.month, now.day).toIso8601String().split('T').first;
  }

  String _genderLabel(AppLocalizations l10n, String gender) => switch (gender) {
        'male' => l10n.genderMale,
        'female' => l10n.genderFemale,
        _ => l10n.genderOther,
      };

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
          l10n.entryPersonalInfo,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _LabeledField(label: l10n.fullName, controller: _nameController),
        const SizedBox(height: 18),
        _LabeledField(
          label: l10n.fieldAge,
          controller: _ageController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 18),
        _GenderField(
          label: l10n.fieldGender,
          value: _gender,
          onChanged: (v) => setState(() => _gender = v),
          labelFor: (g) => _genderLabel(l10n, g),
        ),
        const SizedBox(height: 18),
        _LabeledField(label: l10n.phoneNumber, initial: _phoneNumber, enabled: false),
        const SizedBox(height: 18),
        _LabeledField(label: l10n.fieldEmail, controller: _emailController),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : Text(l10n.save),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    this.controller,
    this.initial,
    this.enabled = true,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final String? initial;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initial : null,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColors.surface : const Color(0xFFF2F2EE),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDE4DD)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDE4DD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  const _GenderField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.labelFor,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String Function(String) labelFor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: [
            for (final g in _genders) DropdownMenuItem(value: g, child: Text(labelFor(g))),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      ],
    );
  }
}
