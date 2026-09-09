// Smoke tests: live EN→TH switching, and the post-login chat bubble opening
// the chat overlay.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarco_care/chat/chat_controller.dart';
import 'package:sarco_care/l10n/locale_controller.dart';
import 'package:sarco_care/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localeController = LocaleController(const Locale('en'));
    chatController.onLogout(); // reset global state between tests
  });

  testWidgets('splash toggle switches EN → TH live', (tester) async {
    await tester.pumpWidget(const SarcoCareApp());
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('ไทย'));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsNothing);
    expect(find.text('เริ่มต้นใช้งาน'), findsOneWidget);
  });

  testWidgets('chat bubble appears after login and opens the chat',
      (tester) async {
    await tester.pumpWidget(const SarcoCareApp());
    await tester.pumpAndSettle();

    // No bubble before login.
    expect(find.byIcon(Icons.chat_bubble_rounded), findsNothing);

    // Splash → Login → Log In (patient).
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    // Bubble now floats over the app.
    expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);

    // Tapping it opens the chat with the assistant greeting.
    await tester.tap(find.byIcon(Icons.chat_bubble_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Assistant'), findsOneWidget);
    expect(
      find.textContaining('SarcoCare assistant'),
      findsOneWidget,
    );
  });
}
