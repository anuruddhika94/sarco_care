import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The app's standard surface: a white block with a soft warm shadow and a
/// hairline edge. Screens used to build these inline with their own colours,
/// radii and no elevation at all, which is what made them read as flat.
///
/// Pass [onTap] to make it tappable — the ink ripple is clipped to the corner
/// radius, and the card lifts slightly while pressed.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.borderRadius,
    this.border = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Defaults to the surface colour; pass a tint for an accent card.
  final Color? color;
  final BorderRadius? borderRadius;
  final bool border;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.large;
    final tappable = widget.onTap != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scaleByDouble(
          _pressed ? 0.985 : 1.0,
          _pressed ? 0.985 : 1.0,
          1,
          1,
        ),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.color ?? AppColors.surface,
        borderRadius: radius,
        border: widget.border
            ? Border.all(color: AppColors.border, width: 1)
            : null,
        boxShadow: _pressed ? AppShadows.raised : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: radius,
          onHighlightChanged: tappable
              ? (value) => setState(() => _pressed = value)
              : null,
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}
