import 'package:flutter/material.dart';
import '../themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../themes/color.dart';

class MyColorSchemeEditor extends StatefulWidget {
  const MyColorSchemeEditor({Key? key}) : super(key: key);

  @override
  State<MyColorSchemeEditor> createState() => _MyColorSchemeEditorState();
}

class _MyColorSchemeEditorState extends State<MyColorSchemeEditor> {

  int selectedColorTab = 0;
  int colorPrimaryRed = 156;
  int colorPrimaryGreen = 81;
  int colorPrimaryBlue = 212;
  int colorLightRed = 176;
  int colorLightGreen = 101;
  int colorLightBlue = 232;
  int colorDarkRed = 136;
  int colorDarkGreen = 61;
  int colorDarkBlue = 192;

  @override
  void initState() {
    colorPrimaryRed = MyTheme.myCustomColor.basicColor.red;
    colorPrimaryGreen = MyTheme.myCustomColor.basicColor.green;
    colorPrimaryBlue = MyTheme.myCustomColor.basicColor.blue;
    colorLightRed = MyTheme.myCustomColor.primaryLight.red;
    colorLightGreen = MyTheme.myCustomColor.primaryLight.green;
    colorLightBlue = MyTheme.myCustomColor.primaryLight.blue;
    colorDarkRed = MyTheme.myCustomColor.primaryDark.red;
    colorDarkGreen = MyTheme.myCustomColor.primaryDark.green;
    colorDarkBlue= MyTheme.myCustomColor.primaryDark.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Color Scheme'),
        backgroundColor: Color.fromARGB(255, colorPrimaryRed, colorPrimaryGreen, colorPrimaryBlue),
        foregroundColor: textColorAsBerBackground(colorPrimaryRed, colorPrimaryGreen, colorPrimaryBlue),
        actions: [
          IconButton(onPressed: () {
            saveSchemeAndExit();
          }, icon: const Icon(Icons.check))
        ],),
      body: mainScreen(),
    );
  }

  Widget mainScreen() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            child: Center(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        blurRadius: 10,
                        offset: Offset(0,5)
                    )
                  ],
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, colorLightRed, colorLightGreen, colorLightBlue),
                        Color.fromARGB(255, colorPrimaryRed, colorPrimaryGreen, colorPrimaryBlue),
                      ]
                  ),
                ),
                child: Center(child: Text('Note in Light Mode', style: TextStyle(fontSize: MyTheme.primaryFontSize),)),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.black54,
            child: Center(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(100, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0,5)
                      )
                    ],
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, colorDarkRed, colorDarkGreen, colorDarkBlue),
                          Color.fromARGB(255, colorPrimaryRed, colorPrimaryGreen, colorPrimaryBlue),
                        ]
                    )
                ),
                child: Center(child: Text('Note in Dark Mode', style: TextStyle(fontSize: MyTheme.primaryFontSize),)),
              ),
            ),
          ),
        ),
        Container(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
              children: [
                colorTab('Primary', selectedColorTab == 0, () { setState(() {
                  selectedColorTab =0;
                });}),
                colorTab('Light Variant',selectedColorTab == 1, () { setState(() {
                  selectedColorTab =1;
                });}),
                colorTab('Dark Variant', selectedColorTab == 2, () { setState(() {
                  selectedColorTab =2;
                });})
              ]
          ),
        ),
        Container(height: 10,),
        showColorSliderAsPerSelectedTab(),
      ],
    );
  }

  Widget colorTab(String title, bool selected, Function() onTap) {
    return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: selected ? MyTheme.selectedColorScheme.primary : null
            ),
            child: Text(title, textAlign: TextAlign.center,
                style: TextStyle(fontSize: MyTheme.primaryFontSize, color: selected ? MyTheme.selectedColorScheme.onPrimary : null)),
          ),
        ));
  }

  Widget colorSlider(Color color, int value, Function(double d) onChange) {
    return Row(
      children: [
        Expanded(
            child: Slider(value: value.toDouble(), onChanged: onChange, max: 255, activeColor: color,)),
        Text(value.toString()),
        Container(width: 8.0,)
      ],
    );
  }

  Widget showColorSliderAsPerSelectedTab() {
    switch(selectedColorTab) {
      case 0 : return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          colorSlider(Colors.red, colorPrimaryRed, (value) {
            setState(() {
              colorPrimaryRed = value.toInt();
            });
          }),
          colorSlider(Colors.green, colorPrimaryGreen, (value) {
            setState(() {
              colorPrimaryGreen = value.toInt();
            });
          }),
          colorSlider(Colors.blue, colorPrimaryBlue, (value) {
            setState(() {
              colorPrimaryBlue = value.toInt();
            });
          })
        ],
      );
      case 1 : return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          colorSlider(Colors.red, colorLightRed, (value) {
            setState(() {
              colorLightRed = value.toInt();
            });
          }),
          colorSlider(Colors.green, colorLightGreen, (value) {
            setState(() {
              colorLightGreen = value.toInt();
            });
          }),
          colorSlider(Colors.blue, colorLightBlue, (value) {
            setState(() {
              colorLightBlue = value.toInt();
            });
          })
        ],
      );
      case 2 : return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          colorSlider(Colors.red, colorDarkRed, (value) {
            setState(() {
              colorDarkRed = value.toInt();
            });
          }),
          colorSlider(Colors.green, colorDarkGreen, (value) {
            setState(() {
              colorDarkGreen = value.toInt();
            });
          }),
          colorSlider(Colors.blue, colorDarkBlue, (value) {
            setState(() {
              colorDarkBlue = value.toInt();
            });
          })
        ],
      );
    }
    return const Text('Hello');
  }

  Color textColorAsBerBackground(int red, int green, int blue) {
    if((red + green + blue) < 420) {
      return Colors.white;
    }
    return Colors.black;
  }

  void saveSchemeAndExit() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(MyTheme.myColorPrimaryRedPref, colorPrimaryRed);
      prefs.setInt(MyTheme.myColorPrimaryGreenPref, colorPrimaryGreen);
      prefs.setInt(MyTheme.myColorPrimaryBluePref, colorPrimaryBlue);
      prefs.setInt(MyTheme.myColorLightRedPrefs, colorLightRed);
      prefs.setInt(MyTheme.myColorLightGreenPrefs, colorLightGreen);
      prefs.setInt(MyTheme.myColorLightBluePrefs, colorLightBlue);
      prefs.setInt(MyTheme.myColorDarkRedPrefs, colorDarkRed);
      prefs.setInt(MyTheme.myColorDarkGreenPrefs, colorDarkGreen);
      prefs.setInt(MyTheme.myColorDarkBluePrefs, colorDarkBlue);
      var primaryColor = Color.fromARGB(255, colorPrimaryRed, colorPrimaryGreen, colorPrimaryBlue);
      MyTheme.myCustomColor = MyColor(
          MyTheme.colorId0,
          primaryColor,
          MyTheme.createMaterialColor(primaryColor),
          Color.fromARGB(255, colorLightRed, colorLightGreen, colorLightBlue),
          Color.fromARGB(255, colorDarkRed, colorDarkGreen, colorDarkBlue),
          ((primaryColor.red + primaryColor.green + primaryColor.blue < 420)) ? Colors.white : Colors.black
      );
      MyTheme.selectedColorScheme = MyTheme.myCustomColor;
      MyApp.of(context)?.changeTheme(
          MyTheme.isDarkMode,
          MyTheme.selectedColorScheme.primary,
          MyTheme.selectedFonts);
      Navigator.pop(context);
    });
  }
}