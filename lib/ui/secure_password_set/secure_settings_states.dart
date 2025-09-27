sealed class SecureSettingsState {}

class SecureSettingsIdle extends SecureSettingsState {
  final int page;
  SecureSettingsIdle({required this.page});
}

class SecureSettingsError extends SecureSettingsState {
  final String error;
  SecureSettingsError({required this.error});
}

class SecureSettingsSuccess extends SecureSettingsState {}