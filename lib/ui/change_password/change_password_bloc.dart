import 'package:flutter_bloc/flutter_bloc.dart';
import '/ui/change_password/change_password_state.dart';
import '/util/shared_preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordBloc extends Cubit<ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInit());

  Future<void> checkCurrentPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString(SharedPreferencesConstants.securePasswordPrefString);
    if(password == newPassword) {
      emit(CreateNewPassword());
    } else {
      emit(ChangePasswordInit(errorMsg: 'Incorrect Password'));
    }
  }

  void changePassword() {
    emit(ChangePasswordDone());
  }
}