import 'package:flutter/material.dart';

/// Drives the floating chat bubble that sits above every screen once the user
/// has logged in. Kept as a single app-global instance so the bubble can be
/// painted from `MaterialApp.builder` (above the whole route stack) while any
/// screen toggles login/logout state.
class ChatController extends ChangeNotifier {
  bool _loggedIn = false;
  bool _chatOpen = false;

  /// Show the bubble only after login, and hide it while the chat itself is
  /// open (so it doesn't hover over the chat's own input).
  bool get bubbleVisible => _loggedIn && !_chatOpen;

  void onLogin() {
    if (_loggedIn) return;
    _loggedIn = true;
    notifyListeners();
  }

  void onLogout() {
    if (!_loggedIn) return;
    _loggedIn = false;
    _chatOpen = false;
    notifyListeners();
  }

  void setChatOpen(bool open) {
    if (_chatOpen == open) return;
    _chatOpen = open;
    notifyListeners();
  }
}

/// The global chat controller.
final ChatController chatController = ChatController();

/// Navigator key so the floating bubble — which lives above the Navigator in
/// `MaterialApp.builder` — can push the chat route.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
