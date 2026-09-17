import 'dart:convert';

import 'package:http/http.dart' as http;

/// Thin JSON client for the SarcoCare Rails API.
///
/// The base URL points at a local `rails server` by default — the iOS
/// Simulator and Flutter web share the host's network, so `localhost` reaches
/// a Mac-side Rails process directly. Override for other setups (an Android
/// emulator needs `10.0.2.2`, a real device needs the host's LAN IP) with:
///
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  /// The bearer token attached to every request once signed in. Set by
  /// [AuthController] after login/signup and on app start once restored.
  String? authToken;

  Future<dynamic> get(String path, {Map<String, String>? query}) {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    return _send(() => _client.get(uri, headers: _headers));
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    final uri = Uri.parse('$_baseUrl$path');
    return _send(
      () => _client.post(uri, headers: _headers, body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) {
    final uri = Uri.parse('$_baseUrl$path');
    return _send(
      () => _client.patch(uri, headers: _headers, body: jsonEncode(body ?? {})),
    );
  }

  /// Multipart upload (e.g. `PATCH /me` with an `avatar` file field).
  Future<dynamic> uploadFile(
    String path, {
    required String method,
    required String fieldName,
    required List<int> bytes,
    required String filename,
  }) {
    final uri = Uri.parse('$_baseUrl$path');
    return _send(() async {
      final request = http.MultipartRequest(method, uri)
        ..headers.addAll({
          'Accept': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        })
        ..files.add(
          http.MultipartFile.fromBytes(fieldName, bytes, filename: filename),
        );
      final streamed = await _client.send(request);
      return http.Response.fromStream(streamed);
    });
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    late final http.Response response;
    try {
      response = await request();
    } on Exception catch (e) {
      throw ApiException(
        "Couldn't reach the server. Check that the Rails API is running and "
        'reachable at $_baseUrl.\n($e)',
      );
    }

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = decoded is Map && decoded['error'] != null
        ? decoded['error'].toString()
        : 'Request failed (${response.statusCode})';
    throw ApiException(
      message,
      statusCode: response.statusCode,
      errors: decoded is Map ? decoded['errors'] : null,
    );
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.errors});

  final String message;
  final int? statusCode;
  final dynamic errors;

  @override
  String toString() => message;
}

/// The global API client, created in `main()`.
late ApiClient apiClient;
