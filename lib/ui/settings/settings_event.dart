abstract class SettingsEvent {}

class ShowSnackbarEvent extends SettingsEvent {
  final String msg;

  ShowSnackbarEvent(this.msg);
}

class RestoreNotesEvent extends SettingsEvent {}

class BackupNotesEvent extends SettingsEvent {}