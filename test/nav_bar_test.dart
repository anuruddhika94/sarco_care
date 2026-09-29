// The bottom bar's icons must not move when a tab is selected, and the
// selection badge must be a circle rather than a wide pill.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/api/api_client.dart';
import 'package:sarco_care/auth/auth_controller.dart';
import 'package:sarco_care/l10n/app_localizations.dart';
import 'package:sarco_care/screens/main_shell.dart';
import 'package:sarco_care/screens/profile_screen.dart';
import 'package:sarco_care/settings/settings_controller.dart';

Future<void> _pumpShell(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  settingsController = SettingsController();
  authController = AuthController();
  apiClient = ApiClient(
    client: MockClient((_) async => http.Response('[]', 200)),
  );

  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MainShell(),
    ),
  );
  await tester.pump();
}

/// The rects of the five nav icons, left to right.
List<Rect> _iconRects(WidgetTester tester) =>
    tester.widgetList<ImageIcon>(find.byType(ImageIcon)).toList().asMap().keys
        .map((i) => tester.getRect(find.byType(ImageIcon).at(i)))
        .toList();

void main() {
  testWidgets('every tab icon has the same box, selected or not',
      (tester) async {
    await _pumpShell(tester);

    final rects = _iconRects(tester);
    expect(rects, hasLength(5));
    for (final rect in rects) {
      expect(rect.size, rects.first.size,
          reason: 'the selected icon must not be a different size');
      expect(rect.top, rects.first.top,
          reason: 'the selected icon must not sit higher than the others');
    }
  });

  testWidgets('icons stay put when another tab is selected', (tester) async {
    await _pumpShell(tester);
    final before = _iconRects(tester);

    // Select the Exercise tab (the widest icon, where a jump showed most).
    await tester.tap(find.byType(ImageIcon).at(1));
    await tester.pumpAndSettle();

    expect(_iconRects(tester), before);
  });

  _profileBackButtonTests();

  testWidgets('the selection badge is a circle', (tester) async {
    await _pumpShell(tester);

    final badges = tester
        .widgetList<Container>(find.byType(Container))
        .where((c) => c.decoration is BoxDecoration &&
            (c.decoration! as BoxDecoration).shape == BoxShape.circle)
        .toList();
    expect(badges, isNotEmpty, reason: 'the badge should be a circle');

    // It is as tall as it is wide — a pill would not be.
    final badge = find.ancestor(
      of: find.byType(ImageIcon).first,
      matching: find.byType(Container),
    );
    final box = tester.getRect(badge.first);
    expect(box.width, box.height);
  });
}

/// The profile screen is a tab for patients (nothing to pop) but a pushed
/// route for caretakers, so its back button has to appear only when there is
/// somewhere to go.
void _profileBackButtonTests() {
  Widget wrap(Widget home) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );

  testWidgets('no back button when profile is the root (patient tab)',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    settingsController = SettingsController();
    authController = AuthController();
    apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );

    await tester.pumpWidget(wrap(const ProfileScreen()));
    await tester.pump();

    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('back button when profile is pushed (caretaker)',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    settingsController = SettingsController();
    authController = AuthController();
    apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );

    await tester.pumpWidget(wrap(
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
  });
}
