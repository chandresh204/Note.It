import '../data/encryption/encrypt_decrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/shared_preference_constants.dart';

class SettingsRepository {

  late SharedPreferences _prefs;

  SettingsRepository() { init();}

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void updateTextScaler(double scale) {
    _prefs.setDouble(SharedPreferencesConstants.textScaleFactorPrefString, scale);
  }

  Future<double> getTextScaler() async {
    return _prefs.getDouble(SharedPreferencesConstants.textScaleFactorPrefString) ?? 1.0;
  }

  void updateSecureNotePassword(String password) {
    final encryptedPassword = EncDec.getEncryptedText(password);
    _prefs.setString(SharedPreferencesConstants.securePasswordPrefString, encryptedPassword);
  }

  String? getSecureNotePassword() {
    return _prefs.getString(SharedPreferencesConstants.securePasswordPrefString);
  }
}