import 'package:flutter/material.dart';
import 'package:note_it2/di/injector.dart';
import 'package:note_it2/ui/note_edit_screen/note_edit_screen.dart';
import 'package:note_it2/ui/note_list/note_list_screen.dart';
import 'package:note_it2/ui/routes.dart';
import 'package:note_it2/ui/secure_note_list/secure_note_list_screen.dart';
import 'package:note_it2/ui/settings/settings_screen.dart';

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
      initialRoute: Routes.listScreen,
      routes: {
        Routes.listScreen : (context) => const NoteListScreen(),
        Routes.editScreen : (context) => const NoteEditScreen(),
        Routes.settingsScreen : (context) => const SettingsScreen(),
        Routes.secureListScreen : (context) => const SecureNoteListScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}