import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/theme/themes.dart';
import 'package:note_it/util/constants.dart';

import '/ui/settings/settings_event.dart';
import '/ui/settings/settings_state.dart';
import '../../repository/backup_repository.dart';
import '../../repository/settings_repository.dart';
import '../../util/runtime_constants.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final BackupRepository _backupRepository;
  final SettingsRepository _settingsRepository;

  SettingsBloc(this._backupRepository, this._settingsRepository) : super(SettingStateIdle()) {
    on<RestoreNotesEvent>(_restoreNotes);
    on<ShowSnackbarEvent>(_showSnackBar);
    on<BackupNotesEvent>(_prepareBackupInJson);
    on<UpdateTextSizeEvent>(_updateTextScaler);
    on<UpdateThemeColorEvent>(_updateThemeColor);
    on<UpdateFontFamilyEvent>(_updateFontFamily);
    on<UpdateBlurEffectEvent>(_onToggleBlurEffect);
  }

  _restoreNotes(RestoreNotesEvent event, emit) {
    FilePicker.pickFile().then((file) async {
      if(file != null && file.path != null) {
        final restoreFile = File(file.path!);
        final restored = await _backupRepository.restoreNotesFromFile(restoreFile);
        final msg = restored >= 0
          ? '$restored notes restored'
          : 'Something went wrong when restoring notes';
        add(ShowSnackbarEvent(msg));
      } else {
        emit(SnackBarInState('Error file selection'));
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
    RuntimeConstants.lightThemeData = createLightTheme();
    RuntimeConstants.darkThemeData = createDarkTheme();
    emit(SettingStateIdle());
    _settingsRepository.updateAppThemeColor(event.color);
    emit(ThemeColorChanged());
  }

  _updateFontFamily(UpdateFontFamilyEvent event, emit) {
    RuntimeConstants.selectedFontFamily = event.font;
    RuntimeConstants.lightThemeData = createLightTheme();
    RuntimeConstants.darkThemeData = createDarkTheme();
    emit(SettingStateIdle());
    _settingsRepository.updateFontFamily(event.font);
    emit(ThemeColorChanged());
  }
  
  _onToggleBlurEffect(UpdateBlurEffectEvent event, emit) {
    RuntimeConstants.isBlurEffectEnabled = event.isEnable;
    RuntimeConstants.appBarAlpha = event.isEnable ? Constants.appBarAlphaInBlur : Constants.appBarAlphaWithoutBlur;
    RuntimeConstants.lightThemeData = createLightTheme();
    RuntimeConstants.darkThemeData = createDarkTheme();
    emit(SettingStateIdle());
    _settingsRepository.updateBlueEffect(event.isEnable);
    emit(ThemeColorChanged());
  }

}
