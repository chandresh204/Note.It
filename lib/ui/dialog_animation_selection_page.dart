import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/theme.dart';

class DialogAnimationSelectionPage extends StatefulWidget {
  const DialogAnimationSelectionPage({Key? key}) : super(key: key);

  @override
  State<DialogAnimationSelectionPage> createState() => _DialogAnimationSelectionPageState();
}

class _DialogAnimationSelectionPageState extends State<DialogAnimationSelectionPage>
    with SingleTickerProviderStateMixin {

  late AnimationController a1;
  @override
  void initState() {
    a1 = AnimationController(vsync: this,
        duration: Duration(milliseconds: MyTheme.animationTiming));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations'),
          backgroundColor: MyTheme.selectedColorScheme.primary,
          foregroundColor: MyTheme.selectedColorScheme.onPrimary),
      body: dialogAnimationMainScreen(),
    );
  }

  Widget dialogAnimationMainScreen() {
    a1.reset();
    a1.forward();
    return Column(
      children: [
        Expanded(
            child: MyTheme.getSelectedDialogTransition(a1, animatedDialogPreview())
        ),
        createAnimationTitleList(),
        Container(height: 20)
      ],
    );
  }

  Widget animatedDialogPreview() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This is a Dialog'),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: const Text('Okay'))
            ],
          ),
        ),
      ),
    );
  }

  Widget createAnimationTitleList() {
    ScrollController controller = ScrollController();
    return SizedBox(
      height: 50,
      child: ListView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          animationTitlesTile(MyTheme.dialogAnimationNone),
          animationTitlesTile(MyTheme.dialogAnimationSlideIn),
          animationTitlesTile(MyTheme.dialogAnimationSlideElastic),
          animationTitlesTile(MyTheme.dialogAnimationRotate),
          animationTitlesTile(MyTheme.dialogAnimationFade),
          animationTitlesTile(MyTheme.dialogAnimationZoomIn),
          animationTitlesTile(MyTheme.dialogAnimationPop),
          animationTitlesTile(MyTheme.dialogAnimationZoomOut),
          animationTitlesTile(MyTheme.dialogAnimationLanding),
        ],
      ),
    );
  }

  Widget animationTitlesTile(String name) {
    bool selected = MyTheme.selectedDialogAnimation == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          MyTheme.selectedDialogAnimation = name;
          //  startAnimation();
          saveSelectedAnimation();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: selected ? MyTheme.selectedColorScheme.primary : null,
        ),
        child: selected ? Row(
          children: [
            Icon(Icons.check, color: MyTheme.selectedColorScheme.onPrimary),
            Container(width: 5),
            Text(name, style: TextStyle(fontSize: MyTheme.primaryFontSize, color: MyTheme.selectedColorScheme.onPrimary))
          ],
        ) : Center(child: Text(name, style: TextStyle(fontSize: MyTheme.primaryFontSize))),
      ),
    );
  }

  void saveSelectedAnimation() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(MyTheme.animationDialogPrefString, MyTheme.selectedDialogAnimation);
    });
  }
}