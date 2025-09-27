import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/encryption/encrypt_decrypt.dart';
import '../../repository/migration_repository.dart';
import '../../util/runtime_constants.dart';
import '../../util/shared_preference_constants.dart';
import '../routes.dart';
import '../theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _versionName = '';
  late MigrationRepository _migrationRepository;

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  _asyncInit() async {
    _migrationRepository = MigrationRepository();
    await _migrationRepository.performMigration();
    _initializeSettingValues();
  }
  
  _initializeSettingValues() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _versionName = packageInfo.version;
      });
    });
    SharedPreferences.getInstance().then((prefs)  {
      RuntimeConstants.currentTextScaler = prefs.getDouble(SharedPreferencesConstants.textScaleFactorPrefString) ?? 1.0;
      final encPassword =  prefs.getString(SharedPreferencesConstants.securePasswordPrefString);
      RuntimeConstants.securePassword = (encPassword == null) ? null : EncDec.getDecryptText(encPassword);
      Future.delayed(Duration(seconds: 1), () {
        if(mounted) {
          Navigator.pushReplacementNamed(context, Routes.listScreen);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset('assets/images/note_it_icon.png', width: 100, height: 100,)),
              Text('Ver. $_versionName', style: AppTextStyles.heading2),
              SizedBox(height: 16, child: Row()),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
