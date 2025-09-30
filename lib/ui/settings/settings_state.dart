import 'package:note_it/ui/theme/app_colors.dart';

import '../../util/constants.dart';
import '../../util/runtime_constants.dart';

abstract class SettingsState {}

class SettingStateIdle extends SettingsState {
  double textScaler = RuntimeConstants.currentTextScaler - Constants.textScalerAndSliderDiff;
  AppColors selectedColor = RuntimeConstants.selectedAppColor;
  SettingStateIdle();
}

class SnackBarInState extends SettingStateIdle {
  final String msg;
  SnackBarInState(this.msg) : super();
}

class BackupDataReceivedState extends SettingStateIdle {
  final String backupData;
  BackupDataReceivedState(this.backupData) : super();
}

class ThemeColorChanged extends SettingStateIdle {}