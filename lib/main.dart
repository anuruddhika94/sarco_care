import 'package:flutter/material.dart';

import 'chat/chat_bubble.dart';
import 'chat/chat_controller.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localeController = LocaleController(const Locale('en'));
  await localeController.load();
  runApp(const SarcoCareApp());
}

class SarcoCareApp extends StatelessWidget {
  const SarcoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole app when the language changes so every screen updates.
    return ValueListenableBuilder<Locale>(
      valueListenable: localeController,
      builder: (context, locale, _) {
        return MaterialApp(
          navigatorKey: appNavigatorKey,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Paint the floating chat bubble above the whole route stack; it
          // shows only after login (driven by chatController).
          builder: (context, child) {
            return Stack(
              children: [
                ?child,
                ListenableBuilder(
                  listenable: chatController,
                  builder: (context, _) => chatController.bubbleVisible
                      ? const ChatBubble()
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
