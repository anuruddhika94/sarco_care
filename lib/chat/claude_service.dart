import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to Claude through your Cloudflare Worker proxy.
///
/// The app never holds the Anthropic key — the Worker adds it server-side. The
/// app only knows the proxy URL and a shared token, both supplied at build time:
///
///   flutter run --dart-define=PROXY_URL=`https://<worker>.workers.dev` \
///               --dart-define=PROXY_TOKEN=`<your shared token>`
///
/// When [isConfigured] is false (no PROXY_URL), the chat falls back to a canned
/// placeholder reply so the UI still works without a backend. The Worker holds
/// the real key, sets CORS, and adds the `anthropic-version` / `x-api-key`
/// headers, so this client sends neither — which is why it works on web too.
class ClaudeService {
  ClaudeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _proxyUrl = String.fromEnvironment('PROXY_URL');
  static const _proxyToken = String.fromEnvironment('PROXY_TOKEN');
  static const _model = 'claude-haiku-4-5';
  static const _maxTokens = 1024;

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
  /// 'content': ...}` maps, starting with a user turn.
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
        'max_tokens': _maxTokens,
        'system': _systemPrompt(languageCode),
        'stream': true,
        'messages': messages,
      });

    final response = await _client.send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw ClaudeException('HTTP ${response.statusCode}: $body');
    }

    // Parse the Server-Sent Events stream, yielding text deltas as they arrive.
    final lines =
        response.stream.transform(utf8.decoder).transform(const LineSplitter());
    await for (final line in lines) {
      if (!line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data.isEmpty) continue;

      final event = jsonDecode(data) as Map<String, dynamic>;
      switch (event['type']) {
        case 'content_block_delta':
          final delta = event['delta'] as Map<String, dynamic>?;
          if (delta != null && delta['type'] == 'text_delta') {
            yield delta['text'] as String;
          }
        case 'error':
          final error = event['error'] as Map<String, dynamic>?;
          throw ClaudeException(
              error?['message']?.toString() ?? 'stream error');
        // message_start / content_block_start/stop / message_delta /
        // message_stop carry no text — ignore; the stream ends on its own.
      }
    }
  }

  void dispose() => _client.close();
}

class ClaudeException implements Exception {
  ClaudeException(this.message);
  final String message;

  @override
  String toString() => 'ClaudeException: $message';
}
