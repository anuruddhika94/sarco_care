import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';

/// Screen #7 — Exercise Video.
/// Pure UI: video player, duration, step instructions and Start/Complete +
/// My Plan actions. Start toggles to Complete, which confirms and returns.
class ExerciseVideoScreen extends StatefulWidget {
  const ExerciseVideoScreen({super.key, required this.exerciseName});

  final String exerciseName;

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  bool _started = false;

  static const _instructions = [
    'Perform 10–15 reps per set',
    '2–3 sets with short rests',
    'Sit tall and move slowly and steadily',
    'Follow the clear step-by-step video',
  ];

  void _onPrimary() {
    if (!_started) {
      setState(() => _started = true);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Exercise completed and logged'),
          backgroundColor: AppColors.primary,
        ),
      );
    Navigator.of(context).pop();
  }

  void _openMyPlan() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'My Plan')),
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
        title: Text(
          widget.exerciseName,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const _VideoPlayer(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                'Video duration: 10 min',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          for (final line in _instructions) _InstructionLine(text: line),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onPrimary,
              child: Text(_started ? 'Complete' : 'Start Exercise'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _openMyPlan,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(56),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('My Plan'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Video surface placeholder with a play button and a mock progress bar.
class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFF2B3A2F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                const Text(
                  '0:05',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.1,
                      minHeight: 4,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '10:00',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionLine extends StatelessWidget {
  const _InstructionLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.35,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
