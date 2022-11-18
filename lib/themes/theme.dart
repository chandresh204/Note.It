import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color.dart';

class MyTheme {

  static const colorDiff = 50;
  static Color colorDefault = const Color(0xffffad76);
  static Color colorRed = const Color(0xffca0020);
  static Color colorBlue = const Color(0xff197cff);
  static Color colorGreen = const Color(0xff02881e);
  static Color colorGrey = const Color(0xffb5b5b5);
  static Color colorBlue1 = const Color(0xff276b8e);
  static Color colorPink = const Color(0xffd64389);
  static Color colorPurple = const Color(0xffa23cab);
  static Color colorGreenLight = const Color(0xff00ffab);
  static Color colorBlack = const Color(0xff222222);

  static late MyColor myColorDefault;
  static late MyColor myColorRed;
  static late MyColor myColorBlue;
  static late MyColor myColorGreen;
  static late MyColor myColorGrey;
  static late MyColor myColorBlue1;
  static late MyColor myColorPink;
  static late MyColor myColorPurple;
  static late MyColor myColorGreenLight;
  static late MyColor myColorBlack;

  static const int colorId1 = 1;
  static const int colorId2 = 2;
  static const int colorId3 = 3;
  static const int colorId4 = 4;
  static const int colorId5 = 5;
  static const int colorId6 = 6;
  static const int colorId7 = 7;
  static const int colorId8 = 8;
  static const int colorId9 = 9;
  static const int colorId10 = 10;

  static var isGettingFromPrefs = true;
  static var isDarkMode = false;
  static var securePassword = '';

  static const String isDarkModePrefString = 'isDarkMode';
  static const String colorIdPrefsString = 'colorIdInPrefs';
  static const String fontPreferenceString = 'fontInPrefs';
  static const String textSizePreferenceString = 'textSizeInPrefs';
  static const String securePasswordPrefString = 'secureNotes';

  static var selectedColorScheme = myColorDefault;
  static var selectedFonts = 'Default';
  static var primaryFontSize = 18.0;
  static const fontMultiplier = 0.3;
  static var smallFontSize = primaryFontSize - (primaryFontSize * fontMultiplier);
  static var largeFontSize = primaryFontSize + (primaryFontSize * fontMultiplier);

  //list of fonts
  static const fontRaleway = 'Raleway';
  static const fontAntic = 'Antic';
  static const fontAssistant = 'Assistant';
  static const fontDancingScript = 'Dancing-Script';
  static const fontArchitectsDaughter = 'Architects-Daughter';
  static const fontAudiowide = 'Audiowide';
  static const fontBaloo2 = 'Baloo2';
  static const fontBoongaloo = 'Boogaloo';
  static const fontCookie = 'Cookie';
  static const fontDosis = 'Dosis';
  static const fontGreatVibes = 'GreatVibes';
  static const fontGruppo = 'Gruppo';
  static const fontLato = 'Lato';
  static const fontMontserrat = 'Montserrat';
  static const fontOpenSansCondensed = 'OpenSans-Condensed';
  static const fontOswald = 'Oswald';
  static const fontPoiretOne = 'PoiretOne';
  static const fontPrompt = 'Prompt';
  static const fontSacramento = 'Sacramento';
  static const fontSniglet = 'Sniglet';
  static const fontSpinnaker = 'Spinnaker';
  static const fontZenOldMincho = 'ZenOldMincho';
  static const fontDefault = 'Default';

  static initializeColors() async {
    myColorDefault = createMyColor(colorId1, colorDefault);
    myColorRed = createMyColor(colorId2, colorRed);
    myColorBlue = createMyColor(colorId3, colorBlue);
    myColorGreen = createMyColor(colorId4, colorGreen);
    myColorGrey = createMyColor(colorId5, colorGrey);
    myColorBlue1 = createMyColor(colorId6, colorBlue1);
    myColorPink = createMyColor(colorId7, colorPink);
    myColorPurple = createMyColor(colorId8, colorPurple);
    myColorGreenLight = createMyColor(colorId9, colorGreenLight);
    myColorBlack = createMyColor(colorId10, colorBlack);
    final prefs = await SharedPreferences.getInstance();
    final darkValueInPrefs = prefs.getBool(isDarkModePrefString);
    if (darkValueInPrefs == null) {
      isDarkMode = false;
    } else {
      isDarkMode = darkValueInPrefs;
    }
    final colorIdInPrefs = prefs.getInt(colorIdPrefsString);
    switch (colorIdInPrefs) {
      case colorId1:
        {
          selectedColorScheme = myColorDefault;
        }
        break;
      case colorId2:
        {
          selectedColorScheme = myColorRed;
        }
        break;
      case colorId3:
        {
          selectedColorScheme = myColorBlue;
        }
        break;
      case colorId4:
        {
          selectedColorScheme = myColorGreen;
        }
        break;
      case colorId5:
        {
          selectedColorScheme = myColorGrey;
        }
        break;
      case colorId6:
        {
          selectedColorScheme = myColorBlue1;
        }
        break;
      case colorId7:
        {
          selectedColorScheme = myColorPink;
        }
        break;
      case colorId8:
        {
          selectedColorScheme = myColorPurple;
        }
        break;
      case colorId9:
        {
          selectedColorScheme = myColorGreenLight;
        }
        break;
      case colorId10:
        {
          selectedColorScheme = myColorBlack;
        }
        break;
      default:
        {
          selectedColorScheme = myColorDefault;
        }
    }
    final font = prefs.getString(fontPreferenceString);
    if (font != null) {
      selectedFonts = font;
    } else {
      selectedFonts = fontRaleway;
    }
    final fontSize = prefs.getDouble(textSizePreferenceString);
    if (fontSize != null) {
      setAllFonts(fontSize);
    } else {
      setAllFonts(18.0);
    }
    final passInPrefs = prefs.getString(securePasswordPrefString);
    if (passInPrefs != null) {
      securePassword = passInPrefs;
    } else {
      securePassword = '';
    }
    isGettingFromPrefs = false;
 //   print('theme data updated from prefs');
  }

  static setAllFonts(double primaryValue) {
    primaryFontSize = primaryValue;
    smallFontSize = primaryFontSize - (primaryFontSize * fontMultiplier);
    largeFontSize = primaryFontSize + (primaryFontSize * fontMultiplier);
  }
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static MyColor createMyColor(int id,Color color) {
    return  MyColor(id, color, createMaterialColor(color),
        changeColor(color, colorDiff),
        changeColor(color, -colorDiff));
  }
  static Color changeColor(Color color, int diff) {
    var newRed = color.red + diff;
    var newGreen = color.green + diff;
    var newBlue = color.blue + diff;
    if (newRed < 0) {
      newRed = 0;
    }
    if (newRed > 255) {
      newRed = 255;
    }
    if (newGreen < 0) {
      newGreen = 0;
    }
    if (newGreen > 255) {
      newGreen = 255;
    }
    if (newBlue < 0) {
      newBlue = 0;
    }
    if (newBlue > 255) {
      newBlue = 255;
    }
    return Color.fromARGB(255, newRed, newGreen, newBlue);
  }
}