import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color.dart';

class MyTheme {

  static const appVersion = 8.1;
  static const colorDiff = 50;
  static Color colorDefault = const Color(0xffffad76);
  static Color colorRed = const Color(0xffff3d41);
  static Color colorBlue = const Color(0xff25ceef);
  static Color colorGreen = const Color(0xff63ac5d);
  static Color colorGrey = const Color(0xffb5b5b5);
  static Color colorBlue1 = const Color(0xff276b8e);
  static Color colorPink = const Color(0xffd64389);
  static Color colorPurple = const Color(0xffa23cab);
  static Color colorGreenLight = const Color(0xff00ffab);
  static Color colorBlack = const Color(0xff222222);
  static Color colorLemon = const Color(0xffcfce78);

  static late MyColor myCustomColor;
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
  static late MyColor myColorLemon;

  static const int colorId0 = 0;
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
  static const int colorId11 = 11;

  static var isGettingFromPrefs = true;
  static var isDarkMode = false;
  static var securePassword = '';

  static const String isDarkModePrefString = 'isDarkMode';
  static const String colorIdPrefsString = 'colorIdInPrefs';
  static const String hyperlinkColorPrefsString = 'hyperLinkColorPrefs';
  static const String fontPreferenceString = 'fontInPrefs';
  static const String textSizePreferenceString = 'textSizeInPrefs';
  static const String securePasswordPrefString = 'secureNotes';
  static const String animationPrefString = 'animationInPrefs';
  static const String animationDialogPrefString = 'dialogAnimationInPrefs';
  static const String animationTimePrefString = 'animationTimeInPrefs';
  static const String myColorPrimaryRedPref = 'myColorPrimaryRed';
  static const String myColorPrimaryGreenPref = 'myColorPrimaryGreen';
  static const String myColorPrimaryBluePref = 'myColorPrimaryBlue';
  static const String myColorLightRedPrefs = 'myColorLightRed';
  static const String myColorLightGreenPrefs = 'myColorLightGreen';
  static const String myColorLightBluePrefs = 'myColorLightBlue';
  static const String myColorDarkRedPrefs = 'myColorDarkRed';
  static const String myColorDarkGreenPrefs = 'myColorDarkGreen';
  static const String myColorDarkBluePrefs = 'myColorDarkBlue';

  static var selectedColorScheme = myColorDefault;
  static var selectedHyperlinkColor = myColorBlue1;
  static var selectedFonts = 'Default';
  static var selectedAnimation = 'None';
  static var selectedDialogAnimation = 'Dialog Slide Elastic';
  static var primaryFontSize = 18.0;
  static const fontMultiplier = 0.3;
  static const dialogCornerRadius = 16.0;
  static var animationTiming = 800;
  static const animationDialogTimingConst = 0.5;
  static var smallFontSize =
      primaryFontSize - (primaryFontSize * fontMultiplier);
  static var largeFontSize =
      primaryFontSize + (primaryFontSize * fontMultiplier);

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

  //list of animations for note tiles
  static const animationNone = 'None';
  static const animationSlideIn = 'Slide In';
  static const animationSlideBounce = 'Slide Bounce';
  static const animationSlideElastic = 'Slide Elastic';
  static const animationFade = 'Fade';
  static const animationZoom = 'Zoom';
  static const animationPop = 'Pop';
  static const animationZoomOut = 'Zoom Out';
  static const animationFallDown = 'Fall down';
  static const animationFlying = 'Flying';

  //list of animation for dialog
  static const dialogAnimationNone = 'None';
  static const dialogAnimationSlideIn = 'Dialog Slide in';
  static const dialogAnimationSlideElastic = 'Dialog Slide Elastic';
  static const dialogAnimationRotate = 'Dialog Rotate';
  static const dialogAnimationFade = 'Dialog Fade';
  static const dialogAnimationZoomIn = 'Dialog Zoom';
  static const dialogAnimationPop = 'Dialog Pop';
  static const dialogAnimationZoomOut = 'Dialog Zoom Out';
  static const dialogAnimationLanding = 'Dialog Landing';

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
    myColorLemon = MyColor(colorId11, colorLemon,
      createMaterialColor(colorLemon),
      const Color.fromARGB(255, 163, 212, 250),
      const Color.fromARGB(255, 151, 47, 136),
      Colors.black);
    final prefs = await SharedPreferences.getInstance();
    int primaryRed = prefs.getInt(myColorPrimaryRedPref) ?? 125;
    int primaryGreen = prefs.getInt(myColorPrimaryGreenPref) ?? 206;
    int primaryBlue = prefs.getInt(myColorPrimaryBluePref) ?? 120;
    int lightRed = prefs.getInt(myColorLightRedPrefs) ?? 162;
    int lightGreen = prefs.getInt(myColorLightGreenPrefs) ?? 212;
    int lightBlue = prefs.getInt(myColorLightBluePrefs) ?? 250;
    int darkRed = prefs.getInt(myColorDarkRedPrefs) ?? 151;
    int darkGreen = prefs.getInt(myColorDarkGreenPrefs) ?? 46;
    int darkBlue = prefs.getInt(myColorDarkBluePrefs) ?? 135;
    var basicColor = Color.fromARGB(255, primaryRed, primaryGreen, primaryBlue);
    myCustomColor = MyColor(
        0,
        basicColor,
        createMaterialColor(basicColor),
        Color.fromARGB(255, lightRed, lightGreen, lightBlue),
        Color.fromARGB(255, darkRed, darkGreen, darkBlue),
        ((basicColor.red + basicColor.green + basicColor.blue < 420))
            ? Colors.white
            : Colors.black);
    final darkValueInPrefs = prefs.getBool(isDarkModePrefString);
    if (darkValueInPrefs == null) {
      isDarkMode = false;
    } else {
      isDarkMode = darkValueInPrefs;
    }
    final colorIdInPrefs = prefs.getInt(colorIdPrefsString);
    switch (colorIdInPrefs) {
      case colorId0:
        {
          selectedColorScheme = myCustomColor;
        }
        break;
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
      case colorId11:
        {
          selectedColorScheme = myColorLemon;
        }
        break;
      default:
        {
          selectedColorScheme = myColorDefault;
        }
    }
    final hyperlinkColorPrefs = prefs.getInt(hyperlinkColorPrefsString);
    switch (hyperlinkColorPrefs) {
      case colorId0:
        {
          selectedHyperlinkColor = myCustomColor;
        }
        break;
      case colorId1:
        {
          selectedHyperlinkColor = myColorDefault;
        }
        break;
      case colorId2:
        {
          selectedHyperlinkColor = myColorRed;
        }
        break;
      case colorId3:
        {
          selectedHyperlinkColor = myColorBlue;
        }
        break;
      case colorId4:
        {
          selectedHyperlinkColor = myColorGreen;
        }
        break;
      case colorId5:
        {
          selectedHyperlinkColor = myColorGrey;
        }
        break;
      case colorId6:
        {
          selectedHyperlinkColor = myColorBlue1;
        }
        break;
      case colorId7:
        {
          selectedHyperlinkColor = myColorPink;
        }
        break;
      case colorId8:
        {
          selectedHyperlinkColor = myColorPurple;
        }
        break;
      case colorId9:
        {
          selectedHyperlinkColor = myColorGreenLight;
        }
        break;
      case colorId10:
        {
          selectedHyperlinkColor = myColorBlack;
        }
        break;
      case colorId11:
        {
          selectedHyperlinkColor = myColorLemon;
        }
        break;
      default:
        {
          selectedHyperlinkColor = myColorBlue1;
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
    final animationString = prefs.getString(animationPrefString);
    if (animationString == null || animationString.isEmpty) {
      MyTheme.selectedAnimation = MyTheme.animationSlideElastic;
    } else {
      MyTheme.selectedAnimation = animationString;
    }
    final dialogAnimationString = prefs.getString(animationDialogPrefString);
    if (dialogAnimationString == null || dialogAnimationString.isEmpty) {
      MyTheme.selectedDialogAnimation = MyTheme.dialogAnimationSlideIn;
    } else {
      MyTheme.selectedDialogAnimation = dialogAnimationString;
    }
    final animationTime1 = prefs.getInt(animationTimePrefString);
    if (animationTime1 == null || animationTime1.isNaN) {
      animationTiming = 500;
    } else {
      animationTiming = animationTime1;
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

  static MyColor createMyColor(int id, Color color) {
    return MyColor(
        id,
        color,
        createMaterialColor(color),
        changeColor(color, colorDiff),
        changeColor(color, -colorDiff),
        ((color.red + color.green + color.blue < 420))
            ? Colors.white
            : Colors.black);
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

  // different animations for note tiles
  static Widget getSelectedAnimatedWidget(
      BuildContext context, int index, animation, Widget child) {
    switch (MyTheme.selectedAnimation) {
      case MyTheme.animationNone:
        return child;
      case MyTheme.animationSlideIn:
        return SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(
                  CurvedAnimation(parent: animation, curve: Curves.decelerate)),
          child: child,
        );
      case MyTheme.animationSlideBounce:
        return SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(
                  CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
          child: child,
        );
      case MyTheme.animationSlideElastic:
        return SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(
                  CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
          child: child,
        );
      case MyTheme.animationFade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInExpo),
          child: child,
        );
      case MyTheme.animationZoom:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
          child: child,
        );
      case MyTheme.animationPop:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: child,
        );
      case MyTheme.animationZoomOut:
        return ScaleTransition(
          scale: Tween<double>(begin: 2.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.decelerate)),
          child: child,
        );
      case MyTheme.animationFallDown:
        return ScaleTransition(
          scale: Tween<double>(begin: 2.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
          child: child,
        );
      case MyTheme.animationFlying:
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 10), end: Offset(0, 0))
              .animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutExpo)),
          child: child,
        );
    }
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(
                  CurvedAnimation(parent: animation, curve: Curves.decelerate)),
      child: child,
    );
  }

  // animations for dialog, return transition builder for showGeneralDialog
  static Widget getSelectedDialogTransition(
      Animation<double> a1, Widget child) {
    switch (MyTheme.selectedDialogAnimation) {
      case MyTheme.dialogAnimationNone:
        return child;
      case MyTheme.dialogAnimationSlideIn:
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(CurvedAnimation(parent: a1, curve: Curves.decelerate)),
          child: child,
        );
      case MyTheme.dialogAnimationSlideElastic:
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(CurvedAnimation(parent: a1, curve: Curves.elasticOut)),
          child: child,
        );
      case MyTheme.dialogAnimationRotate:
        return RotationTransition(
            turns: CurvedAnimation(parent: a1, curve: Curves.bounceOut),
            child: child);
      case MyTheme.dialogAnimationFade:
        return FadeTransition(opacity: a1, child: child);
      case MyTheme.dialogAnimationZoomIn:
        return ScaleTransition(
            scale: CurvedAnimation(parent: a1, curve: Curves.decelerate),
            child: child);
      case MyTheme.dialogAnimationPop:
        return ScaleTransition(
            scale: CurvedAnimation(parent: a1, curve: Curves.bounceOut),
            child: child);
      case MyTheme.dialogAnimationZoomOut:
        return ScaleTransition(
            scale: Tween<double>(begin: 2.0, end: 1.0).animate(
                CurvedAnimation(parent: a1, curve: Curves.easeOutExpo)),
            child: child);
      case MyTheme.dialogAnimationLanding:
        return SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(CurvedAnimation(parent: a1, curve: Curves.easeOutExpo)),
          child: child,
        );
    }
    return child;
  }

  static Color getTextButtonColor() {
    if(isDarkMode) {
      return Colors.white;
    }
    return Colors.black;
  }
}
