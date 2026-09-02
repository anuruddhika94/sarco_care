import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_format.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'exercise_plan_screen.dart';

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
    _LogEntry(ExerciseId.seatedLegLift, 10, true),
    _LogEntry(ExerciseId.armCurls, 8, true),
    _LogEntry(ExerciseId.chairSquats, 12, false),
    _LogEntry(ExerciseId.standingBalance, 6, false),
  ];

  static const _thisWeek = [
    _LogEntry(ExerciseId.seatedLegLift, 50, true),
    _LogEntry(ExerciseId.armCurls, 40, true),
    _LogEntry(ExerciseId.chairSquats, 36, true),
    _LogEntry(ExerciseId.standingBalance, 18, false),
  ];

  static const _thisMonth = [
    _LogEntry(ExerciseId.seatedLegLift, 200, true),
    _LogEntry(ExerciseId.armCurls, 160, true),
    _LogEntry(ExerciseId.chairSquats, 144, true),
    _LogEntry(ExerciseId.standingBalance, 72, true),
  ];

  List<_LogEntry> get _entries => [_today, _thisWeek, _thisMonth][_tabIndex];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = _entries;
    final done = entries.where((e) => e.done).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.myPlanTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: [l10n.tabToday, l10n.tabThisWeek, l10n.tabThisMonth],
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
                child: Text(l10n.beginExercise),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogEntry {
  const _LogEntry(this.id, this.minutes, this.done);
  final ExerciseId id;
  final int minutes;
  final bool done;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  l10n.todaysProgress,
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.exercisesDone(done, total),
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
    final l10n = AppLocalizations.of(context);
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
              exerciseName(l10n, entry.id),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            formatDuration(l10n, entry.minutes),
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
