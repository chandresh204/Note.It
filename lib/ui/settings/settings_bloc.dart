import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it2/ui/settings/settings_event.dart';
import 'package:note_it2/ui/settings/settings_state.dart';

import '../../repository/backup_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final BackupRepository _backupRepository;

  SettingsBloc(this._backupRepository) : super(SettingStateIdle()) {
    on<RestoreNotesEvent>(_restoreNotes);
    on<ShowSnackbarEvent>(_showSnackBar);
    on<BackupNotesEvent>(_prepareBackupInJson);
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

}
