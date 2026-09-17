import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../l10n/locale_controller.dart';
import '../settings/settings_controller.dart';
import 'app_user.dart';

/// App-wide sign-in state. Talks to the Rails API's `/api/v1/auth` endpoints
/// and keeps [apiClient] carrying the JWT for every subsequent request.
///
/// A single instance ([authController]) is created in `main()`, mirroring
/// [localeController] / [settingsController]. The token and user are
/// persisted so a restart doesn't require signing in again.
class AuthController extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  /// Restore a saved session, if any.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return;

    apiClient.authToken = token;
    _currentUser = AppUser.fromJson(
      jsonDecode(userJson) as Map<String, dynamic>,
    );
    notifyListeners();
    await _applyBackendSettings(_currentUser!.settings);
  }

  /// [role] ('patient' or 'caretaker') must match the account's actual role
  /// — the API rejects the login otherwise, so the role picker on the Login
  /// screen can't be used to sign in to the wrong kind of account.
  Future<void> login({
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    final data = await apiClient.post(
      '/auth/login',
      body: {'phone_number': phoneNumber, 'password': password, 'role': role},
    );
    await _applySession(data as Map<String, dynamic>);
  }

  Future<void> signup({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final data = await apiClient.post(
      '/auth/signup',
      body: {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      },
    );
    await _applySession(data as Map<String, dynamic>);
  }

  /// Re-fetches the current user from `GET /me` and refreshes both the
  /// in-memory and persisted copies — call after any profile edit (e.g. an
  /// avatar upload) so the rest of the app picks up the change immediately.
  Future<void> refreshUser() async {
    final data = await apiClient.get('/me') as Map<String, dynamic>;
    final user = AppUser.fromJson(data);
    _currentUser = user;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    apiClient.authToken = null;
    _currentUser = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<void> _applySession(Map<String, dynamic> data) async {
    final token = data['token'] as String;
    final user = AppUser.fromJson(data['user'] as Map<String, dynamic>);

    apiClient.authToken = token;
    _currentUser = user;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _applyBackendSettings(user.settings);
  }

  Future<void> _applyBackendSettings(Map<String, dynamic> settings) async {
    final largeText = settings['large_text'];
    if (largeText is bool) await settingsController.applyFromBackend(largeText);
    final language = settings['language'];
    if (language is String) await localeController.applyFromBackend(language);
  }
}

/// The global auth controller, created in `main()`.
late AuthController authController;
