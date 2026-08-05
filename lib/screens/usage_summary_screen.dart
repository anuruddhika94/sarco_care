import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';

/// Usage Summary — activity score over time, opened from Profile.
/// Pure UI: a hero score plus a single-series bar chart (one brand hue,
/// rounded bar tops, recessive baseline, selective direct label on the peak).
class UsageSummaryScreen extends StatefulWidget {
  const UsageSummaryScreen({super.key});

  @override
  State<UsageSummaryScreen> createState() => _UsageSummaryScreenState();
}

class _UsageSummaryScreenState extends State<UsageSummaryScreen> {
  int _tabIndex = 0;

  // One data set per range tab. Scores are 0–100.
  static const _series = [
    _Series('Daily average', 82, [
      _Bar('M', 78),
      _Bar('T', 85),
      _Bar('W', 82),
      _Bar('T', 90),
      _Bar('F', 88),
      _Bar('S', 76),
      _Bar('S', 82),
    ]),
    _Series('Weekly average', 84, [
      _Bar('W1', 80),
      _Bar('W2', 86),
      _Bar('W3', 83),
      _Bar('W4', 88),
    ]),
    _Series('Monthly average', 79, [
      _Bar('Jan', 74),
      _Bar('Feb', 78),
      _Bar('Mar', 82),
      _Bar('Apr', 80),
      _Bar('May', 83),
      _Bar('Jun', 79),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final series = _series[_tabIndex];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Usage Summary',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SegmentedTabs(
            labels: const ['Daily', 'Weekly', 'Monthly'],
            selected: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
          ),
          const SizedBox(height: 20),
          _HeroScore(label: series.label, score: series.average),
          const SizedBox(height: 24),
          Text(
            'Activity score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _BarChart(bars: series.bars),
        ],
      ),
    );
  }
}

class _Series {
  const _Series(this.label, this.average, this.bars);
  final String label;
  final int average;
  final List<_Bar> bars;
}

class _Bar {
  const _Bar(this.label, this.value);
  final String label;
  final int value;
}

/// Headline number — the data's job here is a single figure, so it leads.
class _HeroScore extends StatelessWidget {
  const _HeroScore({required this.label, required this.score});
  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$score',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: ' / 100',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single-series bar chart. One brand hue; the peak bar is labeled directly and
/// deepened, the rest recede; a thin baseline anchors the marks.
class _BarChart extends StatelessWidget {
  const _BarChart({required this.bars});
  final List<_Bar> bars;

  static const double _chartHeight = 170;
  static const double _maxScale = 100;

  @override
  Widget build(BuildContext context) {
    final peak = bars.map((b) => b.value).reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        SizedBox(
          height: _chartHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final bar in bars)
                Expanded(
                  child: Padding(
                    // ~2px surface gap between adjacent bars.
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _BarColumn(bar: bar, isPeak: bar.value == peak),
                  ),
                ),
            ],
          ),
        ),
        // Recessive baseline.
        Container(height: 1.5, color: const Color(0xFFE4EAE4)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final bar in bars)
              Expanded(
                child: Text(
                  bar.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({required this.bar, required this.isPeak});
  final _Bar bar;
  final bool isPeak;

  @override
  Widget build(BuildContext context) {
    final height =
        (bar.value / _BarChart._maxScale) * (_BarChart._chartHeight - 22);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Selective direct label — only the peak bar carries a number.
        if (isPeak)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${bar.value}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            // One hue; the peak deepened, others recede.
            color: isPeak
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.35),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}
