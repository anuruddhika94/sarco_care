// Smoke test: the app builds in English and switches to Thai live when the
// global locale controller changes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/l10n/locale_controller.dart';
import 'package:sarco_care/main.dart';

void main() {
  testWidgets('splash toggle switches EN → TH live', (tester) async {
    SharedPreferences.setMockInitialValues({});
    localeController = LocaleController(const Locale('en'));

    await tester.pumpWidget(const SarcoCareApp());
    await tester.pumpAndSettle();

    // English by default.
    expect(find.text('Get Started'), findsOneWidget);

    // Tapping the splash language toggle rebuilds the app in Thai.
    await tester.tap(find.text('ไทย'));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsNothing);
    expect(find.text('เริ่มต้นใช้งาน'), findsOneWidget);
  });
}
