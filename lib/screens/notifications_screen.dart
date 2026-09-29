import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/screen_states.dart';

/// Notifications / Set Reminders.
///
/// Backed by `GET /reminders` and `PATCH /reminders/:id`. A caretaker opens
/// this for one of their patients by passing [patientId], which the API
/// checks against an approved care link.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.patientId, this.patientName});

  /// Null when a patient is managing their own reminders.
  final int? patientId;
  final String? patientName;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _iconsByKind = {
    'breakfast': Icons.free_breakfast_outlined,
    'lunch': Icons.lunch_dining_outlined,
    'dinner': Icons.dinner_dining_outlined,
    'water': Icons.water_drop_outlined,
    'exercise': Icons.fitness_center,
    'medication': Icons.medication_outlined,
    'sleep': Icons.bedtime_outlined,
    'snack': Icons.bakery_dining_outlined,
  };

  List<Map<String, dynamic>>? _reminders;
  String? _error;

  Map<String, String>? get _patientQuery =>
      widget.patientId == null ? null : {'patient_id': '${widget.patientId}'};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await apiClient.get('/reminders', query: _patientQuery);
      if (!mounted) return;
      setState(() => _reminders = (data as List).cast<Map<String, dynamic>>());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  Future<void> _toggle(Map<String, dynamic> reminder, bool value) async {
    final previous = reminder['enabled'] as bool;
    // Flip straight away: a switch that waits for the network feels broken.
    setState(() => reminder['enabled'] = value);
    try {
      await apiClient.patch(
        '/reminders/${reminder['id']}',
        body: {'enabled': value, if (_patientQuery != null) ...?_patientQuery},
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => reminder['enabled'] = previous);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  String _label(AppLocalizations l10n, String kind) => switch (kind) {
    'breakfast' => l10n.mealBreakfast,
    'lunch' => l10n.mealLunch,
    'dinner' => l10n.mealDinner,
    'water' => l10n.reminderWater,
    'exercise' => l10n.navExercise,
    'medication' => l10n.reminderMedication,
    'sleep' => l10n.reminderSleep,
    _ => l10n.mealSnack,
  };

  /// "07:00" as stored becomes "7:00 AM"; a reminder with no set time (water)
  /// shows its own wording instead.
  String _time(AppLocalizations l10n, Map<String, dynamic> reminder) {
    final raw = reminder['time_of_day'] as String?;
    if (raw == null || raw.isEmpty) return l10n.reminderEvery2Hours;
    final parts = raw.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
    final suffix = hour < 12 ? 'AM' : 'PM';
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.patientName ?? l10n.setReminders,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _body(l10n),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_error != null) return ErrorStateView(message: _error!, onRetry: _load);
    final reminders = _reminders;
    if (reminders == null) return const LoadingList(itemHeight: 68);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          widget.patientName == null
              ? l10n.turnRemindersOnOff
              : l10n.remindersForPatient(widget.patientName!),
          style: TextStyle(fontSize: 15, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),
        for (final reminder in reminders)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReminderRow(
              icon: _iconsByKind[reminder['kind']] ?? Icons.notifications_none,
              label: _label(l10n, reminder['kind'] as String),
              time: _time(l10n, reminder),
              value: reminder['enabled'] as bool,
              onChanged: (v) => _toggle(reminder, v),
            ),
          ),
      ],
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.icon,
    required this.label,
    required this.time,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String time;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
