import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../main.dart';
import '../themes/theme.dart';
import 'home_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AppUpdateInfo? _updateInfo;

  @override
  Widget build(BuildContext context) {
    checkForUpdate();
    Future.delayed(const Duration(seconds: 2), () {
      if (!MyApp.appReady) {
        MyApp.appReady = true;
        MyApp.of(context)!.changeTheme(
            MyTheme.isDarkMode,
            MyTheme.selectedColorScheme.primary,
            MyTheme.selectedFonts);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }) , (route) => false);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(child: Image(image: AssetImage('assets/images/note_it_icon.png'), width: 250,)),
              CircularProgressIndicator(color:
                Colors.black,),
              Padding(padding: EdgeInsets.all(16)),
              Text('V7.0', style: TextStyle(fontSize: 22),),
            ]
        ),
      )
    );
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      print('update availability ${_updateInfo?.updateAvailability}');
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate();
      }
    });
  }
}
