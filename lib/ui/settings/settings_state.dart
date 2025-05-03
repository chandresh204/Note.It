abstract class SettingsState {}

class SettingStateIdle extends SettingsState {}

class SnackBarInState extends SettingStateIdle {
  final String msg;

  SnackBarInState(this.msg);
}

class BackupDataReceivedState extends SettingStateIdle {
  final String backupData;
  BackupDataReceivedState(this.backupData);
}