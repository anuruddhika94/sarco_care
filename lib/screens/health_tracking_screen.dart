import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'add_data_screen.dart';

/// Screen #10 — Health Tracking.
/// Pure UI: time-range tabs, a list of body metrics and an Add Data action.
class HealthTrackingScreen extends StatefulWidget {
  const HealthTrackingScreen({super.key, this.showBackButton = true});

  /// False when shown as a shell tab root (no route to pop back to).
  final bool showBackButton;

  @override
  State<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  int _tabIndex = 0;

  // Latest reading vs weekly/monthly averages.
  static const _daily = [
    _Metric(MetricKind.weight, '55.0', 'kg', Icons.monitor_weight_outlined),
    _Metric(MetricKind.height, '160', 'cm', Icons.height),
    _Metric(MetricKind.bmi, '21.5', '', Icons.calculate_outlined, normal: true),
    _Metric(MetricKind.calf, '34.0', 'cm', Icons.straighten),
    _Metric(MetricKind.handgrip, '18.0', 'kg', Icons.back_hand_outlined),
  ];

  static const _weekly = [
    _Metric(MetricKind.weight, '55.3', 'kg', Icons.monitor_weight_outlined),
    _Metric(MetricKind.height, '160', 'cm', Icons.height),
    _Metric(MetricKind.bmi, '21.6', '', Icons.calculate_outlined, normal: true),
    _Metric(MetricKind.calf, '33.8', 'cm', Icons.straighten),
    _Metric(MetricKind.handgrip, '17.8', 'kg', Icons.back_hand_outlined),
  ];

  static const _monthly = [
    _Metric(MetricKind.weight, '55.8', 'kg', Icons.monitor_weight_outlined),
    _Metric(MetricKind.height, '160', 'cm', Icons.height),
    _Metric(MetricKind.bmi, '21.8', '', Icons.calculate_outlined, normal: true),
    _Metric(MetricKind.calf, '33.5', 'cm', Icons.straighten),
    _Metric(MetricKind.handgrip, '17.5', 'kg', Icons.back_hand_outlined),
  ];

  List<_Metric> get _visibleMetrics =>
      [_daily, _weekly, _monthly][_tabIndex];

  void _addData() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddDataScreen()),
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
        automaticallyImplyLeading: widget.showBackButton,
        title: Text(
          l10n.featureHealthTracking,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: [l10n.tabDaily, l10n.tabWeekly, l10n.tabMonthly],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                for (final m in _visibleMetrics)
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
      ),
    );
  }
}

enum MetricKind { weight, height, bmi, calf, handgrip }

String metricLabel(AppLocalizations l10n, MetricKind kind) => switch (kind) {
      MetricKind.weight => l10n.metricWeight,
      MetricKind.height => l10n.metricHeight,
      MetricKind.bmi => l10n.metricBmi,
      MetricKind.calf => l10n.metricCalf,
      MetricKind.handgrip => l10n.metricHandgrip,
    };

class _Metric {
  const _Metric(this.kind, this.value, this.unit, this.icon,
      {this.normal = false});
  final MetricKind kind;
  final String value;
  final String unit;
  final IconData icon;
  final bool normal;
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
