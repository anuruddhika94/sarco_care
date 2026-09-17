import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_format.dart';
import '../theme/app_theme.dart';
import 'exercise_plan_screen.dart';

/// My Plan — the patient's exercise history, backed by `exercise_logs`.
/// A date picker (defaulting to the most recently logged date, like General
/// Information) shows what was done that day; "Add Data" logs an exercise
/// from the shared catalog for the selected date.
class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key, this.patientId});

  /// Set when a caretaker is viewing/logging for a linked patient.
  final int? patientId;

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  List<Map<String, dynamic>>? _logs;
  List<CatalogExercise>? _catalog;
  String? _error;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Map<String, String>? get _patientQuery =>
      widget.patientId == null ? null : {'patient_id': '${widget.patientId}'};

  Future<void> _load({DateTime? selectDate}) async {
    setState(() => _error = null);
    try {
      final results = await Future.wait([
        apiClient.get('/exercise_logs', query: _patientQuery),
        fetchExercises(),
      ]);
      if (!mounted) return;
      final logs = (results[0] as List).cast<Map<String, dynamic>>();
      setState(() {
        _logs = logs;
        _catalog = results[1] as List<CatalogExercise>;
        _selectedDate = selectDate ??
            (logs.isEmpty ? DateTime.now() : DateTime.parse(logs.first['completed_on'] as String));
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  List<Map<String, dynamic>> get _entriesForSelectedDate {
    final logs = _logs;
    final date = _selectedDate;
    if (logs == null || date == null) return const [];
    return logs.where((l) {
      final completed = DateTime.parse(l['completed_on'] as String);
      return completed.year == date.year && completed.month == date.month && completed.day == date.day;
    }).toList();
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
    final catalog = _catalog;
    if (catalog == null) return;
    final exercise = await showModalBottomSheet<CatalogExercise>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ExercisePicker(catalog: catalog),
    );
    if (exercise == null) return;

    try {
      await apiClient.post('/exercise_logs', body: {
        'exercise_id': exercise.id,
        'completed_on': DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now()),
        'minutes': exercise.defaultMinutes,
        if (widget.patientId != null) 'patient_id': widget.patientId,
      });
      await _load(selectDate: _selectedDate);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
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
        title: Text(
          l10n.myPlanTitle,
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
    if (_logs == null || _catalog == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final entries = _entriesForSelectedDate;
    final date = _selectedDate ?? DateTime.now();
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: _DateSelector(date: date, isToday: isToday, onTap: _pickDate),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            children: [
              _SummaryCard(done: entries.length, total: _catalog!.length),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.noDataForDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                )
              else
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

/// Bottom-sheet list of the shared catalog, for logging one for the selected date.
class _ExercisePicker extends StatelessWidget {
  const _ExercisePicker({required this.catalog});
  final List<CatalogExercise> catalog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addData,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            for (final exercise in catalog)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(exercise.icon, color: AppColors.primary),
                title: Text(
                  exercise.name(context),
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                subtitle: Text(formatDuration(l10n, exercise.defaultMinutes)),
                onTap: () => Navigator.of(context).pop(exercise),
              ),
          ],
        ),
      ),
    );
  }
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
                  value: total == 0 ? 0 : (done / total).clamp(0, 1),
                  strokeWidth: 6,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Text(
                  '${total == 0 ? 0 : ((done / total).clamp(0, 1) * 100).round()}%',
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
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercise = entry['exercise'] as Map<String, dynamic>;
    final isThai = Localizations.localeOf(context).languageCode == 'th';
    final name = (isThai ? exercise['name_th'] : exercise['name_en']) as String;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            formatDuration(l10n, entry['minutes'] as int),
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
