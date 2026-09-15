// Verifies the 3-day meal plan renders the right content in both languages,
// and that a meal's protein breakdown shows.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sarco_care/data/meal_plan.dart';
import 'package:sarco_care/l10n/app_localizations.dart';
import 'package:sarco_care/screens/meals_screen.dart';
import 'package:sarco_care/screens/recipe_screen.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  test('plan has 3 days, each with 4 meals', () {
    expect(mealPlan.length, 3);
    for (final d in mealPlan) {
      expect(d.meals.length, 4);
    }
  });

  testWidgets('Meals shows Day tabs and Day 1 content (EN)', (tester) async {
    await tester.pumpWidget(_wrap(const MealsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Day 2'), findsOneWidget);
    expect(find.text('Day 3'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Minced pork congee + ½ boiled egg'), findsOneWidget);
    expect(find.textContaining('Total protein ~13 g'), findsWidgets);
  });

  testWidgets('Meals renders in Thai', (tester) async {
    await tester.pumpWidget(_wrap(const MealsScreen(), locale: const Locale('th')));
    await tester.pumpAndSettle();

    expect(find.text('วันที่ 1'), findsOneWidget);
    expect(find.text('ข้าวต้มหมูสับ + ไข่ต้ม ½ ฟอง'), findsOneWidget);
  });

  testWidgets('Recipe detail shows the protein breakdown', (tester) async {
    final meal = mealPlan[0].meals[0]; // Day 1 breakfast
    await tester.pumpWidget(_wrap(RecipeScreen(meal: meal)));
    await tester.pumpAndSettle();

    expect(find.text('Protein breakdown'), findsOneWidget);
    expect(find.text('Lean minced pork · 40 g'), findsOneWidget);
    expect(find.text('~8 g'), findsOneWidget);
    // Total appears in the chip and the total row.
    expect(find.textContaining('~13 g'), findsWidgets);
  });
}
