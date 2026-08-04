import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Screen #5 — Recipe detail.
/// Pure UI: hero photo, nutrition facts, ingredients, method and a
/// "Complete Meal and Log" action that confirms and returns to the list.
class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key, required this.recipeName});

  final String recipeName;

  static const _ingredients = [
    '2 fresh eggs',
    '2 slices wholegrain toast',
    '1 tsp olive oil',
    'A pinch of salt and pepper',
  ];

  static const _method = [
    'Bring a small pot of water to a gentle boil.',
    'Lower the eggs in and cook for 6–7 minutes.',
    'Cool under running water, then peel.',
    'Serve with toast, a drizzle of oil and seasoning.',
  ];

  void _completeAndLog(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Meal logged for today'),
          backgroundColor: AppColors.primary,
        ),
      );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          recipeName,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          // Hero photo placeholder — swap for a food image later.
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.egg_alt, size: 88, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const _NutritionRow(),
          const SizedBox(height: 24),
          const _SectionTitle('Ingredients'),
          const SizedBox(height: 12),
          for (final item in _ingredients) _BulletLine(text: item),
          const SizedBox(height: 20),
          const _SectionTitle('Method'),
          const SizedBox(height: 12),
          for (int i = 0; i < _method.length; i++)
            _StepLine(number: i + 1, text: _method[i]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _completeAndLog(context),
              child: const Text('Complete Meal and Log'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _NutritionTile(label: 'Protein', value: '13 g')),
        SizedBox(width: 12),
        Expanded(child: _NutritionTile(label: 'Energy', value: '90 kcal')),
        SizedBox(width: 12),
        Expanded(child: _NutritionTile(label: 'Fat', value: '6 g')),
      ],
    );
  }
}

class _NutritionTile extends StatelessWidget {
  const _NutritionTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
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

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});
  final String text;

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
              text,
              style: TextStyle(fontSize: 16, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.35,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
