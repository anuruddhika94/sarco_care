import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_field.dart';
import '../widgets/segmented_tabs.dart';
import 'caretaker_home_screen.dart';
import 'main_shell.dart';

/// Sign Up — create an account with phone number + password.
/// Pure UI: role picker, name/phone/password/confirm fields; Create Account
/// routes to the patient shell or caretaker home by role. No backend/validation.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.initialRole = 0});

  /// 0 = Patient, 1 = Caretaker — carried over from the login role picker.
  final int initialRole;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late int _role = widget.initialRole;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _isPatient => _role == 0;

  void _createAccount() {
    final WidgetBuilder builder = _isPatient
        ? (_) => const MainShell()
        : (_) => const CaretakerHomeScreen();
    // Replace so Back doesn't return to the sign-up form after account creation.
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 28),
              SegmentedTabs(
                labels: [l10n.rolePatient, l10n.roleCaretaker],
                selected: _role,
                onChanged: (i) => setState(() => _role = i),
              ),
              const SizedBox(height: 28),
              AuthFieldLabel(l10n.fullName),
              const SizedBox(height: 8),
              TextField(
                textCapitalization: TextCapitalization.words,
                decoration: authFieldDecoration(l10n.fullNameHint),
              ),
              const SizedBox(height: 20),
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
                decoration: authFieldDecoration(l10n.createPasswordHint).copyWith(
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
              const SizedBox(height: 20),
              AuthFieldLabel(l10n.confirmPassword),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureConfirm,
                decoration: authFieldDecoration(l10n.confirmPasswordHint).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text(l10n.createAccount),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.haveAccountQuestion,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.logIn,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
          l10n.signupTitle,
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
              l10n.signupJoinPrefix,
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
