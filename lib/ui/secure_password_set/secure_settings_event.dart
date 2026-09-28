sealed class SecureSettingsEvent {}

class MoveToNext extends SecureSettingsEvent {}

class InitPasswordSet extends SecureSettingsEvent {
  final String firstPassword;
  InitPasswordSet({required this.firstPassword});
}

class ComparePasswords extends SecureSettingsEvent {
  final String confirmPassword;
  ComparePasswords({required this.confirmPassword});
}