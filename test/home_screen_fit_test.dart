// Home must fit on screen without scrolling — on small phones and in a mobile
// browser, where the viewport is shorter than the device screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/api/api_client.dart';
import 'package:sarco_care/auth/auth_controller.dart';
import 'package:sarco_care/l10n/app_localizations.dart';
import 'package:sarco_care/screens/home_screen.dart';
import 'package:sarco_care/settings/settings_controller.dart';
import 'package:sarco_care/widgets/feature_tile.dart';

/// Viewport heights Home has to cope with, in logical pixels.
const _sizes = <String, Size>{
  'iPhone SE': Size(320, 568),
  'small Android': Size(360, 640),
  'iPhone 14': Size(390, 844),
  'mobile browser (address bar showing)': Size(390, 664),
  'tall Android': Size(412, 915),
};

Future<void> _pumpHome(
  WidgetTester tester,
  Size size, {
  Locale locale = const Locale('en'),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      // Large Text is on by default, so test the harder case.
      data: MediaQueryData(
        size: size,
        textScaler: const TextScaler.linear(1.2),
      ),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    settingsController = SettingsController();
    authController = AuthController();
    apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );
  });

  for (final entry in _sizes.entries) {
    testWidgets('fits without scrolling on ${entry.key}', (tester) async {
      await _pumpHome(tester, entry.value);

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsNothing,
          reason: 'Home should fill the screen, not scroll');

      // All four shortcuts are on screen and big enough to tap.
      final tiles = find.byType(FeatureTile);
      expect(tiles, findsNWidgets(4));
      for (var i = 0; i < 4; i++) {
        final box = tester.getRect(tiles.at(i));
        expect(box.bottom, lessThanOrEqualTo(entry.value.height),
            reason: 'tile $i runs past the bottom of the screen');
        expect(box.height, greaterThan(64),
            reason: 'tile $i is too small to tap comfortably');
      }
    });
  }

  testWidgets('fits in Thai on the smallest phone', (tester) async {
    await _pumpHome(tester, _sizes['iPhone SE']!, locale: const Locale('th'));

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(FeatureTile), findsNWidgets(4));
  });

  testWidgets('falls back to scrolling when the viewport is tiny',
      (tester) async {
    await _pumpHome(tester, const Size(360, 380));

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
