import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';
import 'exercise_plan_screen.dart';
import 'meals_screen.dart';

/// Screen #3 — Home / dashboard.
/// Pure UI: greeting header, Daily Goals checklist, a grid of feature tiles and
/// a bottom navigation bar. Tiles/tabs navigate forward to placeholders.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _open(String title) {
    // Built screens route to their real widget; the rest hit a placeholder.
    final WidgetBuilder builder = switch (title) {
      'Meal Menus' => (_) => const MealsScreen(),
      'Exercise Plan' => (_) => const ExercisePlanScreen(),
      _ => (_) => PlaceholderScreen(title: title),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _GreetingHeader(name: 'Somchai'),
              const SizedBox(height: 24),
              const _DailyGoalsCard(),
              const SizedBox(height: 24),
              Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _FeatureGrid(onTap: _open),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (index, label) {
          setState(() => _navIndex = index);
          if (index != 0) _open(label);
        },
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                '$name! 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        // Notification bell with an unread dot.
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4EAE4)),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textDark,
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE05B4B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DailyGoalsCard extends StatelessWidget {
  const _DailyGoalsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Goals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          const _GoalItem(text: 'Eat enough protein'),
          const _GoalItem(text: 'Exercise 15 minutes'),
          const _GoalItem(text: 'Drink 6–8 glasses of water'),
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  const _GoalItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.onTap});
  final void Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    const features = [
      _Feature('Meal Menus', Icons.restaurant_menu, Color(0xFF3B8B5F)),
      _Feature('Exercise Plan', Icons.fitness_center, Color(0xFF3E7CB1)),
      _Feature('SARC-F Assessment', Icons.assignment_outlined, Color(0xFFCB8A2E)),
      _Feature('Health Tracking', Icons.monitor_heart_outlined, Color(0xFFB0524B)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.05,
      children: [
        for (final f in features)
          _FeatureTile(feature: f, onTap: () => onTap(f.title)),
      ],
    );
  }
}

class _Feature {
  const _Feature(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature, required this.onTap});
  final _Feature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(feature.icon, color: feature.color, size: 28),
              ),
              Text(
                feature.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final void Function(int index, String label) onTap;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.fitness_center, 'Exercise'),
    (Icons.favorite_border, 'Health'),
    (Icons.menu_book_outlined, 'Knowledge'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => onTap(i, _items[i].$2),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        for (final item in _items)
          BottomNavigationBarItem(icon: Icon(item.$1), label: item.$2),
      ],
    );
  }
}
