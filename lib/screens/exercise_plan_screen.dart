import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_format.dart';
import '../theme/app_theme.dart';
import 'exercise_video_screen.dart';
import 'my_plan_screen.dart';

/// An exercise from the shared catalog, `GET /exercises` — the same list for
/// every patient. What a patient actually did on a given day is tracked
/// separately (see [MyPlanScreen], backed by `exercise_logs`).
class CatalogExercise {
  const CatalogExercise({
    required this.id,
    required this.nameEn,
    required this.nameTh,
    required this.icon,
    required this.videoId,
    required this.defaultMinutes,
  });

  factory CatalogExercise.fromJson(Map<String, dynamic> json) => CatalogExercise(
        id: json['id'] as int,
        nameEn: json['name_en'] as String,
        nameTh: json['name_th'] as String,
        icon: iconForKey(json['icon'] as String),
        videoId: json['video_id'] as String,
        defaultMinutes: json['default_minutes'] as int,
      );

  final int id;
  final String nameEn;
  final String nameTh;
  final IconData icon;
  final String videoId;
  final int defaultMinutes;

  String name(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'th' ? nameTh : nameEn;
}

/// Maps the API's icon key (a Material icon name, e.g. "fitness_center") to
/// its constant. Add cases here as new exercises introduce new icons.
IconData iconForKey(String key) => switch (key) {
      'airline_seat_recline_normal' => Icons.airline_seat_recline_normal,
      'fitness_center' => Icons.fitness_center,
      'chair_alt' => Icons.chair_alt,
      'accessibility_new' => Icons.accessibility_new,
      _ => Icons.sports_gymnastics,
    };

/// Fetches the shared exercise catalog from `GET /exercises`.
Future<List<CatalogExercise>> fetchExercises() async {
  final data = await apiClient.get('/exercises');
  return (data as List).map((e) => CatalogExercise.fromJson(e as Map<String, dynamic>)).toList();
}

/// Screen #6 — Exercise Plan.
/// The shared exercise catalog (same for every patient); tap a card to watch
/// its video. A history icon opens [MyPlanScreen] to see/record what was
/// actually done on any given date.
class ExercisePlanScreen extends StatefulWidget {
  const ExercisePlanScreen({super.key, this.showBackButton = true});

  /// False when shown as a shell tab root (no route to pop back to).
  final bool showBackButton;

  @override
  State<ExercisePlanScreen> createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {
  List<CatalogExercise>? _exercises;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final exercises = await fetchExercises();
      if (!mounted) return;
      setState(() => _exercises = exercises);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  void _openVideo(CatalogExercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExerciseVideoScreen(
          exerciseId: exercise.id,
          exerciseName: exercise.name(context),
          videoId: exercise.videoId,
          minutes: exercise.defaultMinutes,
        ),
      ),
    );
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MyPlanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        automaticallyImplyLeading: widget.showBackButton,
        title: Text(
          l10n.featureExercisePlan,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: l10n.myPlanTitle,
            onPressed: _openHistory,
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null) {
      return _ErrorState(message: _error!, onRetry: _load);
    }
    final exercises = _exercises;
    if (exercises == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.exerciseTypeLabel(l10n.planTypeBasicStrength),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.82,
          children: [
            for (int i = 0; i < exercises.length; i++)
              _ExerciseCard(
                index: i + 1,
                exercise: exercises[i],
                onTap: () => _openVideo(exercises[i]),
              ),
          ],
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}

/// YouTube thumbnail with a play overlay; falls back to an icon if it fails.
class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.videoId,
    required this.fallbackIcon,
    required this.radius,
    this.playSize = 48,
  });

  final String videoId;
  final IconData fallbackIcon;
  final double radius;
  final double playSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          videoId.isEmpty
              ? Container(
                  color: AppColors.softGreen,
                  alignment: Alignment.center,
                  child: Icon(fallbackIcon, size: 40, color: AppColors.primary),
                )
              : Image.network(
                  'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.softGreen,
                    alignment: Alignment.center,
                    child: Icon(fallbackIcon, size: 40, color: AppColors.primary),
                  ),
                ),
          // Subtle scrim so the play button reads on any thumbnail.
          Container(color: Colors.black.withValues(alpha: 0.12)),
          Center(
            child: Container(
              width: playSize,
              height: playSize,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: playSize * 0.62,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  final int index;
  final CatalogExercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // YouTube thumbnail with a number badge.
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _Thumb(
                        videoId: exercise.videoId,
                        fallbackIcon: exercise.icon,
                        radius: 12,
                        playSize: 40,
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE05B4B),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                exercise.name(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatDuration(l10n, exercise.defaultMinutes),
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
