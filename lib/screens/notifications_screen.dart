import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Notifications / Set Reminders (#11).
/// Pure UI: a list of reminder toggles the user can switch on or off.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _icons = [
    Icons.free_breakfast_outlined,
    Icons.lunch_dining_outlined,
    Icons.dinner_dining_outlined,
    Icons.water_drop_outlined,
    Icons.fitness_center,
    Icons.medication_outlined,
    Icons.bedtime_outlined,
  ];

  // Enabled state per reminder (Exercise off by default, like the design).
  final List<bool> _enabled = [true, true, true, true, false, true, true];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.mealBreakfast,
      l10n.mealLunch,
      l10n.mealDinner,
      l10n.reminderWater,
      l10n.navExercise,
      l10n.reminderMedication,
      l10n.reminderSleep,
    ];
    final times = [
      '07:00 AM',
      '12:00 PM',
      '06:30 PM',
      l10n.reminderEvery2Hours,
      '05:00 PM',
      '09:00 AM',
      '10:00 PM',
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(
          l10n.setReminders,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.turnRemindersOnOff,
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < _icons.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReminderRow(
                icon: _icons[i],
                label: labels[i],
                time: times[i],
                value: _enabled[i],
                onChanged: (v) => setState(() => _enabled[i] = v),
              ),
            ),
        ],
      ),
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
