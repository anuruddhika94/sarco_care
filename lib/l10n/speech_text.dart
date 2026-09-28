/// Prepares article text for the text-to-speech engine used by
/// [ArticleDetailScreen]'s "Read aloud" button.
///
/// Engines read a whole article far more naturally when it arrives as one
/// utterance per paragraph (they pause between utterances, but run straight
/// through a single joined string), so this returns a list rather than one
/// blob. It also cleans up the few things Thai and English voices stumble on.
List<String> speechUtterances({
  required String title,
  required List<String> paragraphs,
  required bool isThai,
}) {
  return [title, ...paragraphs]
      .map((t) => _cleanForSpeech(t, isThai: isThai))
      .where((t) => t.isNotEmpty)
      .toList();
}

/// Latin-script asides such as the "(Sarcopenia)" in the Thai articles: a Thai
/// voice either spells them out letter by letter or mispronounces them, and the
/// Thai term right before them already says the same thing.
final _latinParenthetical = RegExp(r'\s*\(\s*[A-Za-z][A-Za-z0-9 .\-/]*\)');

/// A space before the Thai repetition mark ("เล็ก ๆ"). Written that way for
/// readability, but engines read the mark as a separate word when it stands
/// alone, so it is joined back onto the word it repeats before speaking.
final _spaceBeforeRepetition = RegExp(r'\s+ๆ');

/// Dashes and middle dots, which voices either skip or read out as a word
/// instead of pausing.
final _pauseMarks = RegExp(r'\s*[—–·]\s*');

final _repeatedWhitespace = RegExp(r'\s+');

String _cleanForSpeech(String text, {required bool isThai}) {
  var out = text;
  if (isThai) {
    out = out
        .replaceAll(_latinParenthetical, '')
        .replaceAll(_spaceBeforeRepetition, 'ๆ');
  }
  return out
      .replaceAll(_pauseMarks, ', ')
      .replaceAll(_repeatedWhitespace, ' ')
      .trim();
}

/// Picks the best-sounding installed voice for [locale] from what
/// `FlutterTts.getVoices` reports, or null to leave the engine's default.
///
/// Engines often default to a low-quality voice even when a better one is
/// installed, which is most of what makes read-aloud sound robotic. Both
/// platforms report a `quality`: iOS as premium/enhanced/default, Android as
/// very high/high/normal/low/very low.
Map<String, String>? preferredVoice(List<dynamic> voices, String locale) {
  final language = locale.split('-').first.toLowerCase();

  final candidates = voices
      .whereType<Map>()
      .map((v) => v.map((k, value) => MapEntry('$k', '$value')))
      .where((v) => (v['locale'] ?? '').toLowerCase().startsWith(language))
      .toList();
  if (candidates.isEmpty) return null;

  candidates.sort((a, b) {
    final byQuality = _qualityRank(b['quality']).compareTo(_qualityRank(a['quality']));
    if (byQuality != 0) return byQuality;
    // Same quality: prefer an exact locale match, then one that works offline.
    final byLocale = _localeRank(b['locale'], locale).compareTo(_localeRank(a['locale'], locale));
    if (byLocale != 0) return byLocale;
    return _offlineRank(b).compareTo(_offlineRank(a));
  });

  final best = candidates.first;
  final name = best['name'];
  final voiceLocale = best['locale'];
  if (name == null || voiceLocale == null) return null;
  return {'name': name, 'locale': voiceLocale};
}

int _qualityRank(String? quality) => switch (quality?.toLowerCase()) {
  'premium' || 'very high' => 4,
  'enhanced' || 'high' => 3,
  'default' || 'normal' => 2,
  'low' => 1,
  _ => 0,
};

int _localeRank(String? voiceLocale, String locale) =>
    (voiceLocale ?? '').toLowerCase() == locale.toLowerCase() ? 1 : 0;

int _offlineRank(Map<String, String> voice) =>
    voice['network_required'] == '1' ? 0 : 1;
