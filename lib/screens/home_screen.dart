import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../auth/auth_controller.dart';
import '../chat/chat_bubble.dart';
import '../chat/chat_controller.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';
import '../widgets/app_card.dart';
import '../widgets/feature_tile.dart';
import 'assessment_screen.dart';
import 'caretaker_approval_screen.dart';
import 'exercise_plan_screen.dart';
import 'health_tracking_screen.dart';
import 'meals_screen.dart';
import 'notifications_screen.dart';

/// The four dashboard shortcuts. The enum keeps navigation independent of the
/// (translated) tile label.
enum HomeFeature { mealMenus, exercisePlan, sarcfAssessment, healthTracking }

/// Screen #3 — Home / dashboard (the Home tab of the app shell).
/// Greeting, a pending-caretaker-request banner and Daily Goals are loaded
/// from the Rails API; the feature grid below is static navigation.
/// The bottom navigation bar lives in [MainShell]; tiles push full screens.
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
    final name = authController.currentUser?.firstName ?? l10n.userFirstName;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Home is sized from the height actually available so it fills the
            // screen without scrolling — on a short phone, a tall one, and in a
            // mobile browser whose viewport shrinks around the address bar.
            // Sizes are compared against the text scale (Large Text is on by
            // default) because that is what makes the fixed parts grow.
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final height = constraints.maxHeight;
            final compact = height < 700 * textScale;
            // The greeting, goals card and section heading come to roughly
            // 270dp at compact sizes and grow with the text scale; the grid
            // needs about 160dp left over to stay comfortably tappable. Below
            // that, scrolling is the lesser evil.
            final fits = height >= 270 * textScale + 160;

            // The chat bubble floats over every screen. Home doesn't scroll,
            // so it leaves room rather than letting the bubble sit on top of
            // the bottom-right tile's label.
            final bottomPadding = (compact ? 12.0 : 20.0) +
                (chatController.bubbleVisible ? chatBubbleClearance : 0);

            final content = Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                compact ? 8 : 16,
                20,
                bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingHeader(
                    name: name,
                    compact: compact,
                    onBellTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                  ),
                  const _CaretakerRequestBanner(),
                  SizedBox(height: compact ? 12 : 20),
                  _DailyGoalsCard(compact: compact),
                  SizedBox(height: compact ? 12 : 20),
                  // The heading is the first thing to go on a short screen:
                  // it wraps to two lines and the tiles are self-explanatory.
                  if (!compact) ...[
                    Text(
                      l10n.whatWouldYouLikeToDo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  // The grid takes whatever height is left over, so the four
                  // tiles always land on screen.
                  if (fits)
                    Expanded(
                      child: _FeatureGrid(
                        fill: true,
                        compact: compact,
                        onTap: (feature) => _open(context, feature),
                      ),
                    )
                  else
                    _FeatureGrid(
                      fill: false,
                      compact: compact,
                      onTap: (feature) => _open(context, feature),
                    ),
                ],
              ),
            );

            return fits ? content : SingleChildScrollView(child: content);
          },
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.name,
    required this.onBellTap,
    required this.compact,
  });
  final String name;
  final VoidCallback onBellTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = authController.currentUser;
    return Row(
      children: [
        AppAvatar(
          asset: user?.avatarUrl,
          fallbackIcon: user?.isPatient == false ? Icons.person : Icons.elderly,
          size: compact ? 44 : 52,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // On a short screen the greeting is one line: the second line
              // wraps and costs more height than it earns.
              if (!compact) ...[
                Text(
                  l10n.welcomeBack,
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                l10n.homeGreetingName(name),
                style: TextStyle(
                  fontSize: compact ? 20 : 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                width: compact ? 42 : 48,
                height: compact ? 42 : 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: AppShadows.card,
                  borderRadius: AppRadius.small,
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

/// Pending caretaker link request shown to the patient, loaded from
/// `GET /care_links?status=pending`. Tapping it opens the approval screen;
/// approving/declining calls `PATCH /care_links/:id` and the banner hides.
class _CaretakerRequestBanner extends StatefulWidget {
  const _CaretakerRequestBanner();

  @override
  State<_CaretakerRequestBanner> createState() =>
      _CaretakerRequestBannerState();
}

class _CaretakerRequestBannerState extends State<_CaretakerRequestBanner> {
  int? _linkId;
  String? _caretakerName;

  @override
  void initState() {
    super.initState();
    _loadPendingRequest();
  }

  Future<void> _loadPendingRequest() async {
    try {
      final links = await apiClient.get('/care_links', query: {'status': 'pending'});
      if (!mounted || links is! List || links.isEmpty) return;
      final link = links.first as Map<String, dynamic>;
      setState(() {
        _linkId = link['id'] as int;
        _caretakerName = (link['caretaker'] as Map<String, dynamic>)['full_name'] as String;
      });
    } on ApiException {
      // No pending-request banner if the API call fails; the rest of Home
      // still renders.
    }
  }

  Future<void> _review() async {
    final l10n = AppLocalizations.of(context);
    final linkId = _linkId;
    final caretakerName = _caretakerName;
    if (linkId == null || caretakerName == null) return;

    final approved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CaretakerApprovalScreen(caretakerName: caretakerName),
      ),
    );
    if (approved == null || !mounted) return;

    try {
      await apiClient.patch('/care_links/$linkId', body: {
        'status': approved ? 'approved' : 'declined',
      });
      if (!mounted) return;
      setState(() => _linkId = null);
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
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_linkId == null) return const SizedBox.shrink();
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
                        l10n.caretakerWantsToBe(_caretakerName!),
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

/// Today's goal completion, loaded from `GET /daily_goals?range=daily`. No
/// record yet for today just means nothing is checked off.
class _DailyGoalsCard extends StatefulWidget {
  const _DailyGoalsCard({required this.compact});

  final bool compact;

  @override
  State<_DailyGoalsCard> createState() => _DailyGoalsCardState();
}

class _DailyGoalsCardState extends State<_DailyGoalsCard> {
  bool _protein = false;
  bool _exercise = false;
  bool _water = false;

  @override
  void initState() {
    super.initState();
    _loadTodayGoals();
  }

  Future<void> _loadTodayGoals() async {
    try {
      final goals = await apiClient.get('/daily_goals', query: {'range': 'daily'});
      if (!mounted || goals is! List || goals.isEmpty) return;
      final today = goals.first as Map<String, dynamic>;
      setState(() {
        _protein = today['protein_done'] as bool;
        _exercise = today['exercise_done'] as bool;
        _water = today['water_done'] as bool;
      });
    } on ApiException {
      // Keep everything unchecked if the API call fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final compact = widget.compact;
    return AppCard(
      color: const Color(0xFFFDF3D8),
      border: false,
      padding: EdgeInsets.all(compact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyGoals,
            style: TextStyle(
              fontSize: compact ? 15 : 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: compact ? 8 : 16),
          _GoalItem(text: l10n.goalProtein, done: _protein, compact: compact),
          _GoalItem(text: l10n.goalExercise, done: _exercise, compact: compact),
          _GoalItem(
            text: l10n.goalWater,
            done: _water,
            compact: compact,
            last: true,
          ),
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  const _GoalItem({
    required this.text,
    required this.done,
    required this.compact,
    this.last = false,
  });
  final String text;
  final bool done;
  final bool compact;

  /// The last item needs no trailing gap — the card's own padding closes it.
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : (compact ? 6 : 12)),
      child: Row(
        children: [
          Container(
            width: compact ? 20 : 24,
            height: compact ? 20 : 24,
            decoration: BoxDecoration(
              color: done ? AppColors.primary : AppColors.surface,
              shape: BoxShape.circle,
              border: done ? null : Border.all(color: const Color(0xFFDDD0AE)),
            ),
            child: done
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: compact ? 14 : 16,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({
    required this.onTap,
    required this.fill,
    required this.compact,
  });
  final void Function(HomeFeature feature) onTap;

  /// True when the grid has a bounded height to fill (the usual case): the
  /// two rows split it evenly, so the tiles end exactly at the bottom of the
  /// screen. False on a viewport too short to fit Home, where the grid falls
  /// back to its own intrinsic height inside a scroll view.
  final bool fill;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      _Feature(HomeFeature.mealMenus, l10n.featureMealMenus,
          Icons.ramen_dining, const Color(0xFF3B8B5F),
          'assets/images/features/meals.jpg'),
      _Feature(HomeFeature.exercisePlan, l10n.featureExercisePlan,
          Icons.sports_gymnastics, const Color(0xFF3E7CB1),
          'assets/images/features/exercise.jpg'),
      _Feature(HomeFeature.sarcfAssessment, l10n.featureSarcfAssessment,
          Icons.fact_check, const Color(0xFFCB8A2E),
          'assets/images/features/assessment.jpg'),
      _Feature(HomeFeature.healthTracking, l10n.featureHealthTracking,
          Icons.monitor_heart, const Color(0xFFB0524B),
          'assets/images/features/health.jpg'),
    ];

    final gap = compact ? 12.0 : 16.0;
    final tiles = [
      for (final f in features)
        FeatureTile(
          title: f.title,
          icon: f.icon,
          color: f.color,
          image: f.image,
          onTap: () => onTap(f.feature),
        ),
    ];

    if (!fill) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: gap,
        crossAxisSpacing: gap,
        childAspectRatio: 1.05,
        children: tiles,
      );
    }

    return Column(
      children: [
        Expanded(child: _GridRow(tiles: tiles.sublist(0, 2), gap: gap)),
        SizedBox(height: gap),
        Expanded(child: _GridRow(tiles: tiles.sublist(2), gap: gap)),
      ],
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({required this.tiles, required this.gap});
  final List<Widget> tiles;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: tiles.first),
        SizedBox(width: gap),
        Expanded(child: tiles.last),
      ],
    );
  }
}

class _Feature {
  const _Feature(this.feature, this.title, this.icon, this.color, this.image);
  final HomeFeature feature;
  final String title;
  final IconData icon;
  final Color color;
  final String image;
}
