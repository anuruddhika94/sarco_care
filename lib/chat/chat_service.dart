import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the chat model through your Cloudflare Worker proxy.
///
/// The Worker holds the provider API key (Gemini) and translates the request to
/// the provider's format, then streams back a simple normalized SSE of
/// `{"text": "..."}` deltas — so this client stays provider-agnostic and no
/// secret ever ships in the app or repo. The proxy URL and a shared token come
/// from build-time defines:
///
///   flutter run --dart-define=PROXY_URL=`https://<worker>.workers.dev` \
///               --dart-define=PROXY_TOKEN=`<your shared token>`
///
/// When [isConfigured] is false (no PROXY_URL), the chat falls back to a canned
/// placeholder reply so the UI still works without a backend.
class ChatService {
  ChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _proxyUrl = String.fromEnvironment('PROXY_URL');
  static const _proxyToken = String.fromEnvironment('PROXY_TOKEN');
  static const _model = 'gemini-3.6-flash';

  bool get isConfigured => _proxyUrl.isNotEmpty;

  String _systemPrompt(String languageCode) {
    final language = languageCode == 'th' ? 'Thai' : 'English';
    return 'You are the SarcoCare assistant, a warm, encouraging health '
        'companion for older adults and their caretakers. You give clear, '
        'practical guidance about sarcopenia (age-related muscle loss), safe '
        'strength and balance exercises, protein and nutrition, and healthy '
        'ageing habits. Keep answers short and easy to read: simple words, '
        'short sentences, and bullet points when helpful. You are not a doctor '
        '— never diagnose or prescribe. For symptoms, medication, or '
        'emergencies, advise contacting a healthcare professional or the '
        "user's caretaker. If asked about something unrelated to health and "
        'wellbeing, gently steer back. Always reply in $language.';
  }

  /// Streams the assistant's reply token-by-token.
  ///
  /// [messages] is the conversation so far as `{'role': 'user'|'assistant',
  /// 'content': ...}` maps, starting with a user turn. The Worker maps roles and
  /// the system prompt to the provider's schema.
  Stream<String> streamReply({
    required List<Map<String, String>> messages,
    required String languageCode,
  }) async* {
    final request = http.Request('POST', Uri.parse(_proxyUrl))
      ..headers.addAll({
        'content-type': 'application/json',
        if (_proxyToken.isNotEmpty) 'authorization': 'Bearer $_proxyToken',
      })
      ..body = jsonEncode({
        'model': _model,
        'system': _systemPrompt(languageCode),
        'messages': messages,
      });

    final response = await _client.send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw ChatException('HTTP ${response.statusCode}: $body');
    }

    // The Worker emits a normalized SSE: each `data:` line is {"text": "..."}.
    final lines =
        response.stream.transform(utf8.decoder).transform(const LineSplitter());
    await for (final line in lines) {
      if (!line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data.isEmpty) continue;

      final event = jsonDecode(data) as Map<String, dynamic>;
      final text = event['text'];
      if (text is String && text.isNotEmpty) yield text;
      final error = event['error'];
      if (error != null) throw ChatException(error.toString());
    }
  }

  void dispose() => _client.close();
}

class ChatException implements Exception {
  ChatException(this.message);
  final String message;

  @override
  String toString() => 'ChatException: $message';
}
