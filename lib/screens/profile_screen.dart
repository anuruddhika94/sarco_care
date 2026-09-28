import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api_client.dart';
import '../auth/auth_controller.dart';
import '../chat/chat_bubble.dart';
import '../chat/chat_controller.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_avatar.dart';
import 'caretaker_screen.dart';
import 'personal_info_screen.dart';
import 'setup_app_screen.dart';
import 'splash_screen.dart';

/// The Profile settings rows. The enum keeps navigation independent of the
/// (translated) row label.
enum ProfileEntry { personalInfo, caretaker, setupApp }

/// Profile tab — user summary, settings entries and Log Out.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _entryIcons = {
    ProfileEntry.personalInfo: Icons.person_outline,
    ProfileEntry.caretaker: Icons.people_alt_outlined,
    ProfileEntry.setupApp: Icons.settings_outlined,
  };

  String _label(AppLocalizations l10n, ProfileEntry entry) => switch (entry) {
    ProfileEntry.personalInfo => l10n.entryPersonalInfo,
    ProfileEntry.caretaker => l10n.entryCaretaker,
    ProfileEntry.setupApp => l10n.entrySetupApp,
  };

  void _open(BuildContext context, ProfileEntry entry) {
    final WidgetBuilder builder = switch (entry) {
      ProfileEntry.personalInfo => (_) => const PersonalInfoScreen(),
      ProfileEntry.caretaker => (_) => const CaretakerScreen(),
      ProfileEntry.setupApp => (_) => const SetupAppScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  Future<void> _logOut(BuildContext context) async {
    await authController.logout();
    chatController.onLogout();
    if (!context.mounted) return;
    // Reset the whole stack to Splash — popUntil(isFirst) isn't enough since
    // a restored session can start directly at MainShell with nothing to pop to.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  bool _uploadingPhoto = false;

  Future<void> _changePhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploadingPhoto = true);
    try {
      final bytes = await picked.readAsBytes();
      await apiClient.uploadFile(
        '/me',
        method: 'PATCH',
        fieldName: 'avatar',
        bytes: bytes,
        filename: picked.name,
      );
      await authController.refreshUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.photoUpdated),
            backgroundColor: AppColors.primary,
          ),
        );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Widget _avatar(AppLocalizations l10n, {required bool compact}) {
    final size = compact ? 84.0 : 110.0;
    return GestureDetector(
      onTap: _uploadingPhoto ? null : _changePhoto,
      child: Semantics(
        button: true,
        label: l10n.changePhoto,
        child: Stack(
          children: [
            AppAvatar(
              asset: authController.currentUser?.avatarUrl,
              fallbackIcon: authController.currentUser?.isPatient == false
                  ? Icons.person
                  : Icons.elderly,
              size: size,
            ),
            if (_uploadingPhoto)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: compact ? 30 : 34,
                height: compact ? 30 : 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: compact ? 14 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          l10n.navProfile,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Like Home: sized from the height actually available so the page
          // fits without scrolling, on a small phone and in a mobile browser.
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          final height = constraints.maxHeight;
          final compact = height < 620 * textScale;
          // Avatar, name and the log-out button come to roughly 300dp and
          // grow with the text scale; the four rows need about 120dp more to
          // stay tappable. This is the body's height, with the app bar
          // already taken off.
          final fits = height >= 300 * textScale + 120;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: compact ? 4 : 12),
              Center(child: _avatar(l10n, compact: compact)),
              SizedBox(height: compact ? 10 : 16),
              Text(
                authController.currentUser?.fullName ?? l10n.userFullNameTitled,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact ? AppText.title : AppText.titleLarge,
              ),
              if (authController.currentUser?.age != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.profileAge(authController.currentUser!.age!),
                  textAlign: TextAlign.center,
                  style: AppText.bodyMuted,
                ),
              ],
              SizedBox(height: compact ? 14 : 24),
              // The settings rows share whatever height is left, so they end
              // just above the log-out button whatever the screen size.
              for (final entry in ProfileEntry.values) ...[
                if (fits)
                  Expanded(
                    child: _SettingsRow(
                      icon: _entryIcons[entry]!,
                      label: _label(l10n, entry),
                      onTap: () => _open(context, entry),
                    ),
                  )
                else
                  _SettingsRow(
                    icon: _entryIcons[entry]!,
                    label: _label(l10n, entry),
                    onTap: () => _open(context, entry),
                  ),
                SizedBox(height: compact ? 8 : 12),
              ],
              SizedBox(height: compact ? 2 : 6),
              ElevatedButton.icon(
                onPressed: () => _logOut(context),
                icon: const Icon(Icons.logout),
                label: Text(l10n.logOut),
                style: compact
                    ? ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      )
                    : null,
              ),
            ],
          );

          final padded = Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.sm,
              AppSpacing.page,
              // Leave the chat bubble's corner clear, as Home does.
              (compact ? AppSpacing.md : AppSpacing.lg) +
                  (chatController.bubbleVisible ? chatBubbleClearance : 0),
            ),
            child: content,
          );

          return fits ? padded : SingleChildScrollView(child: padded);
        },
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
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
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
