import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';
import 'recipe_screen.dart';

/// Screen #4 — Meals.
/// Pure UI: search header, segmented tabs, suggested meal cards and a
/// "View Recipes" action. Cards forward to the Recipe detail placeholder (#5).
class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int _tabIndex = 0;

  static const _meals = [
    _Meal('Soft-boiled Eggs & Toast', 'Breakfast', 'Protein 20g', Icons.egg_alt),
    _Meal('Grilled Chicken Salad', 'Lunch', 'Protein 32g', Icons.rice_bowl),
    _Meal('Salmon with Vegetables', 'Dinner', 'Protein 28g', Icons.set_meal),
    _Meal('Greek Yogurt & Nuts', 'Snack', 'Protein 15g', Icons.icecream),
  ];

  void _openRecipe(String recipeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeScreen(recipeName: recipeName),
      ),
    );
  }

  void _openPlaceholder(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Meals',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _openPlaceholder('Search'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: _SegmentedTabs(
              labels: const ['Daily Plan', 'Weekly', 'Search'],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                Text(
                  'Suggested Meals for Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                for (final meal in _meals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _MealCard(
                      meal: meal,
                      onTap: () => _openRecipe(meal.name),
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
                onPressed: () => _openPlaceholder('Recipes'),
                child: const Text('View Recipes'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Meal {
  const _Meal(this.name, this.mealTime, this.protein, this.icon);
  final String name;
  final String mealTime;
  final String protein;
  final IconData icon;
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.onTap});
  final _Meal meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              // Meal thumbnail placeholder — swap for a food photo later.
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(meal.icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.mealTime,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.protein,
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

/// Pill-style segmented selector used for the meal tabs.
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == i
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected == i ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
