import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/ui/theme/font_family.dart';

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

class UpdateFontFamilyEvent extends SettingsEvent {
  final FontFamily font;
  UpdateFontFamilyEvent({required this.font});
}