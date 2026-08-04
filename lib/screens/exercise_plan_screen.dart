import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';
import '../widgets/segmented_tabs.dart';

/// Screen #6 — Exercise Plan.
/// Pure UI: featured video, plan type, Exercises/My Plan tabs and a grid of
/// exercise cards. Cards forward to the Exercise Video placeholder (#7).
class ExercisePlanScreen extends StatefulWidget {
  const ExercisePlanScreen({super.key});

  @override
  State<ExercisePlanScreen> createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {
  int _tabIndex = 0;

  static const _exercises = [
    _Exercise('Seated Leg Lift', '10 min', Icons.airline_seat_recline_normal),
    _Exercise('Arm Curls', '8 min', Icons.fitness_center),
    _Exercise('Chair Squats', '12 min', Icons.chair_alt),
    _Exercise('Standing Balance', '6 min', Icons.accessibility_new),
  ];

  void _openVideo(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: const Text(
          'Exercise Plan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _FeaturedVideo(onTap: () => _openVideo('Basic Strength Training')),
          const SizedBox(height: 16),
          Text(
            'Type: Basic Strength Training',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedTabs(
            labels: const ['Exercises', 'My Plan'],
            selected: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
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
              for (int i = 0; i < _exercises.length; i++)
                _ExerciseCard(
                  index: i + 1,
                  exercise: _exercises[i],
                  onTap: () => _openVideo(_exercises[i].name),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Exercise {
  const _Exercise(this.name, this.duration, this.icon);
  final String name;
  final String duration;
  final IconData icon;
}

/// Large featured video card with a play overlay.
class _FeaturedVideo extends StatelessWidget {
  const _FeaturedVideo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          color: AppColors.softGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),
        ),
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
  final _Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              // Thumbnail placeholder with a number badge.
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        exercise.icon,
                        size: 40,
                        color: AppColors.primary,
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
                exercise.name,
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
                exercise.duration,
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
