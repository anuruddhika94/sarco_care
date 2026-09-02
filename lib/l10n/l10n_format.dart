import 'app_localizations.dart';

/// Format a duration in whole minutes as a localized label, e.g. "12 min" or
/// "3h 20m" (and their Thai equivalents). Used by the exercise/plan screens
/// whose data is stored as minutes so it can be translated consistently.
String formatDuration(AppLocalizations l10n, int minutes) {
  if (minutes >= 60) {
    return l10n.durationHoursMinutes(minutes ~/ 60, minutes % 60);
  }
  return l10n.durationMinutes(minutes);
}
