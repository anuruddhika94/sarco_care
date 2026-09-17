import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api_client.dart';
import '../data/meal_plan.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'meals_screen.dart';

/// Meal Log — what the patient actually ate, backed by `meal_logs`. A date
/// picker (defaulting to the most recently logged date, like General
/// Information) shows that day's meals; "Add Data" picks a meal from the
/// shared plan to log for the selected date.
class MealLogScreen extends StatefulWidget {
  const MealLogScreen({super.key});

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  List<Map<String, dynamic>>? _logs;
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
      final data = await apiClient.get('/meal_logs');
      if (!mounted) return;
      final logs = (data as List).cast<Map<String, dynamic>>();
      setState(() {
        _logs = logs;
        _selectedDate = selectDate ??
            (logs.isEmpty ? DateTime.now() : DateTime.parse(logs.first['eaten_on'] as String));
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
      final eaten = DateTime.parse(l['eaten_on'] as String);
      return eaten.year == date.year && eaten.month == date.month && eaten.day == date.day;
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
    final logged = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => MealsScreen(logDate: _selectedDate ?? DateTime.now())),
    );
    if (logged == true) await _load(selectDate: _selectedDate);
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
          l10n.mealLogTitle,
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
    if (_logs == null) {
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
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    l10n.noDataForDate,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
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

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final meal = entry['meal_plan_meal'] as Map<String, dynamic>;
    final isThai = Localizations.localeOf(context).languageCode == 'th';
    final title = (isThai ? meal['title_th'] : meal['title_en']) as String;
    final protein = (isThai ? meal['total_protein_th'] : meal['total_protein_en']) as String;
    final slot = mealSlotFromApi(meal['slot'] as String);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            child: Icon(mealIconForKey(meal['icon'] as String), color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealSlotLabel(l10n, slot),
                  style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          Text(
            protein,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
