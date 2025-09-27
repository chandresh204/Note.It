import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes demo app',
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.splashScreen : (context) => const SplashScreen(),
        Routes.listScreen : (context) => const NoteListScreen(),
        Routes.editScreen : (context) => const NoteEditScreen(),
        Routes.secureIntroductionScreen : (context) => const SecurePasswordIntroduction(),
        Routes.settingsScreen : (context) => const SettingsScreen(),
        Routes.secureListScreen : (context) => const SecureNoteListScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          brightness: Brightness.dark
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}