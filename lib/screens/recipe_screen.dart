import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api_client.dart';
import '../data/meal_plan.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Screen #5 — Meal detail.
/// Shows a meal's protein breakdown (each component with its protein grams) and
/// the total, plus a "Complete Meal and Log" action that records it via
/// `POST /meal_logs` — for today, or for [logDate] when opened from
/// [MealLogScreen]'s "Add Data".
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.meal, this.logDate, this.patientId});

  final PlanMeal meal;
  final DateTime? logDate;

  /// Set when a caretaker is logging this on behalf of a linked patient.
  final int? patientId;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool _logging = false;

  PlanMeal get meal => widget.meal;

  Future<void> _completeAndLog() async {
    setState(() => _logging = true);
    final l10n = AppLocalizations.of(context);
    final logDate = widget.logDate;
    try {
      await apiClient.post('/meal_logs', body: {
        'meal_plan_meal_id': meal.id,
        if (logDate != null) 'eaten_on': DateFormat('yyyy-MM-dd').format(logDate),
        if (widget.patientId != null) 'patient_id': widget.patientId,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(logDate == null ? l10n.mealLoggedToday : l10n.mealLogged),
            backgroundColor: AppColors.primary,
          ),
        );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _logging = false);
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
          meal.title.of(context),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          // Hero: dish photo when available, else an icon on a soft block.
          _Hero(meal: meal),
          const SizedBox(height: 16),
          Row(
            children: [
              _Chip(text: mealSlotLabel(l10n, meal.slot)),
              const SizedBox(width: 8),
              _Chip(
                text: '${l10n.totalProteinLabel} ${meal.totalProtein.of(context)}',
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.proteinBreakdown),
          const SizedBox(height: 12),
          for (final item in meal.items)
            _ItemRow(name: item.name.of(context), protein: item.protein.of(context)),
          const SizedBox(height: 8),
          _TotalRow(
            label: l10n.totalProteinLabel,
            value: meal.totalProtein.of(context),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logging ? null : _completeAndLog,
              child: _logging
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(l10n.completeMealAndLog),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width dish photo hero, with an icon-on-soft-block fallback.
class _Hero extends StatelessWidget {
  const _Hero({required this.meal});
  final PlanMeal meal;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 150,
      alignment: Alignment.center,
      color: AppColors.softGreen,
      child: Icon(meal.icon, size: 76, color: AppColors.primary),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 170,
        width: double.infinity,
        child: meal.image == null
            ? fallback
            : Image.asset(
                meal.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.filled = false});
  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: filled ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }
}

/// One component row: the food on the left, its protein badge on the right.
class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.name, required this.protein});
  final String name;
  final String protein;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 16, height: 1.3, color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            protein,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
