import 'package:flutter/material.dart';

import '../data/meal_plan.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'meal_search_screen.dart';
import 'recipe_screen.dart';

/// Screen #4 — Meals.
/// A 3-day high-protein plan for older adults. Day 1 / 2 / 3 tabs; each day
/// lists its meals with total protein. Tapping a meal opens its breakdown.
class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int _dayIndex = 0;

  void _openMeal(PlanMeal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeScreen(meal: meal)),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MealSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = mealPlan[_dayIndex];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.mealsTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: [for (final d in mealPlan) d.label.of(context)],
              selected: _dayIndex,
              onChanged: (i) => setState(() => _dayIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                Text(
                  l10n.mealPlanSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                _DayTotal(text: '${l10n.totalProteinLabel} ${day.dayTotal.of(context)}'),
                const SizedBox(height: 16),
                for (final meal in day.meals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _MealCard(
                      meal: meal,
                      onTap: () => _openMeal(meal),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openSearch,
                child: Text(l10n.viewRecipes),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The day's total-protein banner.
class _DayTotal extends StatelessWidget {
  const _DayTotal({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3D8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// 64×64 meal thumbnail: dish photo when available, else the meal's icon.
class _MealThumb extends StatelessWidget {
  const _MealThumb({required this.meal});
  final PlanMeal meal;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.softGreen,
      alignment: Alignment.center,
      child: Icon(meal.icon, color: AppColors.primary, size: 32),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 64,
        height: 64,
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

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.onTap});
  final PlanMeal meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              _MealThumb(meal: meal),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealSlotLabel(l10n, meal.slot),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.title.of(context),
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.totalProteinLabel} ${meal.totalProtein.of(context)}',
                      style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
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
