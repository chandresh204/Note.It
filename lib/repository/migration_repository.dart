import '../data/encryption/encrypt_decrypt.dart';
import '../util/shared_preference_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MigrationRepository {

  late SharedPreferences _prefs;
  late PackageInfo _packageInfo;
  int currentAppVersion = 9999;
  bool isInitialized = false;

  MigrationRepository()  {
    init();
  }

  Future<void> performMigration() async {
    while(!isInitialized)  {
      await Future.delayed(Duration(milliseconds: 100), () {
      });
    }
    final lastAppVersion = _prefs.getInt(SharedPreferencesConstants.lastAppVersionPrefString);
    print('performing migration, last app version : $lastAppVersion');
    if(lastAppVersion == null || lastAppVersion < 13) {
      _migrateSecurePasswordToEncrypted();
    }
    if(lastAppVersion == null || lastAppVersion < currentAppVersion) {
      _updateLastAppVersionStringToThisOne();
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _packageInfo = await PackageInfo.fromPlatform();
    currentAppVersion = int.parse(_packageInfo.buildNumber);
    isInitialized = true;
  }

  void _migrateSecurePasswordToEncrypted() {
    print('performing migration, encrypting password');
    final oldPassword = _prefs.getString(SharedPreferencesConstants.securePasswordPrefString);
    if(oldPassword != null && oldPassword.isNotEmpty) {
      final encPass = EncDec.getEncryptedText(oldPassword);
      _prefs.setString(SharedPreferencesConstants.securePasswordPrefString, encPass);
      print('performing migration, encrypting password done');
    } else {
      print('performing migration, password was not set in previous version');
    }
  }

  void _updateLastAppVersionStringToThisOne() {
    print('setting last app version to: $currentAppVersion');
    _prefs.setInt(SharedPreferencesConstants.lastAppVersionPrefString, currentAppVersion);
  }
}