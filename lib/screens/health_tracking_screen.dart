import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'add_data_screen.dart';

/// Screen #10 — General Information Record (health tracking).
/// Loads the patient's readings from `GET /health_readings`, defaults to the
/// most recent one, and lets the date picker jump to any other recorded day.
/// [patientId] lets a caretaker view a linked patient's data instead of their
/// own (the API rejects the request unless there's an approved care link).
class HealthTrackingScreen extends StatefulWidget {
  const HealthTrackingScreen({super.key, this.showBackButton = true, this.patientId});

  /// False when shown as a shell tab root (no route to pop back to).
  final bool showBackButton;
  final int? patientId;

  @override
  State<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  List<Map<String, dynamic>>? _readings;
  String? _error;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({DateTime? selectDate}) async {
    setState(() => _error = null);
    try {
      final data = await apiClient.get('/health_readings', query: _patientQuery);
      if (!mounted) return;
      final readings = (data as List).cast<Map<String, dynamic>>();
      setState(() {
        _readings = readings;
        _selectedDate = selectDate ??
            (readings.isEmpty ? DateTime.now() : DateTime.parse(readings.first['recorded_on'] as String));
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  Map<String, String>? get _patientQuery =>
      widget.patientId == null ? null : {'patient_id': '${widget.patientId}'};

  Map<String, dynamic>? get _selectedReading {
    final readings = _readings;
    final date = _selectedDate;
    if (readings == null || date == null) return null;
    for (final r in readings) {
      final recorded = DateTime.parse(r['recorded_on'] as String);
      if (recorded.year == date.year && recorded.month == date.month && recorded.day == date.day) {
        return r;
      }
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _addData() async {
    final saved = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => AddDataScreen(
          initialDate: _selectedDate ?? DateTime.now(),
          existing: _selectedReading,
          patientId: widget.patientId,
        ),
      ),
    );
    if (saved == null) return;
    await _load(selectDate: DateTime.parse(saved));
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
        automaticallyImplyLeading: widget.showBackButton,
        title: Text(
          l10n.featureHealthTracking,
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
              OutlinedButton(onPressed: () => _load(), child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }
    if (_readings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final reading = _selectedReading;
    final isToday = _selectedDate != null && DateUtils.isSameDay(_selectedDate, DateTime.now());
    final metrics = reading == null
        ? const <_Metric>[]
        : [
            _Metric(MetricKind.weight, reading['weight_kg'], 'kg', Icons.monitor_weight_outlined),
            _Metric(MetricKind.height, reading['height_cm'], 'cm', Icons.height),
            _Metric(MetricKind.bmi, reading['bmi'], '', Icons.calculate_outlined, normal: _isNormalBmi(reading['bmi'])),
            _Metric(MetricKind.calf, reading['calf_cm'], 'cm', Icons.straighten),
          ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: _DateSelector(
            date: _selectedDate ?? DateTime.now(),
            isToday: isToday,
            onTap: _pickDate,
          ),
        ),
        Expanded(
          child: reading == null
              ? Center(
                  child: Text(
                    l10n.noDataForDate,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
                    for (final m in metrics)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MetricRow(metric: m),
                      ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addData,
              icon: const Icon(Icons.add),
              label: Text(l10n.addData),
            ),
          ),
        ),
      ],
    );
  }

  bool _isNormalBmi(dynamic bmi) {
    if (bmi == null) return false;
    final value = double.tryParse(bmi.toString());
    return value != null && value >= 18.5 && value < 23;
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.date, required this.isToday, required this.onTap});
  final DateTime date;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
              const Spacer(),
              Text(
                l10n.changeDate,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              Icon(Icons.expand_more, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

enum MetricKind { weight, height, bmi, calf }

String metricLabel(AppLocalizations l10n, MetricKind kind) => switch (kind) {
      MetricKind.weight => l10n.metricWeight,
      MetricKind.height => l10n.metricHeight,
      MetricKind.bmi => l10n.metricBmi,
      MetricKind.calf => l10n.metricCalf,
    };

class _Metric {
  const _Metric(this.kind, this.rawValue, this.unit, this.icon, {this.normal = false});
  final MetricKind kind;
  final dynamic rawValue;
  final String unit;
  final IconData icon;
  final bool normal;

  String get value {
    if (rawValue == null) return '—';
    if (kind == MetricKind.bmi) return rawValue.toString();
    final n = double.tryParse(rawValue.toString());
    return n == null ? rawValue.toString() : n.toStringAsFixed(1);
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric});
  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            child: Icon(metric.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              metricLabel(l10n, metric.kind),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (metric.normal) ...[
            _Badge(text: l10n.badgeNormal),
            const SizedBox(width: 10),
          ],
          Text(
            metric.unit.isEmpty ? metric.value : '${metric.value} ${metric.unit}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
