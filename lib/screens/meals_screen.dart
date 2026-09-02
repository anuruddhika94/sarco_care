import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'meal_search_screen.dart';
import 'recipe_screen.dart';

/// Stable identifiers for the sample meals/recipes, so their names translate
/// consistently wherever they appear (Meals, Meal Search, Recipe).
enum MealId {
  eggsToast,
  chickenSalad,
  salmonVeg,
  yogurtNuts,
  oatmeal,
  tuna,
  tofu,
  beefBroccoli,
  lentil,
  chickenRice,
  eggRice,
}

String mealName(AppLocalizations l10n, MealId id) => switch (id) {
      MealId.eggsToast => l10n.mealEggsToast,
      MealId.chickenSalad => l10n.mealChickenSalad,
      MealId.salmonVeg => l10n.mealSalmonVeg,
      MealId.yogurtNuts => l10n.mealYogurtNuts,
      MealId.oatmeal => l10n.mealOatmeal,
      MealId.tuna => l10n.mealTuna,
      MealId.tofu => l10n.mealTofu,
      MealId.beefBroccoli => l10n.mealBeefBroccoli,
      MealId.lentil => l10n.mealLentil,
      MealId.chickenRice => l10n.mealChickenRice,
      MealId.eggRice => l10n.mealEggRice,
    };

/// A meal's schedule slot — a meal time (daily plan) or a weekday (weekly plan).
enum MealSlot { breakfast, lunch, dinner, snack, mon, tue, wed, thu, fri, sat, sun }

String mealSlotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
      MealSlot.breakfast => l10n.mealBreakfast,
      MealSlot.lunch => l10n.mealLunch,
      MealSlot.dinner => l10n.mealDinner,
      MealSlot.snack => l10n.mealSnack,
      MealSlot.mon => l10n.dayAbbrevMon,
      MealSlot.tue => l10n.dayAbbrevTue,
      MealSlot.wed => l10n.dayAbbrevWed,
      MealSlot.thu => l10n.dayAbbrevThu,
      MealSlot.fri => l10n.dayAbbrevFri,
      MealSlot.sat => l10n.dayAbbrevSat,
      MealSlot.sun => l10n.dayAbbrevSun,
    };

/// Screen #4 — Meals.
/// Pure UI: search header, segmented tabs, suggested meal cards and a
/// "View Recipes" action. Cards open the Recipe detail; search opens Meal Search.
class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int _tabIndex = 0;

  static const _dailyMeals = [
    _Meal(MealId.eggsToast, MealSlot.breakfast, 20, Icons.egg_alt,
        image: 'assets/images/meals/eggs_toast.png'),
    _Meal(MealId.chickenSalad, MealSlot.lunch, 32, Icons.rice_bowl),
    _Meal(MealId.salmonVeg, MealSlot.dinner, 28, Icons.set_meal),
    _Meal(MealId.yogurtNuts, MealSlot.snack, 15, Icons.icecream),
  ];

  static const _weeklyMeals = [
    _Meal(MealId.oatmeal, MealSlot.mon, 18, Icons.breakfast_dining),
    _Meal(MealId.tuna, MealSlot.tue, 26, Icons.lunch_dining),
    _Meal(MealId.tofu, MealSlot.wed, 22, Icons.ramen_dining),
    _Meal(MealId.beefBroccoli, MealSlot.thu, 30, Icons.dinner_dining),
    _Meal(MealId.lentil, MealSlot.fri, 18, Icons.soup_kitchen),
    _Meal(MealId.chickenRice, MealSlot.sat, 28, Icons.rice_bowl),
    _Meal(MealId.eggRice, MealSlot.sun, 20, Icons.egg),
  ];

  List<_Meal> get _visibleMeals =>
      _tabIndex == 0 ? _dailyMeals : _weeklyMeals;

  void _openRecipe(String recipeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeScreen(recipeName: recipeName),
      ),
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
    final sectionTitle =
        _tabIndex == 0 ? l10n.sectionSuggestedToday : l10n.sectionThisWeekPlan;
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
              labels: [l10n.tabDaily, l10n.tabWeekly],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                Text(
                  sectionTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                for (final meal in _visibleMeals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _MealCard(
                      meal: meal,
                      onTap: () => _openRecipe(mealName(l10n, meal.id)),
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

class _Meal {
  const _Meal(this.id, this.slot, this.proteinGrams, this.icon, {this.image});
  final MealId id;
  final MealSlot slot;
  final int proteinGrams;
  final IconData icon;
  final String? image;
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.onTap});
  final _Meal meal;
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
              // Meal thumbnail: food image when available, else an icon.
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: meal.image == null
                      ? Container(
                          color: AppColors.softGreen,
                          alignment: Alignment.center,
                          child: Icon(meal.icon, color: AppColors.primary, size: 32),
                        )
                      : Image.asset(
                          meal.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.softGreen,
                            alignment: Alignment.center,
                            child: Icon(meal.icon, color: AppColors.primary, size: 32),
                          ),
                        ),
                ),
              ),
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
                      mealName(l10n, meal.id),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.proteinGrams(meal.proteinGrams),
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
