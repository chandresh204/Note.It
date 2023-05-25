import 'package:flutter/material.dart';
import 'themes/theme.dart';
import 'ui/spalsh_screen.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String DB_NAME ='note-database.db';
  static var appReady = false;

  static _MyAppState? of(BuildContext context) =>
      context.findRootAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  MaterialColor _primarySwatch = Colors.purple;
  String _font = '';
  void changeTheme(bool isDarkMode, MaterialColor primarySwatch, String fontName) {
      setState(() {
        if (isDarkMode) {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.light;
        }
        _primarySwatch = primarySwatch;
        _font = fontName;
      });
  }


  @override
  Widget build(BuildContext context) {
    MyTheme.initializeColors();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: _primarySwatch,
        fontFamily: _font,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: _font,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        primarySwatch: _primarySwatch,
      ),
      home: const SplashScreen(),
    );
  }
}