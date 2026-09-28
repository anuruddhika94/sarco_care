# sarco_care

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Building the Android app

```bash
flutter build apk --release --split-per-abi
```

That writes one APK per CPU type to `build/app/outputs/flutter-apk/`. For
sideloading onto a modern phone use `app-arm64-v8a-release.apk` (~28 MB);
`flutter build apk --release` on its own produces a single 64 MB file
containing every architecture. For Google Play, build an app bundle instead
with `flutter build appbundle --release`.

**Signing.** Release builds are signed with the keystore described in
`android/key.properties`, which is deliberately not in git. It holds the
passwords and the path to the keystore file (by default
`~/keystores/sarco_care-upload.jks`).

**Back up both files somewhere safe.** If the keystore is lost, Google Play
will not accept any future update of this app — the only way out is publishing
under a new application ID, which means existing users have to reinstall.

Without `key.properties` (a fresh clone, or CI) the release build falls back to
the debug keystore, so it still builds but must not be shipped.

The application ID is `com.sarcocare.app`. Changing it later forces every user
to reinstall, so it should stay as it is.
