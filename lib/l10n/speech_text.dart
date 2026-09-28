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
