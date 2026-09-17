import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'knowledge_screen.dart';

/// Article detail — a readable educational article opened from Knowledge,
/// rendered from the article data loaded there (`GET /articles`). A
/// "Read aloud" button speaks the article (text-to-speech) in the app's
/// current language, for readers who find it easier to listen.
class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Map<String, dynamic> article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => _speaking = false);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleReadAloud(String text) async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    final lang =
        Localizations.localeOf(context).languageCode == 'th' ? 'th-TH' : 'en-US';
    await _tts.setLanguage(lang);
    await _tts.setSpeechRate(0.44); // a little slower, easier to follow
    await _tts.setPitch(1.0);
    if (mounted) setState(() => _speaking = true);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isThai = Localizations.localeOf(context).languageCode == 'th';
    final title = (isThai ? widget.article['title_th'] : widget.article['title_en']) as String;
    final paragraphs = ((isThai ? widget.article['body_th'] : widget.article['body_en']) as List)
        .cast<String>();
    final readMinutes = widget.article['read_minutes'] as int;
    final icon = articleIconForKey(widget.article['icon'] as String);
    final spoken = '$title. ${paragraphs.join(' ')}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.articleAppbar,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Hero image placeholder.
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 72, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MetaChip(text: l10n.navKnowledge),
              const SizedBox(width: 8),
              _MetaChip(text: l10n.articleReadMinutes(readMinutes)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // Read-aloud control.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _toggleReadAloud(spoken),
              icon: Icon(_speaking ? Icons.stop_rounded : Icons.record_voice_over),
              label: Text(_speaking ? l10n.stopReading : l10n.readAloud),
            ),
          ),
          const SizedBox(height: 20),
          for (final p in paragraphs) ...[
            Text(
              p,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
