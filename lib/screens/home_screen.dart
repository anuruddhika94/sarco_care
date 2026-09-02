import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'assessment_screen.dart';
import 'caretaker_approval_screen.dart';
import 'exercise_plan_screen.dart';
import 'health_tracking_screen.dart';
import 'meals_screen.dart';
import 'notifications_screen.dart';

/// Screen #3 — Home / dashboard (the Home tab of the app shell).
/// Pure UI: greeting header, Daily Goals checklist and a grid of feature tiles.
/// The bottom navigation bar lives in [MainShell]; tiles push full screens.
/// The four dashboard shortcuts. The enum keeps navigation independent of the
/// (translated) tile label.
enum HomeFeature { mealMenus, exercisePlan, sarcfAssessment, healthTracking }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, HomeFeature feature) {
    final WidgetBuilder builder = switch (feature) {
      HomeFeature.mealMenus => (_) => const MealsScreen(),
      HomeFeature.exercisePlan => (_) => const ExercisePlanScreen(),
      HomeFeature.sarcfAssessment => (_) => const AssessmentScreen(),
      HomeFeature.healthTracking => (_) => const HealthTrackingScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingHeader(
                name: l10n.userFirstName,
                onBellTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              const _CaretakerRequestBanner(),
              const SizedBox(height: 24),
              const _DailyGoalsCard(),
              const SizedBox(height: 24),
              Text(
                l10n.whatWouldYouLikeToDo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _FeatureGrid(onTap: (feature) => _open(context, feature)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.name, required this.onBellTap});
  final String name;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeBack,
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeGreetingName(name),
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
        GestureDetector(
          onTap: onBellTap,
          child: Stack(
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
        ),
      ],
    );
  }
}

/// Pending caretaker link request shown to the patient. Tapping it opens the
/// approval screen; once approved or declined the banner dismisses itself.
class _CaretakerRequestBanner extends StatefulWidget {
  const _CaretakerRequestBanner();

  @override
  State<_CaretakerRequestBanner> createState() =>
      _CaretakerRequestBannerState();
}

class _CaretakerRequestBannerState extends State<_CaretakerRequestBanner> {
  bool _visible = true;

  Future<void> _review() async {
    final l10n = AppLocalizations.of(context);
    final caretakerName = l10n.caretakerFullName;
    final approved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            CaretakerApprovalScreen(caretakerName: caretakerName),
      ),
    );
    if (approved == null || !mounted) return;
    setState(() => _visible = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            approved
                ? l10n.caretakerNowYours(caretakerName)
                : l10n.requestDeclined,
          ),
          backgroundColor: AppColors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Material(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _review,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.person_add_alt, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.caretakerWantsToBe(l10n.caretakerFullName),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.tapToReview,
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyGoalsCard extends StatelessWidget {
  const _DailyGoalsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n.dailyGoals,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _GoalItem(text: l10n.goalProtein),
          _GoalItem(text: l10n.goalExercise),
          _GoalItem(text: l10n.goalWater),
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
  final void Function(HomeFeature feature) onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      _Feature(HomeFeature.mealMenus, l10n.featureMealMenus,
          Icons.restaurant_menu, const Color(0xFF3B8B5F)),
      _Feature(HomeFeature.exercisePlan, l10n.featureExercisePlan,
          Icons.fitness_center, const Color(0xFF3E7CB1)),
      _Feature(HomeFeature.sarcfAssessment, l10n.featureSarcfAssessment,
          Icons.assignment_outlined, const Color(0xFFCB8A2E)),
      _Feature(HomeFeature.healthTracking, l10n.featureHealthTracking,
          Icons.monitor_heart_outlined, const Color(0xFFB0524B)),
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
          _FeatureTile(feature: f, onTap: () => onTap(f.feature)),
      ],
    );
  }
}

class _Feature {
  const _Feature(this.feature, this.title, this.icon, this.color);
  final HomeFeature feature;
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
