import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../auth/auth_controller.dart';
import '../chat/chat_controller.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';
import 'add_patient_screen.dart';
import 'assessment_screen.dart';
import 'exercise_plan_screen.dart';
import 'health_tracking_screen.dart';
import 'meals_screen.dart';
import 'splash_screen.dart';

/// Caretaker home — the caretaker's landing screen after logging in.
/// A patient switcher (one caretaker → many patients), loaded from
/// `GET /care_links?status=approved`, and quick access into the selected
/// patient's care screens (each scoped to that patient via `?patient_id=`).
class CaretakerHomeScreen extends StatefulWidget {
  const CaretakerHomeScreen({super.key});

  @override
  State<CaretakerHomeScreen> createState() => _CaretakerHomeScreenState();
}

class _CaretakerHomeScreenState extends State<CaretakerHomeScreen> {
  List<Map<String, dynamic>>? _patients;
  String? _error;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final links = await apiClient.get('/care_links', query: {'status': 'approved'});
      if (!mounted) return;
      setState(() {
        _patients = (links as List)
            .map((l) => (l as Map<String, dynamic>)['patient'] as Map<String, dynamic>)
            .toList();
        if (_selected >= _patients!.length) _selected = 0;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  Future<void> _logOut() async {
    await authController.logout();
    chatController.onLogout();
    if (!mounted) return;
    // Reset the whole stack to Splash — popUntil(isFirst) isn't enough since
    // a restored session can start directly at CaretakerHomeScreen with
    // nothing to pop to.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  Future<void> _switchPatient() async {
    final patients = _patients;
    if (patients == null) return;
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PatientPicker(patients: patients, selected: _selected),
    );
    if (picked != null) setState(() => _selected = picked);
  }

  void _open(WidgetBuilder builder) {
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  Future<void> _openAddPatient() async {
    final sent = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddPatientScreen()),
    );
    // A new request is pending approval, not approved yet, so the list
    // itself doesn't change — nothing to reload.
    if (sent == true) return;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }
    final patients = _patients;
    if (patients == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final addPatientButton = SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _openAddPatient,
        icon: const Icon(Icons.person_add_alt),
        label: Text(l10n.addPatient),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    if (patients.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            l10n.helloCaretaker(l10n.caretakerFirstName),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noPatientsYet,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 24),
          addPatientButton,
        ],
      );
    }

    final patient = patients[_selected];
    final fullName = patient['full_name'] as String;
    final firstName = fullName.split(' ').first;
    final patientId = patient['id'] as int;

    return ListView(
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
          l10n.caringForPatients(patients.length),
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
              icon: Icons.monitor_heart,
              color: const Color(0xFFB0524B),
              onTap: () => _open((_) => HealthTrackingScreen(patientId: patientId)),
            ),
            _CareTile(
              title: l10n.navExercise,
              icon: Icons.sports_gymnastics,
              color: const Color(0xFF3E7CB1),
              onTap: () => _open((_) => const ExercisePlanScreen()),
            ),
            _CareTile(
              title: l10n.careTileMeals,
              icon: Icons.ramen_dining,
              color: const Color(0xFF3B8B5F),
              onTap: () => _open((_) => const MealsScreen()),
            ),
            _CareTile(
              title: l10n.careTileSarcf,
              icon: Icons.fact_check,
              color: const Color(0xFFCB8A2E),
              onTap: () => _open((_) => AssessmentScreen(patientId: patientId)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        addPatientButton,
      ],
    );
  }
}

/// The current-patient card that opens the switcher sheet.
class _PatientSwitcher extends StatelessWidget {
  const _PatientSwitcher({required this.patient, required this.onTap});
  final Map<String, dynamic> patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final age = patient['age'] as int?;
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
                asset: patient['avatar_url'] as String?,
                fallbackIcon: Icons.elderly,
                size: 56,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['full_name'] as String,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.ageLabel(age),
                        style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                      ),
                    ],
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
  final List<Map<String, dynamic>> patients;
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
                  asset: patients[i]['avatar_url'] as String?,
                  fallbackIcon: Icons.elderly,
                  size: 44,
                ),
                title: Text(
                  patients[i]['full_name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: patients[i]['age'] != null ? Text(l10n.ageLabel(patients[i]['age'] as int)) : null,
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
