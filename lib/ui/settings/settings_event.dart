import 'package:note_it/ui/theme/app_colors.dart';

abstract class SettingsEvent {}

class ShowSnackbarEvent extends SettingsEvent {
  final String msg;

  ShowSnackbarEvent(this.msg);
}

class RestoreNotesEvent extends SettingsEvent {}

class BackupNotesEvent extends SettingsEvent {}

class UpdateTextSizeEvent extends SettingsEvent {
  final double newSize;
  UpdateTextSizeEvent({required this.newSize});
}

class UpdateThemeColorEvent extends SettingsEvent {
  final AppColors color;
  UpdateThemeColorEvent({required this.color});
}