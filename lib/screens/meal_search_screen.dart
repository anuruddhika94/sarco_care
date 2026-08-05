import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'recipe_screen.dart';

/// Meal Search — browse and filter recipes, opened from Meals.
/// Pure UI: a client-side name filter over a fixed recipe list; results open
/// the Recipe detail.
class MealSearchScreen extends StatefulWidget {
  const MealSearchScreen({super.key});

  @override
  State<MealSearchScreen> createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  static const _recipes = [
    _Recipe('Soft-boiled Eggs & Toast', 'Protein 20g', Icons.egg_alt),
    _Recipe('Grilled Chicken Salad', 'Protein 32g', Icons.rice_bowl),
    _Recipe('Salmon with Vegetables', 'Protein 28g', Icons.set_meal),
    _Recipe('Greek Yogurt & Nuts', 'Protein 15g', Icons.icecream),
    _Recipe('Lentil Soup', 'Protein 18g', Icons.soup_kitchen),
    _Recipe('Tofu Stir-fry', 'Protein 22g', Icons.ramen_dining),
    _Recipe('Beef & Broccoli', 'Protein 30g', Icons.dinner_dining),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_Recipe> get _results {
    if (_query.isEmpty) return _recipes;
    final q = _query.toLowerCase();
    return _recipes.where((r) => r.name.toLowerCase().contains(q)).toList();
  }

  void _openRecipe(String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeScreen(recipeName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Search Recipes',
          style: TextStyle(fontWeight: FontWeight.w800),
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
                hintText: 'Search recipes',
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
                      for (final r in results)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ResultRow(
                            recipe: r,
                            onTap: () => _openRecipe(r.name),
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

class _Recipe {
  const _Recipe(this.name, this.protein, this.icon);
  final String name;
  final String protein;
  final IconData icon;
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.recipe, required this.onTap});
  final _Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                child: Icon(recipe.icon, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      recipe.protein,
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'No recipes match "$query"',
            style: TextStyle(fontSize: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
