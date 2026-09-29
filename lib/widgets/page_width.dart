import 'package:flutter/material.dart';

/// Keeps the app readable on tablets.
///
/// Every screen was laid out for a phone: full-width buttons, two-column
/// grids, text running the whole width. On an iPad that becomes a very wide
/// column — 40-character buttons and lines of text too long to scan
/// comfortably. Rather than redesign each screen for large displays, the whole
/// app is held to a phone-like column and centred, which is what most
/// health apps do on tablets.
class PageWidth extends StatelessWidget {
  const PageWidth({super.key, required this.child});

  /// Roughly the width of a large phone. Wider than this and line lengths
  /// start to hurt; narrower and a tablet feels wasteful.
  static const maxWidth = 560.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= maxWidth) return child;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: maxWidth,
        // The child reads MediaQuery for its own sizing (Home and Profile
        // measure the space they have), so it has to see the narrowed width
        // rather than the tablet's full one.
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: Size(maxWidth, MediaQuery.sizeOf(context).height),
          ),
          child: child,
        ),
      ),
    );
  }
}
