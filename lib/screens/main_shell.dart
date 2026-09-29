import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../notifications/reminder_notifications.dart';
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

  @override
  void initState() {
    super.initState();
    // Ask once the patient is actually in the app, rather than at the splash
    // screen where the request has no context, then put today's reminders on
    // the phone's own schedule.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ReminderNotifications.requestPermission();
      if (!mounted) return;
      await ReminderNotifications.sync(AppLocalizations.of(context));
    });
  }

  // One screen per bottom-nav tab. Tab roots that reuse pushable screens hide
  // the back button since there is no route to pop within a tab.
  static const List<Widget> _tabs = [
    HomeScreen(),
    ExercisePlanScreen(showBackButton: false),
    HealthTrackingScreen(showBackButton: false),
    KnowledgeScreen(),
    ProfileScreen(),
  ];

  // Custom drawn icons: the outline set when idle and the matching solid set
  // when selected, so the icon "fills in" on the active tab. They are black
  // on transparent, so [ImageIcon] tints them with the tab's colour exactly
  // as a font icon would.
  static const List<String> _icons = [
    'assets/images/nav/home.png',
    'assets/images/nav/exercise.png',
    'assets/images/nav/health.png',
    'assets/images/nav/knowledge.png',
    'assets/images/nav/profile.png',
  ];
  static const List<String> _activeIcons = [
    'assets/images/nav/home_filled.png',
    'assets/images/nav/exercise_filled.png',
    'assets/images/nav/health_filled.png',
    'assets/images/nav/knowledge_filled.png',
    'assets/images/nav/profile_filled.png',
  ];

  Widget _navIcon(int i, {required bool active}) {
    // A fixed 48x48 box either way: the badge is then a true circle, and the
    // icon doesn't shift when a tab is selected. NavigationBar's own
    // indicator is a wide 64x32 pill, so it's switched off in the theme and
    // the badge drawn here instead.
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.softGreen : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: ImageIcon(
        AssetImage(active ? _activeIcons[i] : _icons[i]),
        size: 36,
        color: _tabColors[i],
      ),
    );
  }

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
          indicatorColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            for (int i = 0; i < _icons.length; i++)
              NavigationDestination(
                icon: _navIcon(i, active: false),
                selectedIcon: _navIcon(i, active: true),
                label: labels[i],
              ),
          ],
        ),
      ),
    );
  }
}
