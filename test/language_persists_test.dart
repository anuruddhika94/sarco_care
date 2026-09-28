// Switching language must survive a reload. The cached user (restored on the
// next start) carries the account's settings, so it has to be updated when a
// setting is synced to the backend — otherwise the stale copy wins and the
// app snaps back to the old language.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/api/api_client.dart';
import 'package:sarco_care/auth/auth_controller.dart';
import 'package:sarco_care/l10n/locale_controller.dart';
import 'package:sarco_care/settings/settings_controller.dart';

Map<String, dynamic> _user({required String language, bool largeText = true}) => {
  'id': 1,
  'full_name': 'Somchai Jai-Dee',
  'phone_number': '0812345678',
  'role': 'patient',
  'settings': {'language': language, 'large_text': largeText},
};

/// Signs in with an account whose saved language is Thai, the way a real
/// session is restored from disk on start-up.
Future<void> _signInAsThaiAccount({required List<String> patchBodies}) async {
  SharedPreferences.setMockInitialValues({
    'auth_token': 'test-token',
    'auth_user': jsonEncode(_user(language: 'th')),
  });

  apiClient = ApiClient(
    client: MockClient((request) async {
      if (request.method == 'PATCH') {
        patchBodies.add(request.body);
        // The API answers a settings PATCH with the updated user.
        final sent = jsonDecode(request.body) as Map<String, dynamic>;
        final settings = sent['settings'] as Map<String, dynamic>;
        return http.Response(
          jsonEncode(_user(
            language: settings['language'] as String? ?? 'th',
            largeText: settings['large_text'] as bool? ?? true,
          )),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('{}', 200);
    }),
  );

  localeController = LocaleController(const Locale('en'));
  settingsController = SettingsController();
  authController = AuthController();
  await localeController.load();
  await settingsController.load();
  await authController.load();
}

/// Restarts the app against whatever is on disk, like reloading the browser.
Future<void> _reload() async {
  localeController = LocaleController(const Locale('en'));
  settingsController = SettingsController();
  authController = AuthController();
  await localeController.load();
  await settingsController.load();
  await authController.load();
}

void main() {
  test('a language switch survives a reload', () async {
    final patches = <String>[];
    await _signInAsThaiAccount(patchBodies: patches);
    expect(localeController.value.languageCode, 'th',
        reason: 'the account starts in Thai');

    await localeController.setLocale(const Locale('en'));
    expect(localeController.value.languageCode, 'en');
    expect(patches, hasLength(1), reason: 'the change syncs to the backend');

    await _reload();
    expect(localeController.value.languageCode, 'en',
        reason: 'reloading must not restore the old language');
  });

  test('a Large Text switch survives a reload', () async {
    final patches = <String>[];
    await _signInAsThaiAccount(patchBodies: patches);
    expect(settingsController.largeText, isTrue);

    await settingsController.setLargeText(false);
    await _reload();
    expect(settingsController.largeText, isFalse);
  });

  test('the account language still applies on a fresh sign-in', () async {
    final patches = <String>[];
    await _signInAsThaiAccount(patchBodies: patches);

    expect(localeController.value.languageCode, 'th');
    expect(patches, isEmpty, reason: 'restoring a session syncs nothing back');
  });
}
