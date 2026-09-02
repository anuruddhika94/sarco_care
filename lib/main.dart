import 'package:flutter/material.dart';

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
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
