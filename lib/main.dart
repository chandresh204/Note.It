import 'package:flutter/material.dart';
import 'package:note_it/util/runtime_constants.dart';
import '/ui/note_edit_screen/note_edit_screen.dart';
import '/ui/note_list/note_list_screen.dart';
import '/ui/routes.dart';
import '/ui/secure_note_list/secure_note_list_screen.dart';
import '/ui/settings/settings_screen.dart';

import 'di/injector.dart';
import 'ui/secure_password_set/secure_password_introduction.dart';
import 'ui/splash_screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocators();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes demo app',
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.splashScreen : (context) => SplashScreen(onThemeSet: () {
          setState(() {});
        },),
        Routes.listScreen : (context) => const NoteListScreen(),
        Routes.editScreen : (context) => const NoteEditScreen(),
        Routes.secureIntroductionScreen : (context) => const SecurePasswordIntroduction(),
        Routes.settingsScreen : (context) => const SettingsScreen(),
        Routes.secureListScreen : (context) => const SecureNoteListScreen()
      },
      theme: RuntimeConstants.lightThemeData,
      darkTheme: RuntimeConstants.darkThemeData,
      themeMode: ThemeMode.system,
    );
  }
}
