import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'meal_search_screen.dart';
import 'recipe_screen.dart';

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

  static const _tabs = ['Daily', 'Weekly'];

  static const _dailyMeals = [
    _Meal('Soft-boiled Eggs & Toast', 'Breakfast', 'Protein 20g', Icons.egg_alt,
        image: 'assets/images/meals/eggs_toast.png'),
    _Meal('Grilled Chicken Salad', 'Lunch', 'Protein 32g', Icons.rice_bowl),
    _Meal('Salmon with Vegetables', 'Dinner', 'Protein 28g', Icons.set_meal),
    _Meal('Greek Yogurt & Nuts', 'Snack', 'Protein 15g', Icons.icecream),
  ];

  static const _weeklyMeals = [
    _Meal('Oatmeal & Berries', 'Mon', 'Protein 18g', Icons.breakfast_dining),
    _Meal('Tuna Sandwich', 'Tue', 'Protein 26g', Icons.lunch_dining),
    _Meal('Tofu Stir-fry', 'Wed', 'Protein 22g', Icons.ramen_dining),
    _Meal('Beef & Broccoli', 'Thu', 'Protein 30g', Icons.dinner_dining),
    _Meal('Lentil Soup', 'Fri', 'Protein 18g', Icons.soup_kitchen),
    _Meal('Chicken & Rice', 'Sat', 'Protein 28g', Icons.rice_bowl),
    _Meal('Egg Fried Rice', 'Sun', 'Protein 20g', Icons.egg),
  ];

  List<_Meal> get _visibleMeals =>
      _tabIndex == 0 ? _dailyMeals : _weeklyMeals;

  String get _sectionTitle =>
      _tabIndex == 0 ? 'Suggested Meals for Today' : "This Week's Plan";

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
            onPressed: _openSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: _tabs,
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                Text(
                  _sectionTitle,
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
                onPressed: _openSearch,
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
  const _Meal(this.name, this.mealTime, this.protein, this.icon, {this.image});
  final String name;
  final String mealTime;
  final String protein;
  final IconData icon;
  final String? image;
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
