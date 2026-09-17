import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pill-style segmented selector shared across screens (meals, exercises, …).
/// Visual selection only — the parent decides what each segment shows.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.scrollable = false,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  /// When there are too many segments to fit evenly (e.g. a 7-day plan),
  /// lay them out at their natural width in a horizontal scroller instead
  /// of squeezing them into equal-width `Expanded` slots. A fading chevron
  /// hints that there's more to scroll to.
  final bool scrollable;

  Widget _segment(int i) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: scrollable
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
            : const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected == i ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          labels[i],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected == i ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: scrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < labels.length; i++)
                    Padding(
                      padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 6),
                      child: _segment(i),
                    ),
                ],
              ),
            )
          : Row(
              children: [
                for (int i = 0; i < labels.length; i++) Expanded(child: _segment(i)),
              ],
            ),
    );

    if (!scrollable) return base;

    // A fading strip with a chevron at the trailing edge, hinting that the
    // row of segments scrolls horizontally.
    return Stack(
      children: [
        base,
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 28,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0)],
                ),
              ),
              child: Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }
}
