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
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textMuted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 26,
              color: selected ? AppColors.primary : AppColors.textMuted,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          height: 74,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (int i = 0; i < _icons.length; i++)
              NavigationDestination(
                icon: Icon(_icons[i]),
                selectedIcon: Icon(_activeIcons[i]),
                label: labels[i],
              ),
          ],
        ),
      ),
    );
  }
}
