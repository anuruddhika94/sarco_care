import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';

/// A tiny bilingual string, built from an API response's `_en`/`_th` field
/// pair and picked by the app's current language.
class Tr {
  const Tr(this.en, this.th);
  final String en;
  final String th;
  String of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'th' ? th : en;
}

enum MealSlot { breakfast, lunch, dinner, beforeBed, snack }

MealSlot mealSlotFromApi(String slot) => switch (slot) {
  'breakfast' => MealSlot.breakfast,
  'lunch' => MealSlot.lunch,
  'dinner' => MealSlot.dinner,
  'before_bed' => MealSlot.beforeBed,
  'snack' => MealSlot.snack,
  _ => MealSlot.snack,
};

String mealSlotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
  MealSlot.breakfast => l10n.mealBreakfast,
  MealSlot.lunch => l10n.mealLunch,
  MealSlot.dinner => l10n.mealDinner,
  MealSlot.beforeBed => l10n.mealBeforeBed,
  MealSlot.snack => l10n.mealSnack,
};

/// A meal's dish photo — either a bundled Flutter asset path (the seeded
/// plan's default photos) or, once an admin uploads one from the dashboard,
/// a real URL — falling back to [fallback] when there's no image or it
/// fails to load.
Widget dishImage({
  required String? image,
  required Widget fallback,
  BoxFit fit = BoxFit.cover,
}) {
  if (image == null) return fallback;
  final isNetwork = image.startsWith('http');
  return isNetwork
      ? Image.network(image, fit: fit, errorBuilder: (_, _, _) => fallback)
      : Image.asset(image, fit: fit, errorBuilder: (_, _, _) => fallback);
}

/// Maps the API's icon key (a Material icon name) to its constant.
IconData mealIconForKey(String key) => switch (key) {
  'rice_bowl' => Icons.rice_bowl,
  'soup_kitchen' => Icons.soup_kitchen,
  'set_meal' => Icons.set_meal,
  'local_drink_outlined' => Icons.local_drink_outlined,
  'ramen_dining' => Icons.ramen_dining,
  'icecream' => Icons.icecream,
  'egg_alt' => Icons.egg_alt,
  _ => Icons.restaurant,
};

/// One component of a meal with its estimated protein (e.g. lean pork · ~8 g).
class MealItem {
  const MealItem(this.name, this.protein);

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
    Tr(json['name_en'] as String, json['name_th'] as String),
    Tr(json['protein_en'] as String, json['protein_th'] as String),
  );

  final Tr name;
  final Tr protein;
}

/// A single meal: a dish, its components, and the total protein.
class PlanMeal {
  const PlanMeal(
    this.id,
    this.slot,
    this.title,
    this.icon,
    this.items,
    this.totalProtein, {
    this.image,
  });

  factory PlanMeal.fromJson(Map<String, dynamic> json) => PlanMeal(
    json['id'] as int,
    mealSlotFromApi(json['slot'] as String),
    Tr(json['title_en'] as String, json['title_th'] as String),
    mealIconForKey(json['icon'] as String),
    (json['meal_plan_items'] as List)
        .map((i) => MealItem.fromJson(i as Map<String, dynamic>))
        .toList(),
    Tr(json['total_protein_en'] as String, json['total_protein_th'] as String),
    image: json['image'] as String?,
  );

  /// The `meal_plan_meals` row id — used to log this meal via `POST /meal_logs`.
  final int id;
  final MealSlot slot;
  final Tr title;
  final IconData icon;
  final List<MealItem> items;
  final Tr totalProtein;

  /// Dish photo (from the plan infographic); null for drinks/snacks (icon shown).
  final String? image;
}

/// One day of the plan.
class PlanDay {
  const PlanDay(this.label, this.dayTotal, this.meals);

  factory PlanDay.fromJson(Map<String, dynamic> json) => PlanDay(
    Tr(json['label_en'] as String, json['label_th'] as String),
    Tr(json['day_total_en'] as String, json['day_total_th'] as String),
    (json['meal_plan_meals'] as List)
        .map((m) => PlanMeal.fromJson(m as Map<String, dynamic>))
        .toList(),
  );

  final Tr label;
  final Tr dayTotal;
  final List<PlanMeal> meals;
}

/// Fetches the multi-day high-protein meal plan from `GET /meal_plan`.
Future<List<PlanDay>> fetchMealPlan() async {
  final data = await apiClient.get('/meal_plan');
  return (data as List)
      .map((d) => PlanDay.fromJson(d as Map<String, dynamic>))
      .toList();
}
