import 'package:flutter/material.dart';

import 'api/api_client.dart';
import 'auth/auth_controller.dart';
import 'chat/chat_bubble.dart';
import 'chat/chat_controller.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';
import 'screens/caretaker_home_screen.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'settings/settings_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localeController = LocaleController(const Locale('en'));
  await localeController.load();
  settingsController = SettingsController();
  await settingsController.load();
  apiClient = ApiClient();
  authController = AuthController();
  await authController.load();
  if (authController.isSignedIn) chatController.onLogin();
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
            // Scale all text app-wide from the Large Text setting.
            return ListenableBuilder(
              listenable: settingsController,
              builder: (context, _) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: settingsController.textScaler),
                  child: Stack(
                    children: [
                      ?child,
                      ListenableBuilder(
                        listenable: chatController,
                        builder: (context, _) => chatController.bubbleVisible
                            ? const ChatBubble()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          // Restore a saved session straight into the right shell; otherwise
          // start at the splash/onboarding flow.
          home: switch (authController.currentUser?.isPatient) {
            true => const MainShell(),
            false => const CaretakerHomeScreen(),
            null => const SplashScreen(),
          },
        );
      },
    );
  }
}
