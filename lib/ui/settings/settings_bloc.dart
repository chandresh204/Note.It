import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/ui/theme/themes.dart';
import '../../repository/settings_repository.dart';
import '../../util/runtime_constants.dart';
import '/ui/settings/settings_event.dart';
import '/ui/settings/settings_state.dart';

import '../../repository/backup_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final BackupRepository _backupRepository;
  final SettingsRepository _settingsRepository;

  SettingsBloc(this._backupRepository, this._settingsRepository) : super(SettingStateIdle()) {
    on<RestoreNotesEvent>(_restoreNotes);
    on<ShowSnackbarEvent>(_showSnackBar);
    on<BackupNotesEvent>(_prepareBackupInJson);
    on<UpdateTextSizeEvent>(_updateTextScaler);
    on<UpdateThemeColorEvent>(_updateThemeColor);
  }

  _restoreNotes(RestoreNotesEvent event, emit) {
    FilePicker.platform.pickFiles(allowMultiple: false).then((files) async {
      if (files != null) {
        final restoreFile = File(files.files.first.path!);
        final restored = await _backupRepository.restoreNotesFromFile(restoreFile);
        final msg = restored >= 0
          ? '$restored notes restored'
            : 'Something went wrong when restoring notes';
        add(ShowSnackbarEvent(msg));
      }
    });
  }

  _showSnackBar(ShowSnackbarEvent event, emit) {
    emit(SnackBarInState(event.msg));
  }

  _prepareBackupInJson(event, emit) async {
    final backupData = await _backupRepository.prepareNotesInJson();
    if(backupData.isEmpty) {
      emit(SnackBarInState('No notes available for backup'));
    } else {
      emit(BackupDataReceivedState(backupData));
    }
  }

  _updateTextScaler(UpdateTextSizeEvent event, emit)  {
    RuntimeConstants.currentTextScaler = event.newSize + 0.5;
    emit(SettingStateIdle());
    _settingsRepository.updateTextScaler(RuntimeConstants.currentTextScaler);
  }

  _updateThemeColor(UpdateThemeColorEvent event, emit) {
    RuntimeConstants.selectedAppColor = event.color;
    RuntimeConstants.lightThemeData = createLightTheme(event.color.mapToMaterialColor());
    RuntimeConstants.darkThemeData = createDarkTheme(event.color.mapToMaterialColor());
    emit(SettingStateIdle());
    _settingsRepository.updateAppThemeColor(event.color);
    emit(ThemeColorChanged());
  }

}
