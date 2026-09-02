import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

/// App-wide language state.
///
/// A single instance ([localeController]) is created in `main()` and drives the
/// [MaterialApp]'s locale. Changing it rebuilds the whole app in the new
/// language and persists the choice so it is restored on the next launch.
class LocaleController extends ValueNotifier<Locale> {
  LocaleController(super.value);

  static const _prefsKey = 'app_locale';

  /// Languages offered in the in-app switcher, in display order.
  static const supported = <Locale>[Locale('en'), Locale('th')];

  /// Restore the saved language, falling back to the current [value].
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code != null && supported.any((l) => l.languageCode == code)) {
      value = Locale(code);
    }
  }

  /// Switch language and remember the choice.
  Future<void> setLocale(Locale locale) async {
    if (locale == value) return;
    value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  /// The language's own native name, for display in the switcher.
  static String nativeName(Locale locale) =>
      switch (locale.languageCode) { 'th' => 'ไทย', _ => 'English' };
}

/// The global language controller, created in `main()`.
late final LocaleController localeController;

/// Shorthand for the current screen's localized strings.
AppLocalizations l10nOf(BuildContext context) => AppLocalizations.of(context);
