/// The signed-in user, as returned by the Rails API's `User#serializable_hash`
/// (see sarco_care_rails/app/models/user.rb).
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.age,
    this.avatarUrl,
    this.settings = const {},
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as int,
    fullName: json['full_name'] as String,
    phoneNumber: json['phone_number'] as String,
    role: json['role'] as String,
    age: json['age'] as int?,
    avatarUrl: json['avatar_url'] as String?,
    settings: (json['settings'] as Map<String, dynamic>?) ?? const {},
  );

  final int id;
  final String fullName;
  final String phoneNumber;
  final String role; // 'patient' or 'caretaker'
  final int? age;
  final String? avatarUrl;

  /// Backend-synced app settings, e.g. {'large_text': true, 'language': 'th'}.
  final Map<String, dynamic> settings;

  bool get isPatient => role == 'patient';

  String get firstName => fullName.split(' ').first;

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'phone_number': phoneNumber,
    'role': role,
    'age': age,
    'avatar_url': avatarUrl,
    'settings': settings,
  };
}
