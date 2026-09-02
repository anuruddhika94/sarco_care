import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';
import 'add_patient_screen.dart';
import 'assessment_screen.dart';
import 'exercise_plan_screen.dart';
import 'health_tracking_screen.dart';
import 'meals_screen.dart';

/// Caretaker home — the caretaker's landing screen after logging in.
/// Pure UI: a patient switcher (one caretaker → many patients) and quick access
/// into the selected patient's care screens, plus an Add Patient entry.
class CaretakerHomeScreen extends StatefulWidget {
  const CaretakerHomeScreen({super.key});

  @override
  State<CaretakerHomeScreen> createState() => _CaretakerHomeScreenState();
}

enum PatientId { somchai, wanida, prasert }

String patientName(AppLocalizations l10n, PatientId id) => switch (id) {
      PatientId.somchai => l10n.userFullName,
      PatientId.wanida => l10n.patientWanida,
      PatientId.prasert => l10n.patientPrasert,
    };

enum RiskShort { low, moderate, high }

String riskShortLabel(AppLocalizations l10n, RiskShort risk) => switch (risk) {
      RiskShort.low => l10n.riskShortLow,
      RiskShort.moderate => l10n.riskShortModerate,
      RiskShort.high => l10n.riskShortHigh,
    };

class _CaretakerHomeScreenState extends State<CaretakerHomeScreen> {
  static const _patients = [
    _Patient(PatientId.somchai, 72, RiskShort.moderate, 'assets/images/avatars/somchai.png'),
    _Patient(PatientId.wanida, 68, RiskShort.low, null),
    _Patient(PatientId.prasert, 75, RiskShort.high, null),
  ];

  int _selected = 0;

  void _logOut() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _switchPatient() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PatientPicker(
        patients: _patients,
        selected: _selected,
      ),
    );
    if (picked != null) setState(() => _selected = picked);
  }

  void _open(WidgetBuilder builder) {
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patient = _patients[_selected];
    final firstName = patientName(l10n, patient.id).split(' ').first;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.myPatients,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logOut,
            tooltip: l10n.logOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.helloCaretaker(l10n.caretakerFirstName),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.caringForPatients(_patients.length),
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          _PatientSwitcher(patient: patient, onTap: _switchPatient),
          const SizedBox(height: 24),
          Text(
            l10n.careForName(firstName),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
            children: [
              _CareTile(
                title: l10n.careTileHealthData,
                icon: Icons.monitor_heart_outlined,
                color: const Color(0xFFB0524B),
                onTap: () => _open((_) => const HealthTrackingScreen()),
              ),
              _CareTile(
                title: l10n.navExercise,
                icon: Icons.fitness_center,
                color: const Color(0xFF3E7CB1),
                onTap: () => _open((_) => const ExercisePlanScreen()),
              ),
              _CareTile(
                title: l10n.careTileMeals,
                icon: Icons.restaurant_menu,
                color: const Color(0xFF3B8B5F),
                onTap: () => _open((_) => const MealsScreen()),
              ),
              _CareTile(
                title: l10n.careTileSarcf,
                icon: Icons.assignment_outlined,
                color: const Color(0xFFCB8A2E),
                onTap: () => _open((_) => const AssessmentScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _open((_) => const AddPatientScreen()),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.addPatient),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(56),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Patient {
  const _Patient(this.id, this.age, this.risk, this.image);
  final PatientId id;
  final int age;
  final RiskShort risk;
  final String? image;
}

/// The current-patient card that opens the switcher sheet.
class _PatientSwitcher extends StatelessWidget {
  const _PatientSwitcher({required this.patient, required this.onTap});
  final _Patient patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Row(
            children: [
              AppAvatar(
                asset: patient.image,
                fallbackIcon: Icons.elderly,
                size: 56,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName(l10n, patient.id),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.ageRiskSubtitle(
                          patient.age, riskShortLabel(l10n, patient.risk)),
                      style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    l10n.switchLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(Icons.expand_more, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom-sheet list for choosing the active patient.
class _PatientPicker extends StatelessWidget {
  const _PatientPicker({required this.patients, required this.selected});
  final List<_Patient> patients;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.switchPatient,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < patients.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AppAvatar(
                  asset: patients[i].image,
                  fallbackIcon: Icons.elderly,
                  size: 44,
                ),
                title: Text(
                  patientName(l10n, patients[i].id),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: Text(l10n.ageRiskSubtitle(
                    patients[i].age, riskShortLabel(l10n, patients[i].risk))),
                trailing: i == selected
                    ? Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _CareTile extends StatelessWidget {
  const _CareTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAEFEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
