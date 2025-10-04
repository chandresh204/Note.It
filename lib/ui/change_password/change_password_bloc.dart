import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/data/encryption/encrypt_decrypt.dart';
import 'package:note_it/util/extensions.dart';
import 'package:note_it/util/runtime_constants.dart';
import '/ui/change_password/change_password_state.dart';
import '/util/shared_preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordBloc extends Cubit<ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInit());

  Future<void> checkCurrentPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final passwordEnc = prefs.getString(SharedPreferencesConstants.securePasswordPrefString);
    final String password;
    if(passwordEnc.isNullOrEmpty()) {
      password = '';
    } else {
      password = EncDec.getDecryptText(passwordEnc!);
    }
    if(password == newPassword) {
      emit(CreateNewPassword(errorMsg: null));
    } else {
      emit(ChangePasswordInit(errorMsg: 'Incorrect Password'));
    }
  }

  Future<void> changePassword(String newPass, String confirmNewPass) async {
    if(newPass!= confirmNewPass) {
      emit(CreateNewPassword(errorMsg: 'Password do not matched'));
    } else {
      RuntimeConstants.securePassword = newPass;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        SharedPreferencesConstants.securePasswordPrefString,
        EncDec.getEncryptedText(newPass)
      );
      emit(ChangePasswordDone());
    }
  }
}