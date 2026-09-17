import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Add Data form — log health measurements for a chosen date, synced to
/// `POST /health_readings` (one reading per date; posting again for the same
/// date updates it).
class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key, required this.initialDate, this.existing, this.patientId});

  final DateTime initialDate;

  /// The existing reading for [initialDate], if any, to prefill the fields.
  final Map<String, dynamic>? existing;

  /// Set when a caretaker is logging data for a linked patient.
  final int? patientId;

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  late DateTime _date = widget.initialDate;
  late final _weightController = TextEditingController(text: _fieldText('weight_kg'));
  late final _heightController = TextEditingController(text: _fieldText('height_cm'));
  late final _calfController = TextEditingController(text: _fieldText('calf_cm'));
  bool _saving = false;

  String _fieldText(String key) {
    final value = widget.existing?[key];
    return value == null ? '' : value.toString();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _calfController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    try {
      await apiClient.post('/health_readings', body: {
        'recorded_on': DateFormat('yyyy-MM-dd').format(_date),
        if (_weightController.text.trim().isNotEmpty) 'weight_kg': double.tryParse(_weightController.text.trim()),
        if (_heightController.text.trim().isNotEmpty) 'height_cm': double.tryParse(_heightController.text.trim()),
        if (_calfController.text.trim().isNotEmpty) 'calf_cm': double.tryParse(_calfController.text.trim()),
        if (widget.patientId != null) 'patient_id': widget.patientId,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.healthDataSaved),
            backgroundColor: AppColors.primary,
          ),
        );
      Navigator.of(context).pop(DateFormat('yyyy-MM-dd').format(_date));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fields = <(String, String, IconData, TextEditingController)>[
      (l10n.metricWeight, 'kg', Icons.monitor_weight_outlined, _weightController),
      (l10n.metricHeight, 'cm', Icons.height, _heightController),
      (l10n.metricCalf, 'cm', Icons.straighten, _calfController),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.addData,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _DateRow(date: _date, onTap: _pickDate),
          const SizedBox(height: 20),
          for (final f in fields) ...[
            _MetricField(label: f.$1, unit: f.$2, icon: f.$3, controller: f.$4),
            const SizedBox(height: 18),
          ],
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
      ),
    );
  }
}

/// Tappable date row — opens a date picker so the entry can be logged for any
/// past date, not just today.
class _DateRow extends StatelessWidget {
  const _DateRow({required this.date, required this.onTap});
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 22),
              const SizedBox(width: 14),
              Text(
                isToday ? l10n.dateToday : DateFormat.yMMMd().format(date),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Icon(Icons.expand_more, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({
    required this.label,
    required this.unit,
    required this.icon,
    required this.controller,
  });

  final String label;
  final String unit;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: l10n.enterValueHint(label).toLowerCase(),
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(icon, color: AppColors.textMuted),
            suffixText: unit,
            suffixStyle: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
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
