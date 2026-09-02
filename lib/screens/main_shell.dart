import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'exercise_plan_screen.dart';
import 'health_tracking_screen.dart';
import 'home_screen.dart';
import 'knowledge_screen.dart';
import 'profile_screen.dart';

/// The main app shell: a persistent bottom navigation bar over a set of tabs.
/// Tabs are kept alive with an IndexedStack so switching preserves each tab's
/// scroll/selection state. Login opens this shell.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // One screen per bottom-nav tab. Tab roots that reuse pushable screens hide
  // the back button since there is no route to pop within a tab.
  static const List<Widget> _tabs = [
    HomeScreen(),
    ExercisePlanScreen(showBackButton: false),
    HealthTrackingScreen(showBackButton: false),
    KnowledgeScreen(),
    ProfileScreen(),
  ];

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.fitness_center,
    Icons.favorite_border,
    Icons.menu_book_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.navHome,
      l10n.navExercise,
      l10n.navHealth,
      l10n.navKnowledge,
      l10n.navProfile,
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          for (int i = 0; i < _icons.length; i++)
            BottomNavigationBarItem(icon: Icon(_icons[i]), label: labels[i]),
        ],
      ),
    );
  }
}
