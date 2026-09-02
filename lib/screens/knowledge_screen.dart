import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/segmented_tabs.dart';
import 'article_detail_screen.dart';

/// Knowledge tab (#12) — educational articles with category filters.
/// Pure UI: category tabs and a list of article rows opening the detail screen.
class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

/// Article categories. [general] articles surface only under the "All" tab.
enum ArticleCategory { general, food, exercise, prevention }

enum ArticleId {
  overview,
  whatIs,
  causes,
  exerciseGuide,
  nutrition,
  prevention,
}

String articleTitle(AppLocalizations l10n, ArticleId id) => switch (id) {
      ArticleId.overview => l10n.artOverviewTitle,
      ArticleId.whatIs => l10n.artWhatIsTitle,
      ArticleId.causes => l10n.artCausesTitle,
      ArticleId.exerciseGuide => l10n.artExerciseGuideTitle,
      ArticleId.nutrition => l10n.artNutritionTitle,
      ArticleId.prevention => l10n.artPreventionTitle,
    };

String articleSummary(AppLocalizations l10n, ArticleId id) => switch (id) {
      ArticleId.overview => l10n.artOverviewSummary,
      ArticleId.whatIs => l10n.artWhatIsSummary,
      ArticleId.causes => l10n.artCausesSummary,
      ArticleId.exerciseGuide => l10n.artExerciseGuideSummary,
      ArticleId.nutrition => l10n.artNutritionSummary,
      ArticleId.prevention => l10n.artPreventionSummary,
    };

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  int _tabIndex = 0;

  // Tab index → category filter (null = show all).
  static const _filters = [
    null,
    ArticleCategory.food,
    ArticleCategory.exercise,
    ArticleCategory.prevention,
  ];

  static const _articles = [
    _Article(ArticleId.overview, Icons.menu_book_outlined, ArticleCategory.general),
    _Article(ArticleId.whatIs, Icons.help_outline, ArticleCategory.general),
    _Article(ArticleId.causes, Icons.report_outlined, ArticleCategory.prevention),
    _Article(ArticleId.exerciseGuide, Icons.fitness_center, ArticleCategory.exercise),
    _Article(ArticleId.nutrition, Icons.restaurant_menu, ArticleCategory.food),
    _Article(ArticleId.prevention, Icons.shield_outlined, ArticleCategory.prevention),
  ];

  List<_Article> get _visibleArticles {
    final filter = _filters[_tabIndex];
    if (filter == null) return _articles;
    return _articles.where((a) => a.category == filter).toList();
  }

  void _openArticle(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailScreen(title: title)),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                for (final a in _visibleArticles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ArticleRow(
                      article: a,
                      onTap: () => _openArticle(articleTitle(l10n, a.id)),
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
  const _Article(this.id, this.icon, this.category);
  final ArticleId id;
  final IconData icon;
  final ArticleCategory category;
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.article, required this.onTap});
  final _Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                      articleTitle(l10n, article.id),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      articleSummary(l10n, article.id),
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
