// A caretaker reaches Profile from their home screen's app bar, so it must
// have a way back.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/api/api_client.dart';
import 'package:sarco_care/auth/auth_controller.dart';
import 'package:sarco_care/l10n/app_localizations.dart';
import 'package:sarco_care/screens/caretaker_home_screen.dart';
import 'package:sarco_care/screens/profile_screen.dart';
import 'package:sarco_care/settings/settings_controller.dart';
import 'package:sarco_care/widgets/app_avatar.dart';

void main() {
  testWidgets('caretaker can get back from Profile to their home screen',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'auth_token': 'test-token',
      'auth_user': jsonEncode({
        'id': 2,
        'full_name': 'Malee Jai-Dee',
        'phone_number': '0812345679',
        'role': 'caretaker',
        'settings': {},
      }),
    });
    settingsController = SettingsController();
    authController = AuthController();
    apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    await authController.load();

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CaretakerHomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // The app bar's avatar button opens Profile.
    await tester.tap(find.byType(AppAvatar).first);
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);

    // There's a back button, and it returns to the caretaker home.
    expect(find.byType(BackButton), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(CaretakerHomeScreen), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);
  });
}
