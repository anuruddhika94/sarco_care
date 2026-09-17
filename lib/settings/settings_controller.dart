import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide accessibility settings. Currently drives the "Large Text" option,
/// which scales every text in the app up for easier reading — on by default,
/// since the audience is older adults. The choice is persisted.
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
  }
}

/// The global settings controller, created in `main()`.
late SettingsController settingsController;
