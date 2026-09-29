import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';

/// Schedules the patient's reminders as real phone notifications.
///
/// These are *local* notifications: the phone itself holds the schedule and
/// fires them at the right time, so they arrive with the screen off, in
/// flight mode, and with the app closed. They're scheduled to repeat daily,
/// and re-scheduled whenever the reminder list changes.
class ReminderNotifications {
  ReminderNotifications._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  /// Reminder kinds in a fixed order — the index becomes the notification id,
  /// so re-scheduling replaces the previous one rather than piling up.
  static const kinds = [
    'breakfast',
    'lunch',
    'dinner',
    'water',
    'exercise',
    'medication',
    'sleep',
    'snack',
  ];

  /// Water has no single time; these are the hours it nags at instead.
  static const _waterHours = [9, 11, 13, 15, 17, 19];

  static const _channel = AndroidNotificationChannel(
    'sarco_reminders',
    'Reminders',
    description: 'Meal, water, exercise, medication and sleep reminders',
    importance: Importance.high,
  );

  /// Called once on app start, before anything is scheduled.
  static Future<void> init() async {
    if (_ready) return;

    tz_data.initializeTimeZones();
    // Without the device's own zone, a 7am reminder would fire at 7am UTC.
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    _ready = true;
  }

  /// Asks for permission to post notifications. Android 13+ and iOS both
  /// require this; older Androids grant it at install time.
  static Future<bool> requestPermission() async {
    await init();

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  /// Re-reads the patient's reminders from the API and rebuilds the schedule.
  /// Safe to call often: it clears everything first, so it can't double-book.
  static Future<void> sync(AppLocalizations l10n) async {
    await init();
    try {
      final data = await apiClient.get('/reminders');
      if (data is! List) return;
      await scheduleAll(data.cast<Map<String, dynamic>>(), l10n);
    } on ApiException {
      // Leave whatever is already scheduled in place; the phone keeps firing
      // yesterday's schedule, which is better than silence.
    }
  }

  static Future<void> scheduleAll(
    List<Map<String, dynamic>> reminders,
    AppLocalizations l10n,
  ) async {
    await init();
    await _plugin.cancelAll();

    for (final reminder in reminders) {
      if (reminder['enabled'] != true) continue;
      final kind = reminder['kind'] as String;
      final index = kinds.indexOf(kind);
      if (index < 0) continue;

      final title = _title(l10n, kind);
      final body = _body(l10n, kind);

      if (kind == 'water') {
        for (var i = 0; i < _waterHours.length; i++) {
          await _scheduleDaily(
            id: 900 + i,
            hour: _waterHours[i],
            minute: 0,
            title: title,
            body: body,
          );
        }
        continue;
      }

      final time = _parseTime(reminder['time_of_day'] as String?);
      if (time == null) continue;
      await _scheduleDaily(
        id: index,
        hour: time.hour,
        minute: time.minute,
        title: title,
        body: body,
      );
    }
  }

  static Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  static Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Today at that time if it hasn't passed, otherwise tomorrow.
  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static TimeOfDay? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(':');
    final hour = int.tryParse(parts.first);
    if (hour == null) return null;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _title(AppLocalizations l10n, String kind) => switch (kind) {
    'breakfast' => l10n.mealBreakfast,
    'lunch' => l10n.mealLunch,
    'dinner' => l10n.mealDinner,
    'water' => l10n.reminderWater,
    'exercise' => l10n.navExercise,
    'medication' => l10n.reminderMedication,
    'sleep' => l10n.reminderSleep,
    _ => l10n.mealSnack,
  };

  static String _body(AppLocalizations l10n, String kind) => switch (kind) {
    'water' => l10n.reminderBodyWater,
    'exercise' => l10n.reminderBodyExercise,
    'medication' => l10n.reminderBodyMedication,
    'sleep' => l10n.reminderBodySleep,
    _ => l10n.reminderBodyMeal,
  };
}
