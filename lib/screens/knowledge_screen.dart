import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'article_detail_screen.dart';

/// Knowledge tab (#12) — educational articles with category filters.
/// Pure UI: category tabs and a list of article rows opening placeholders.
class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  int _tabIndex = 0;

  static const _articles = [
    _Article('Overview', 'A quick introduction to muscle health', Icons.menu_book_outlined),
    _Article('What is Sarcopenia?', 'Understanding age-related muscle loss', Icons.help_outline),
    _Article('Causes and Risk Factors', 'What raises your risk', Icons.report_outlined),
    _Article('Exercise Guide', 'Safe movements to stay strong', Icons.fitness_center),
    _Article('Nutrition', 'Eating well for your muscles', Icons.restaurant_menu),
    _Article('Prevention', 'Daily habits that protect you', Icons.shield_outlined),
  ];

  void _openArticle(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailScreen(title: title)),
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Knowledge',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: const ['All', 'Food', 'Exercise', 'Prevention'],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                for (final a in _articles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ArticleRow(
                      article: a,
                      onTap: () => _openArticle(a.title),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Article {
  const _Article(this.title, this.summary, this.icon);
  final String title;
  final String summary;
  final IconData icon;
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.article, required this.onTap});
  final _Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(article.icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      article.summary,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
