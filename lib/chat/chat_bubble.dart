import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import 'chat_controller.dart';
import 'chat_screen.dart';

const _diameter = 58.0;

/// The floating "chat" bubble shown above every screen after login. Drag it
/// anywhere on screen; its position (as a fraction of the screen size, so it
/// adapts across devices) is remembered for next time.
///
/// Painted from `MaterialApp.builder` so it sits over the whole route stack
/// (including pushed detail screens). Tapping it opens [ChatScreen] via the
/// app navigator key and hides the bubble while the chat is open.
class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  static const _xKey = 'chat_bubble_x';
  static const _yKey = 'chat_bubble_y';

  Offset? _topLeft;
  // Fractional position (0..1) restored from prefs, applied once we know the
  // screen size on first build.
  Offset? _pendingFraction;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble(_xKey);
    final y = prefs.getDouble(_yKey);
    if (x == null || y == null || !mounted) return;
    setState(() => _pendingFraction = Offset(x, y));
  }

  Future<void> _savePosition(Offset fraction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_xKey, fraction.dx);
    await prefs.setDouble(_yKey, fraction.dy);
  }

  Offset _defaultTopLeft(Size screen, double bottomInset) {
    // Mirrors the bubble's original fixed spot: clear of the bottom nav bar
    // (68px) + safe area, 20px from the right edge.
    return Offset(
      screen.width - _diameter - 20,
      screen.height - _diameter - 68 - bottomInset - 20,
    );
  }

  Offset _clamp(Offset topLeft, Size screen, EdgeInsets padding) {
    final minX = 8.0;
    final maxX = screen.width - _diameter - 8;
    final minY = padding.top + 8;
    final maxY = screen.height - _diameter - padding.bottom - 8;
    return Offset(
      topLeft.dx.clamp(minX, maxX),
      topLeft.dy.clamp(minY, maxY),
    );
  }

  Future<void> _openChat() async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    chatController.setChatOpen(true);
    await navigator.push(
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
    chatController.setChatOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screen = mediaQuery.size;

    var topLeft = _topLeft;
    if (topLeft == null) {
      final fraction = _pendingFraction;
      topLeft = fraction == null
          ? _defaultTopLeft(screen, mediaQuery.padding.bottom)
          : Offset(fraction.dx * screen.width, fraction.dy * screen.height);
      topLeft = _clamp(topLeft, screen, mediaQuery.padding);
    }

    return Positioned(
      left: topLeft.dx,
      top: topLeft.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (details) {
          setState(() {
            _topLeft = _clamp(topLeft! + details.delta, screen, mediaQuery.padding);
          });
        },
        onPanEnd: (_) {
          setState(() => _dragging = false);
          final t = _topLeft;
          if (t != null) {
            _savePosition(Offset(t.dx / screen.width, t.dy / screen.height));
          }
        },
        onTap: _openChat,
        child: Semantics(
          button: true,
          label: l10n.chatBubbleTooltip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: _diameter,
            height: _diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.35, -0.45),
                radius: 1.1,
                colors: [
                  Color(0xFFFF6B5B),
                  Color(0xFFE0342A),
                  Color(0xFFA30F0F),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _dragging ? 0.5 : 0.35),
                  blurRadius: _dragging ? 18 : 10,
                  offset: Offset(0, _dragging ? 9 : 5),
                ),
                BoxShadow(
                  color: const Color(0xFFA30F0F).withValues(alpha: 0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gloss highlight for a glassy 3D sheen.
                Positioned(
                  top: _diameter * 0.1,
                  left: _diameter * 0.16,
                  child: Container(
                    width: _diameter * 0.4,
                    height: _diameter * 0.22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
