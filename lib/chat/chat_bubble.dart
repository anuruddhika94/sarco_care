import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'chat_controller.dart';
import 'chat_screen.dart';

/// The floating "chat" bubble shown above every screen after login.
///
/// Painted from `MaterialApp.builder` so it sits over the whole route stack
/// (including pushed detail screens). Tapping it opens [ChatScreen] via the
/// app navigator key and hides the bubble while the chat is open.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key});

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
    return Positioned(
      right: 20,
      bottom: 90,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: Colors.black45,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _openChat,
          // The bubble is painted above the Navigator's Overlay, so a Tooltip
          // (which needs an Overlay ancestor) can't be used here — Semantics
          // carries the label for accessibility instead.
          child: Semantics(
            button: true,
            label: l10n.chatBubbleTooltip,
            child: const SizedBox(
              width: 58,
              height: 58,
              child: Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
