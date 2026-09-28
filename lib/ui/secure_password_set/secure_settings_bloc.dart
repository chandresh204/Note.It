import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/settings_repository.dart';
import '../../util/runtime_constants.dart';
import 'secure_settings_event.dart';
import 'secure_settings_states.dart';

class SecureSettingsBloc extends Bloc<SecureSettingsEvent, SecureSettingsState> {

  final SettingsRepository _settingsRepository;

  String firstPassword = "";

  SecureSettingsBloc(this._settingsRepository) : super(SecureSettingsIdle(page: 0)) {
    on<MoveToNext>(_moveToNextPage);
    on<InitPasswordSet>(_initPasswordSet);
    on<ComparePasswords>(_comparePasswords);
  }

  void _moveToNextPage(MoveToNext evet, Emitter<SecureSettingsState> emit) {
    if(state is SecureSettingsIdle) {
      emit(SecureSettingsIdle(page: (state as SecureSettingsIdle).page +1));
    }
  }

  void _initPasswordSet(InitPasswordSet evet, Emitter<SecureSettingsState> emit) {
    firstPassword = evet.firstPassword;
    emit(SecureSettingsIdle(page: (state as SecureSettingsIdle).page +1));
  }

  void _comparePasswords(ComparePasswords event, Emitter<SecureSettingsState> emit) {
    if(firstPassword != event.confirmPassword) {
      emit(SecureSettingsError(error: 'Both password did not match, please try again'));
    } else {
      RuntimeConstants.securePassword = firstPassword;
      _settingsRepository.updateSecureNotePassword(firstPassword);
      emit(SecureSettingsSuccess());
    }
  }

}