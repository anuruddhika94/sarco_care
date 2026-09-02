import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'my_plan_screen.dart';

/// Screen #7 — Exercise Video.
/// Plays the exercise's YouTube video, with duration, step instructions and
/// Start/Complete + My Plan actions. Start toggles to Complete, then returns.
class ExerciseVideoScreen extends StatefulWidget {
  const ExerciseVideoScreen({
    super.key,
    required this.exerciseName,
    required this.videoId,
  });

  final String exerciseName;
  final String videoId;

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  bool _started = false;
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _onPrimary() {
    if (!_started) {
      setState(() => _started = true);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).exerciseCompletedLogged),
          backgroundColor: AppColors.primary,
        ),
      );
    Navigator.of(context).pop();
  }

  void _openMyPlan() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MyPlanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final instructions = [
      l10n.instruction1,
      l10n.instruction2,
      l10n.instruction3,
      l10n.instruction4,
    ];
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.sectionInstructions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          for (final line in instructions) _InstructionLine(text: line),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onPrimary,
              child: Text(_started ? l10n.complete : l10n.startExercise),
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
              child: Text(l10n.myPlanTitle),
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
