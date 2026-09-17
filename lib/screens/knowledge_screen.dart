import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'article_detail_screen.dart';

/// Knowledge tab (#12) — educational articles with category filters, loaded
/// from `GET /articles`. 'general' articles surface only under the "All" tab.
class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  int _tabIndex = 0;
  List<Map<String, dynamic>>? _articles;
  String? _error;

  // Tab index → category filter (null = show all).
  static const _filters = [null, 'food', 'exercise', 'prevention'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await apiClient.get('/articles');
      if (!mounted) return;
      setState(() => _articles = (data as List).cast<Map<String, dynamic>>());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  List<Map<String, dynamic>> get _visibleArticles {
    final articles = _articles;
    if (articles == null) return const [];
    final filter = _filters[_tabIndex];
    if (filter == null) return articles;
    return articles.where((a) => a['category'] == filter).toList();
  }

  void _openArticle(Map<String, dynamic> article) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
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
        automaticallyImplyLeading: false,
        title: Text(
          l10n.navKnowledge,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SegmentedTabs(
              labels: [l10n.catAll, l10n.catFood, l10n.navExercise, l10n.catPrevention],
              selected: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(child: _buildList(l10n)),
        ],
      ),
    );
  }

  Widget _buildList(AppLocalizations l10n) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }
    if (_articles == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        for (final a in _visibleArticles)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ArticleRow(article: a, onTap: () => _openArticle(a)),
          ),
      ],
    );
  }
}

/// Maps the API's icon key (a Material icon name) to its constant.
IconData articleIconForKey(String key) => switch (key) {
      'menu_book_outlined' => Icons.menu_book_outlined,
      'help_outline' => Icons.help_outline,
      'report_outlined' => Icons.report_outlined,
      'fitness_center' => Icons.fitness_center,
      'restaurant_menu' => Icons.restaurant_menu,
      'shield_outlined' => Icons.shield_outlined,
      _ => Icons.menu_book_outlined,
    };

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.article, required this.onTap});
  final Map<String, dynamic> article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isThai = Localizations.localeOf(context).languageCode == 'th';
    final title = (isThai ? article['title_th'] : article['title_en']) as String;
    final summary = (isThai ? article['summary_th'] : article['summary_en']) as String;
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
                child: Icon(articleIconForKey(article['icon'] as String), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      summary,
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
