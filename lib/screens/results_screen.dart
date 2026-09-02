import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'assessment_screen.dart';

/// Screen #9 — SARC-F Assessment Results.
/// Pure UI: risk badge derived from the score, tailored recommendations and a
/// Retake Assessment action. Score classification is simple arithmetic.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.score});

  /// Total of the selected answer severities (0 = best).
  final int score;

  _RiskLevel get _level {
    if (score <= 3) return _RiskLevel.low;
    if (score <= 7) return _RiskLevel.moderate;
    return _RiskLevel.high;
  }

  void _retake(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AssessmentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final level = _level;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.assessmentResults,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/result.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.softGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.elderly, size: 64, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _RiskBadge(level: level, score: score),
          const SizedBox(height: 28),
          Text(
            l10n.recommendations,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          for (final tip in _riskRecommendations(l10n, level)) _RecLine(text: tip),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _retake(context),
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
              child: Text(l10n.retakeAssessment),
            ),
          ),
        ],
      ),
    );
  }
}

enum _RiskLevel {
  low(Color(0xFF3B8B5F)),
  moderate(Color(0xFFCB8A2E)),
  high(Color(0xFFB0524B));

  const _RiskLevel(this.color);
  final Color color;
}

String _riskLabel(AppLocalizations l10n, _RiskLevel level) => switch (level) {
      _RiskLevel.low => l10n.riskLow,
      _RiskLevel.moderate => l10n.riskModerate,
      _RiskLevel.high => l10n.riskHigh,
    };

List<String> _riskRecommendations(AppLocalizations l10n, _RiskLevel level) =>
    switch (level) {
      _RiskLevel.low => [l10n.recLow1, l10n.recLow2, l10n.recLow3],
      _RiskLevel.moderate => [l10n.recModerate1, l10n.recModerate2, l10n.recModerate3],
      _RiskLevel.high => [l10n.recHigh1, l10n.recHigh2, l10n.recHigh3],
    };

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.level, required this.score});
  final _RiskLevel level;
  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: level.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            _riskLabel(l10n, level),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: level.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.scoreLabel(score),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecLine extends StatelessWidget {
  const _RecLine({required this.text});
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
