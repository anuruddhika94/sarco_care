import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a short message at the top of the screen.
///
/// Flutter's SnackBar is anchored to the bottom, which on these screens is
/// where the navigation bar and the floating chat bubble live — so a "meal
/// logged" confirmation could land underneath them. This puts the message
/// under the status bar instead, where nothing covers it.
///
/// It fades out on its own, and a tap dismisses it early.
void showAppMessage(
  BuildContext context,
  String text, {
  bool isError = false,
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  _currentMessage?.remove();
  final entry = OverlayEntry(
    builder: (context) => _AppMessage(text: text, isError: isError),
  );
  _currentMessage = entry;
  overlay.insert(entry);

  Future<void>.delayed(const Duration(seconds: 3), () {
    if (_currentMessage == entry) {
      entry.remove();
      _currentMessage = null;
    }
  });
}

/// Only one message at a time: a second one replaces the first rather than
/// stacking up.
OverlayEntry? _currentMessage;

class _AppMessage extends StatefulWidget {
  const _AppMessage({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  State<_AppMessage> createState() => _AppMessageState();
}

class _AppMessageState extends State<_AppMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    final entry = _currentMessage;
    if (entry == null) return;
    _currentMessage = null;
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.isError ? AppColors.danger : AppColors.primary;
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    return Positioned(
      top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.4),
          end: Offset.zero,
        ).animate(curve),
        child: FadeTransition(
          opacity: curve,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: AppRadius.small,
                  boxShadow: AppShadows.raised,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.isError
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
