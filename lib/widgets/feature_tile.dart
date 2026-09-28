import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A full-bleed illustration tile with a gradient-scrimmed label — the
/// shared style for both the patient Home screen's and the caretaker Home
/// screen's feature grids, so they look the same.
class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.image,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;

  /// Illustration asset path; falls back to [icon] on a soft tinted block
  /// if it fails to load.
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 56),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: AppRadius.large,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The illustration fills the whole tile.
              Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
              // Soft scrim at the bottom so the label stays readable.
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surface.withValues(alpha: 0),
                        AppColors.surface.withValues(alpha: 0.75),
                        AppColors.surface.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: AppColors.textDark,
                    ),
                  ),
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
