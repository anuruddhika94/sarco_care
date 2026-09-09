import 'package:flutter/material.dart';

import '../chat/chat_controller.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_field.dart';
import '../widgets/segmented_tabs.dart';
import 'caretaker_home_screen.dart';
import 'main_shell.dart';
import 'signup_screen.dart';

/// Screen #2 — Login.
/// Pure UI: a Patient/Caretaker role picker, username/phone + password fields,
/// a primary "Log In" action and a patient-only guest entry. No auth logic;
/// login routes to the patient app shell or the caretaker home by role.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  int _role = 0; // 0 = Patient, 1 = Caretaker

  bool get _isPatient => _role == 0;

  void _login() {
    final WidgetBuilder builder = _isPatient
        ? (_) => const MainShell()
        : (_) => const CaretakerHomeScreen();
    chatController.onLogin();
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  void _openSignUp() {
    // Carry the chosen role into the sign-up form.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignUpScreen(initialRole: _role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const _Header(),
              const SizedBox(height: 32),
              SegmentedTabs(
                labels: [l10n.rolePatient, l10n.roleCaretaker],
                selected: _role,
                onChanged: (i) => setState(() => _role = i),
              ),
              const SizedBox(height: 32),
              AuthFieldLabel(l10n.phoneNumber),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: authFieldDecoration(l10n.phoneNumberHint),
              ),
              const SizedBox(height: 20),
              AuthFieldLabel(l10n.password),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscurePassword,
                decoration: authFieldDecoration(l10n.passwordHint).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                child: Text(l10n.logIn),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noAccountQuestion,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: _openSignUp,
                    child: Text(
                      l10n.signUp,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n.loginWelcome,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.loginIntoPrefix,
              style: TextStyle(fontSize: 16, color: AppColors.textMuted),
            ),
            Text(
              'SarcoCare',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.eco, color: AppColors.primary, size: 18),
          ],
        ),
      ],
    );
  }
}
