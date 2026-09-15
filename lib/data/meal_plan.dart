import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// A tiny bilingual string. The 3-day meal plan is Thai-sourced content with
/// English equivalents, so each label carries both and is picked by the app's
/// current language. (Kept inline here rather than in the .arb files because
/// it's a large block of fixed content, not reusable UI chrome.)
class Tr {
  const Tr(this.en, this.th);
  final String en;
  final String th;
  String of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'th' ? th : en;
}

enum MealSlot { breakfast, lunch, dinner, beforeBed, snack }

String mealSlotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
      MealSlot.breakfast => l10n.mealBreakfast,
      MealSlot.lunch => l10n.mealLunch,
      MealSlot.dinner => l10n.mealDinner,
      MealSlot.beforeBed => l10n.mealBeforeBed,
      MealSlot.snack => l10n.mealSnack,
    };

/// One component of a meal with its estimated protein (e.g. lean pork · ~8 g).
class MealItem {
  const MealItem(this.name, this.protein);
  final Tr name;
  final Tr protein;
}

/// A single meal: a dish, its components, and the total protein.
class PlanMeal {
  const PlanMeal(this.slot, this.title, this.icon, this.items, this.totalProtein);
  final MealSlot slot;
  final Tr title;
  final IconData icon;
  final List<MealItem> items;
  final Tr totalProtein;
}

/// One day of the plan.
class PlanDay {
  const PlanDay(this.label, this.dayTotal, this.meals);
  final Tr label;
  final Tr dayTotal;
  final List<PlanMeal> meals;
}

const _g = 'g';

/// 3-day high-protein plan for older adults (~50 g protein/day), from the
/// "เมนู 3 วัน เพิ่มโปรตีน เสริมกล้ามเนื้อ สำหรับผู้สูงอายุ" guide.
const List<PlanDay> mealPlan = [
  // ───────── Day 1 ─────────
  PlanDay(
    Tr('Day 1', 'วันที่ 1'),
    Tr('~50 $_g/day', '~50 กรัม/วัน'),
    [
      PlanMeal(
        MealSlot.breakfast,
        Tr('Minced pork congee + ½ boiled egg', 'ข้าวต้มหมูสับ + ไข่ต้ม ½ ฟอง'),
        Icons.rice_bowl,
        [
          MealItem(Tr('Rice congee · 1 small bowl', 'ข้าวต้ม 1 ถ้วยเล็ก'),
              Tr('~2 $_g', '~2 กรัม')),
          MealItem(Tr('Lean minced pork · 40 g', 'หมูสับไม่ติดมัน 40 กรัม'),
              Tr('~8 $_g', '~8 กรัม')),
          MealItem(Tr('Boiled egg · ½', 'ไข่ต้ม ½ ฟอง'), Tr('~3 $_g', '~3 กรัม')),
        ],
        Tr('~13 $_g', '~13 กรัม'),
      ),
      PlanMeal(
        MealSlot.lunch,
        Tr('Tofu & pork clear soup + soft rice', 'แกงจืดเต้าหู้หมูสับ + ข้าวสวยนุ่ม'),
        Icons.soup_kitchen,
        [
          MealItem(Tr('Soft tofu · ½ tube', 'เต้าหู้อ่อน ½ หลอด'), Tr('~4 $_g', '~4 กรัม')),
          MealItem(Tr('Lean minced pork · 40 g', 'หมูสับไม่ติดมัน 40 กรัม'),
              Tr('~8 $_g', '~8 กรัม')),
          MealItem(Tr('Rice · ½–¾ bowl', 'ข้าวสวย ½–¾ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~14 $_g', '~14 กรัม'),
      ),
      PlanMeal(
        MealSlot.dinner,
        Tr('Steamed lime fish + boiled veg + rice', 'ปลานึ่งมะนาว + ผักต้ม + ข้าวสวย'),
        Icons.set_meal,
        [
          MealItem(Tr('Fish · 60 g', 'เนื้อปลา 60 กรัม'), Tr('~13 $_g', '~13 กรัม')),
          MealItem(Tr('Boiled vegetables · 1 cup', 'ผักต้ม 1 ถ้วย'), Tr('~1 $_g', '~1 กรัม')),
          MealItem(Tr('Rice · ½ bowl', 'ข้าวสวย ½ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~16 $_g', '~16 กรัม'),
      ),
      PlanMeal(
        MealSlot.beforeBed,
        Tr('Plain milk · 1 small glass (200 ml)', 'นมจืด 1 แก้วเล็ก (200 มล.)'),
        Icons.local_drink_outlined,
        [
          MealItem(Tr('Plain milk · 200 ml', 'นมจืด 200 มล.'), Tr('~7 $_g', '~7 กรัม')),
        ],
        Tr('~7 $_g', '~7 กรัม'),
      ),
    ],
  ),
  // ───────── Day 2 ─────────
  PlanDay(
    Tr('Day 2', 'วันที่ 2'),
    Tr('~50–52 $_g/day', '~50–52 กรัม/วัน'),
    [
      PlanMeal(
        MealSlot.breakfast,
        Tr('Fish congee + ½ boiled egg', 'โจ๊กปลา + ไข่ต้ม ½ ฟอง'),
        Icons.rice_bowl,
        [
          MealItem(Tr('Fish · 40 g', 'เนื้อปลา 40 กรัม'), Tr('~9 $_g', '~9 กรัม')),
          MealItem(Tr('Rice porridge · 1 small bowl', 'ข้าวโจ๊ก 1 ถ้วยเล็ก'),
              Tr('~2 $_g', '~2 กรัม')),
          MealItem(Tr('Boiled egg · ½', 'ไข่ต้ม ½ ฟอง'), Tr('~3 $_g', '~3 กรัม')),
        ],
        Tr('~14 $_g', '~14 กรัม'),
      ),
      PlanMeal(
        MealSlot.lunch,
        Tr('Rice + ginger chicken + tofu', 'ข้าว + ไก่ผัดขิง + เต้าหู้'),
        Icons.ramen_dining,
        [
          MealItem(Tr('Skinless chicken breast · 50 g', 'อกไก่ไม่ติดหนัง 50 กรัม'),
              Tr('~11 $_g', '~11 กรัม')),
          MealItem(Tr('Soft tofu · ⅓–½ tube', 'เต้าหู้อ่อน ⅓–½ หลอด'),
              Tr('~2–4 $_g', '~2–4 กรัม')),
          MealItem(Tr('Rice · ½ bowl', 'ข้าวสวย ½ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~15–17 $_g', '~15–17 กรัม'),
      ),
      PlanMeal(
        MealSlot.dinner,
        Tr('Egg, tofu & pork clear soup + rice', 'แกงจืดไข่น้ำเต้าหู้หมูสับ + ข้าวสวย'),
        Icons.soup_kitchen,
        [
          MealItem(Tr('Egg · 1', 'ไข่ 1 ฟอง'), Tr('~6 $_g', '~6 กรัม')),
          MealItem(Tr('Lean minced pork · 30 g', 'หมูสับไม่ติดมัน 30 กรัม'),
              Tr('~6 $_g', '~6 กรัม')),
          MealItem(Tr('Tofu · ½ tube', 'เต้าหู้ ½ หลอด'), Tr('~2 $_g', '~2 กรัม')),
          MealItem(Tr('Rice · ½ bowl', 'ข้าวสวย ½ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~16 $_g', '~16 กรัม'),
      ),
      PlanMeal(
        MealSlot.snack,
        Tr('Plain yogurt · 1 small cup', 'โยเกิร์ตรสธรรมชาติ 1 ถ้วยเล็ก'),
        Icons.icecream,
        [
          MealItem(Tr('Plain yogurt · 1 small cup', 'โยเกิร์ตรสธรรมชาติ 1 ถ้วยเล็ก'),
              Tr('~4–5 $_g', '~4–5 กรัม')),
        ],
        Tr('~4–5 $_g', '~4–5 กรัม'),
      ),
    ],
  ),
  // ───────── Day 3 ─────────
  PlanDay(
    Tr('Day 3', 'วันที่ 3'),
    Tr('~50–53 $_g/day', '~50–53 กรัม/วัน'),
    [
      PlanMeal(
        MealSlot.breakfast,
        Tr('Fish congee + boiled egg + spinach', 'ข้าวต้มปลา + ไข่ต้ม + ผักโขม'),
        Icons.rice_bowl,
        [
          MealItem(Tr('Fish · 40 g', 'เนื้อปลา 40 กรัม'), Tr('~9 $_g', '~9 กรัม')),
          MealItem(Tr('Rice congee · 1 small bowl', 'ข้าวต้ม 1 ถ้วยเล็ก'),
              Tr('~2 $_g', '~2 กรัม')),
          MealItem(Tr('Boiled egg · ½', 'ไข่ต้ม ½ ฟอง'), Tr('~3 $_g', '~3 กรัม')),
          MealItem(Tr('Spinach · ½ cup', 'ผักโขม ½ ถ้วย'), Tr('~1 $_g', '~1 กรัม')),
        ],
        Tr('~15 $_g', '~15 กรัม'),
      ),
      PlanMeal(
        MealSlot.lunch,
        Tr('Steamed egg with shrimp + veg + rice', 'ไข่ตุ๋นกุ้ง + ผักลวก + ข้าวสวย'),
        Icons.egg_alt,
        [
          MealItem(Tr('Egg · 1', 'ไข่ 1 ฟอง'), Tr('~6 $_g', '~6 กรัม')),
          MealItem(Tr('Minced shrimp · 40 g', 'กุ้งสับ 40 กรัม'), Tr('~8 $_g', '~8 กรัม')),
          MealItem(Tr('Blanched vegetables · 1 cup', 'ผักลวก 1 ถ้วย'), Tr('~1 $_g', '~1 กรัม')),
          MealItem(Tr('Rice · ½ bowl', 'ข้าวสวย ½ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~15–17 $_g', '~15–17 กรัม'),
      ),
      PlanMeal(
        MealSlot.dinner,
        Tr('Grilled/steamed fish + veg soup + rice', 'ปลาย่าง/นึ่ง + ซุปผัก + ข้าวสวย'),
        Icons.set_meal,
        [
          MealItem(Tr('Fish · 60 g', 'เนื้อปลา 60 กรัม'), Tr('~13 $_g', '~13 กรัม')),
          MealItem(Tr('Vegetables · 1 cup', 'ผักต้ม 1 ถ้วย'), Tr('~1 $_g', '~1 กรัม')),
          MealItem(Tr('Rice · ½ bowl', 'ข้าวสวย ½ ถ้วย'), Tr('~2 $_g', '~2 กรัม')),
        ],
        Tr('~16 $_g', '~16 กรัม'),
      ),
      PlanMeal(
        MealSlot.snack,
        Tr('Plain milk (200 ml) + ½ boiled egg', 'นมจืด 1 แก้วเล็ก (200 มล.) + ไข่ต้ม ½ ฟอง'),
        Icons.local_drink_outlined,
        [
          MealItem(Tr('Plain milk · 200 ml', 'นมจืด 200 มล.'), Tr('~7 $_g', '~7 กรัม')),
          MealItem(Tr('Boiled egg · ½', 'ไข่ต้ม ½ ฟอง'), Tr('~3 $_g', '~3 กรัม')),
        ],
        Tr('~10 $_g', '~10 กรัม'),
      ),
    ],
  ),
];
