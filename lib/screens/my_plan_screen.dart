import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';

/// My Plan — the user's exercise log / plan opened from the Exercise Video.
/// Pure UI: range tabs, a list of planned exercises with completion state and
/// durations, a daily total and a Begin Exercise action.
class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  int _tabIndex = 0;

  static const _today = [
    _LogEntry('Seated Leg Lift', '10 min', true),
    _LogEntry('Arm Curls', '8 min', true),
    _LogEntry('Chair Squats', '12 min', false),
    _LogEntry('Standing Balance', '6 min', false),
  ];

  static const _thisWeek = [
    _LogEntry('Seated Leg Lift', '50 min', true),
    _LogEntry('Arm Curls', '40 min', true),
    _LogEntry('Chair Squats', '36 min', true),
    _LogEntry('Standing Balance', '18 min', false),
  ];

  static const _thisMonth = [
    _LogEntry('Seated Leg Lift', '3h 20m', true),
    _LogEntry('Arm Curls', '2h 40m', true),
    _LogEntry('Chair Squats', '2h 24m', true),
    _LogEntry('Standing Balance', '1h 12m', true),
  ];

  List<_LogEntry> get _entries => [_today, _thisWeek, _thisMonth][_tabIndex];

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    final done = entries.where((e) => e.done).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'My Plan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: const ['Today', 'This Week', 'This Month'],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                _SummaryCard(done: done, total: entries.length),
                const SizedBox(height: 16),
                for (final e in entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LogRow(entry: e),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Begin Exercise'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogEntry {
  const _LogEntry(this.name, this.duration, this.done);
  final String name;
  final String duration;
  final bool done;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's progress",
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  '$done of $total exercises done',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  strokeWidth: 6,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Text(
                  '${((total == 0 ? 0 : done / total) * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
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

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});
  final _LogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          Icon(
            entry.done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: entry.done ? AppColors.primary : AppColors.textMuted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              entry.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            entry.duration,
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
