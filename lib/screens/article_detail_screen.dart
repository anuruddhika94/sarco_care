import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Article detail — a readable educational article opened from Knowledge.
/// Pure UI: hero, meta chips and body paragraphs (shared sample content).
class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final paragraphs = [
      l10n.articleParagraph1,
      l10n.articleParagraph2,
      l10n.articleParagraph3,
    ];
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
            child: Icon(Icons.menu_book_outlined, size: 72, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MetaChip(text: l10n.navKnowledge),
              const SizedBox(width: 8),
              _MetaChip(text: l10n.chipReadTime),
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
