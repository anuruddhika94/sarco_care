import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Add Data form — log new health measurements.
/// Pure UI: labeled numeric fields and a Save action that confirms and returns.
class AddDataScreen extends StatelessWidget {
  const AddDataScreen({super.key});

  static const _fields = [
    ('Weight', 'kg', Icons.monitor_weight_outlined),
    ('Height', 'cm', Icons.height),
    ('Calf Circumference', 'cm', Icons.straighten),
    ('Handgrip', 'kg', Icons.back_hand_outlined),
  ];

  void _save(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Health data saved'),
          backgroundColor: AppColors.primary,
        ),
      );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Add Data',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const _DateRow(),
          const SizedBox(height: 20),
          for (final f in _fields) ...[
            _MetricField(label: f.$1, unit: f.$2, icon: f.$3),
            const SizedBox(height: 18),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _save(context),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Read-only "today" row — a full date picker is out of scope for pure UI.
class _DateRow extends StatelessWidget {
  const _DateRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({
    required this.label,
    required this.unit,
    required this.icon,
  });

  final String label;
  final String unit;
  final IconData icon;

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
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Enter $label'.toLowerCase(),
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
