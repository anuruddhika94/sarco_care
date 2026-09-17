import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

/// Screen #8 — SARC-F Assessment.
/// A stepped 5-question survey with radio answers and a progress bar. The
/// final "See Results" submits the answers to `POST /assessments`, which
/// computes and returns the score and risk level.
class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key, this.patientId});

  /// Set when a caretaker is filling this out on behalf of a linked patient.
  final int? patientId;

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  static const _questionCount = 5;

  int _index = 0;
  // One selected option index per question (null = unanswered).
  final List<int?> _answers = List<int?>.filled(_questionCount, null);
  bool _submitting = false;

  bool get _isLast => _index == _questionCount - 1;
  bool get _hasAnswer => _answers[_index] != null;

  void _back() {
    if (_index > 0) {
      setState(() => _index--);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _next() async {
    if (!_isLast) {
      setState(() => _index++);
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await apiClient.post('/assessments', body: {
        'answers': _answers,
        if (widget.patientId != null) 'patient_id': widget.patientId,
      }) as Map<String, dynamic>;
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            score: result['score'] as int,
            riskLevel: result['risk_level'] as String,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questions = [
      l10n.assessmentQuestion1,
      l10n.assessmentQuestion2,
      l10n.assessmentQuestion3,
      l10n.assessmentQuestion4,
      l10n.assessmentQuestion5,
    ];
    final options = [
      l10n.optNoProblem,
      l10n.optMinorProblem,
      l10n.optModerateProblem,
      l10n.optSevereProblem,
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text(
          l10n.sarcfProgress(_index + 1, _questionCount),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar across the 5 questions.
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_index + 1) / _questionCount,
                minHeight: 8,
                backgroundColor: const Color(0xFFE4EAE4),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.questionNumber(_index + 1),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              questions[_index],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 28),
            for (int i = 0; i < options.length; i++)
              _OptionTile(
                label: options[i],
                selected: _answers[_index] == i,
                onTap: () => setState(() => _answers[_index] = i),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Require an answer before advancing.
                onPressed: (_hasAnswer && !_submitting) ? _next : null,
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isLast ? l10n.seeResults : l10n.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? AppColors.softGreen : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFEAEFEA),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
