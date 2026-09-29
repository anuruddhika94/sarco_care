// The app is laid out for phones. On a tablet it sits in a centred
// phone-width column (see PageWidth) rather than stretching, so screens stay
// readable and Home still fits without scrolling.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/api/api_client.dart';
import 'package:sarco_care/auth/auth_controller.dart';
import 'package:sarco_care/l10n/app_localizations.dart';
import 'package:sarco_care/screens/home_screen.dart';
import 'package:sarco_care/screens/profile_screen.dart';
import 'package:sarco_care/screens/splash_screen.dart';
import 'package:sarco_care/settings/settings_controller.dart';
import 'package:sarco_care/widgets/feature_tile.dart';
import 'package:sarco_care/widgets/page_width.dart';

/// Tablet viewports, portrait.
const _tablets = <String, Size>{
  'iPad mini': Size(744, 1133),
  'iPad 10.9"': Size(820, 1180),
  'iPad Pro 12.9"': Size(1024, 1366),
  'Android tablet': Size(800, 1280),
};

Future<void> _pump(WidgetTester tester, Size size, Widget screen) async {
  SharedPreferences.setMockInitialValues({
    'auth_token': 'test-token',
    'auth_user': jsonEncode({
      'id': 1,
      'full_name': 'Somchai Jai-Dee',
      'phone_number': '0812345678',
      'role': 'patient',
      'settings': {},
    }),
  });
  settingsController = SettingsController();
  authController = AuthController();
  apiClient = ApiClient(
    client: MockClient((_) async => http.Response('[]', 200)),
  );
  await authController.load();

  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: const TextScaler.linear(1.2),
      ),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PageWidth(child: screen),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  for (final entry in _tablets.entries) {
    final size = entry.value;

    testWidgets('home is a readable column on ${entry.key}', (tester) async {
      await _pump(tester, size, const HomeScreen());

      expect(tester.takeException(), isNull);
      // Held to the phone-like column rather than stretched edge to edge.
      final body = tester.getRect(find.byType(HomeScreen));
      expect(body.width, lessThanOrEqualTo(PageWidth.maxWidth));
      // And centred, not pinned to one side.
      expect(
        (body.center.dx - size.width / 2).abs(),
        lessThan(1),
        reason: 'the column should be centred on a tablet',
      );
      // Still one screen, no scrolling.
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.byType(FeatureTile), findsNWidgets(4));
    });

    testWidgets('profile fits on ${entry.key}', (tester) async {
      await _pump(tester, size, const ProfileScreen());

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('splash artwork is not cropped on ${entry.key}',
        (tester) async {
      await _pump(tester, size, const SplashScreen());
      expect(tester.takeException(), isNull);

      // The illustration is square: it must stay square rather than being
      // squashed into a wide letterbox, which is what cropped it on iPad.
      final image = tester.widgetList<AspectRatio>(find.byType(AspectRatio));
      expect(image, isNotEmpty);
      final box = tester.getRect(find.byType(AspectRatio).first);
      expect(
        (box.width - box.height).abs(),
        lessThan(2),
        reason: 'the splash artwork should keep its 1:1 shape',
      );
    });
  }
}
