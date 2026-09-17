import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'my_plan_screen.dart';

/// Screen #7 — Exercise Video.
/// Plays the exercise's YouTube video, with duration, step instructions and
/// Start/Complete + My Plan actions. Start toggles to Complete; completing
/// logs it for today via `POST /exercise_logs`, then returns.
class ExerciseVideoScreen extends StatefulWidget {
  const ExerciseVideoScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    required this.videoId,
    required this.minutes,
    this.patientId,
  });

  final int exerciseId;
  final String exerciseName;
  final String videoId;
  final int minutes;

  /// Set when a caretaker is logging this on behalf of a linked patient.
  final int? patientId;

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  bool _started = false;
  bool _completing = false;
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

  Future<void> _onPrimary() async {
    if (!_started) {
      setState(() => _started = true);
      return;
    }

    setState(() => _completing = true);
    final l10n = AppLocalizations.of(context);
    try {
      await apiClient.post('/exercise_logs', body: {
        'exercise_id': widget.exerciseId,
        'minutes': widget.minutes,
        if (widget.patientId != null) 'patient_id': widget.patientId,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.exerciseCompletedLogged),
            backgroundColor: AppColors.primary,
          ),
        );
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _completing = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _openMyPlan() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyPlanScreen(patientId: widget.patientId)),
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
          const SizedBox(height: 16),
          Text(
            widget.exerciseName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
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
              onPressed: _completing ? null : _onPrimary,
              child: _completing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(_started ? l10n.complete : l10n.startExercise),
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
