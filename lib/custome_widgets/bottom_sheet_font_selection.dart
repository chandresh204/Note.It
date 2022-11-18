import 'package:flutter/material.dart';

import '../themes/theme.dart';

class BottomSheetFontSelection {
  final BuildContext context;
  final Function(String) setFont;
  BottomSheetFontSelection(this.context, this.setFont);

  getUI() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Select a Font',
                  style: TextStyle(fontSize: MyTheme.largeFontSize),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      _getFontPlate(MyTheme.fontRaleway),
                      _getFontPlate(MyTheme.fontAntic),
                      _getFontPlate(MyTheme.fontAssistant),
                      _getFontPlate(MyTheme.fontDancingScript),
                      _getFontPlate(MyTheme.fontArchitectsDaughter),
                      _getFontPlate(MyTheme.fontAudiowide),
                      _getFontPlate(MyTheme.fontBaloo2),
                      _getFontPlate(MyTheme.fontBoongaloo),
                      _getFontPlate(MyTheme.fontCookie),
                      _getFontPlate(MyTheme.fontDosis),
                      _getFontPlate(MyTheme.fontGreatVibes),
                      _getFontPlate(MyTheme.fontGruppo),
                      _getFontPlate(MyTheme.fontLato),
                      _getFontPlate(MyTheme.fontMontserrat),
                      _getFontPlate(MyTheme.fontOpenSansCondensed),
                      _getFontPlate(MyTheme.fontOswald),
                      _getFontPlate(MyTheme.fontPoiretOne),
                      _getFontPlate(MyTheme.fontPrompt),
                      _getFontPlate(MyTheme.fontSacramento),
                      _getFontPlate(MyTheme.fontSniglet),
                      _getFontPlate(MyTheme.fontSpinnaker),
                      _getFontPlate(MyTheme.fontZenOldMincho),
                      _getFontPlate(MyTheme.fontDefault),
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }

  _getFontPlate(String fontName) {
    return ListTile(
      onTap: () {
        setFont(fontName);
        Navigator.pop(context);
      },
      selected: MyTheme.selectedFonts == fontName,
      selectedTileColor: MyTheme.selectedColorScheme.primary,
      selectedColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(fontName, style: TextStyle(fontFamily: fontName, fontSize: MyTheme.primaryFontSize),),
    );
  }
}
