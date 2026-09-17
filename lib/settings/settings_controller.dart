import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../auth/auth_controller.dart';

/// App-wide accessibility settings. Currently drives the "Large Text" option,
/// which scales every text in the app up for easier reading — on by default,
/// since the audience is older adults.
///
/// Persisted locally (so it works before sign-in) and, once signed in, synced
/// to the backend via the user's `settings` (`PATCH /me`) so it follows the
/// account across devices.
class SettingsController extends ChangeNotifier {
  static const _prefsKey = 'large_text';

  /// Text magnification when Large Text is on.
  static const _largeScale = 1.2;

  bool _largeText = true;
  bool get largeText => _largeText;

  /// The scaler applied to the whole app (see `main.dart`).
  TextScaler get textScaler => TextScaler.linear(_largeText ? _largeScale : 1.0);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _largeText = prefs.getBool(_prefsKey) ?? true;
    notifyListeners();
  }

  Future<void> setLargeText(bool value) async {
    if (_largeText == value) return;
    _largeText = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
    if (authController.isSignedIn) {
      try {
        await apiClient.patch('/me', body: {
          'settings': {...authController.currentUser!.settings, 'large_text': value},
        });
      } on ApiException {
        // Local setting still applies; it'll sync next time this changes.
      }
    }
  }

  /// Applies a value restored from the backend (`User#settings`), without
  /// re-syncing it back — used right after sign-in/session restore.
  Future<void> applyFromBackend(bool value) async {
    if (_largeText == value) return;
    _largeText = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}

/// The global settings controller, created in `main()`.
late SettingsController settingsController;
