import 'package:flutter/material.dart';

import '../data/meal_plan.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'recipe_screen.dart';

/// Meal Search — browse and filter the plan's meals, opened from Meals.
/// A client-side name filter over every meal across the 3 days.
class MealSearchScreen extends StatefulWidget {
  const MealSearchScreen({super.key});

  @override
  State<MealSearchScreen> createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  // Every meal across all days, flattened.
  static final List<PlanMeal> _allMeals = [
    for (final day in mealPlan) ...day.meals,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PlanMeal> _results() {
    if (_query.isEmpty) return _allMeals;
    final q = _query.toLowerCase();
    return _allMeals
        .where((m) => m.title.of(context).toLowerCase().contains(q))
        .toList();
  }

  void _openMeal(PlanMeal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeScreen(meal: meal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final results = _results();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.searchRecipesTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.searchRecipesHint,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                        onPressed: () => setState(() {
                          _controller.clear();
                          _query = '';
                        }),
                      ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDDE4DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? _EmptyState(query: _query)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    children: [
                      for (final m in results)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ResultRow(
                            meal: m,
                            onTap: () => _openMeal(m),
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.meal, required this.onTap});
  final PlanMeal meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(meal.icon, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.title.of(context),
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${l10n.totalProteinLabel} ${meal.totalProtein.of(context)}',
                      style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            l10n.noRecipesMatch(query),
            style: TextStyle(fontSize: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
