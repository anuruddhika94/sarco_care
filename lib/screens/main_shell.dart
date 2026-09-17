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

  // Outlined when idle, filled (rounded) when selected — the icon "fills in"
  // on the active tab behind a soft-green selection pill.
  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.sports_gymnastics,
    Icons.favorite_border,
    Icons.menu_book_outlined,
    Icons.person_outline,
  ];
  static const List<IconData> _activeIcons = [
    Icons.home_rounded,
    Icons.sports_gymnastics,
    Icons.favorite_rounded,
    Icons.menu_book_rounded,
    Icons.person_rounded,
  ];

  // Each tab gets its own accent color so the bar reads as colorful now that
  // labels are gone.
  static const List<Color> _tabColors = [
    AppColors.primary,
    Color(0xFFE0952B),
    Color(0xFFD9534F),
    Color(0xFF3D7FBF),
    Color(0xFF8B5FBF),
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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.softGreen,
          indicatorShape: const StadiumBorder(),
          surfaceTintColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          height: 68,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            for (int i = 0; i < _icons.length; i++)
              NavigationDestination(
                icon: Icon(_icons[i], size: 32, color: _tabColors[i]),
                selectedIcon: Icon(_activeIcons[i], size: 36, color: _tabColors[i]),
                label: labels[i],
              ),
          ],
        ),
      ),
    );
  }
}
