import 'package:flutter/material.dart';
import '../themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimationSelectionPage extends StatefulWidget {
  const AnimationSelectionPage({Key? key}) : super(key: key);

  @override
  State<AnimationSelectionPage> createState() => _AnimationSelectionPageState();
}

class _AnimationSelectionPageState extends State<AnimationSelectionPage> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<int> _sampleList = [];
  bool animating = false;
  int _sampleCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations'),
          backgroundColor: MyTheme.selectedColorScheme.primary,
          foregroundColor: MyTheme.selectedColorScheme.onPrimary),
      body: animationMainScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  Future<void> startAnimation() async {
    if(animating) return;
    animating = true;
    _sampleList.clear();
    for(int i=0; i<4; i++) {
      _listKey.currentState?.removeItem(0, (ctx, animation) {
        return Container();
      });
    }
    for(int i=0; i<4; i++) {
      await Future.delayed(Duration(milliseconds: MyTheme.animationTiming~/4), () {
        _listKey.currentState?.insertItem(_sampleList.length, duration: Duration(milliseconds: MyTheme.animationTiming));
        _sampleList.add(_sampleCount);
        _sampleCount++;
      });
    }
    animating = false;
  }

  Widget animationMainScreen() {
    return Column(
      children: [
        Expanded(
            child: animatedListPreview()
        ),
        createAnimationTitleList(),
        Container(height: 20)
      ],
    );
  }

  Widget animatedListPreview() {
    return AnimatedList(
      key: _listKey,
      itemBuilder: (ctx, index, animation) {
        return animatedListTile(ctx, index, animation);
      },
    );
  }

  Widget animatedListTile(BuildContext context, int index, animation) {
    return MyTheme.getSelectedAnimatedWidget(context, index, animation, sampleListTile(index));
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
          animationTitlesTile(MyTheme.animationNone),
          animationTitlesTile(MyTheme.animationSlideIn),
          animationTitlesTile(MyTheme.animationSlideBounce),
          animationTitlesTile(MyTheme.animationSlideElastic),
          animationTitlesTile(MyTheme.animationFade),
          animationTitlesTile(MyTheme.animationZoom),
          animationTitlesTile(MyTheme.animationPop),
          animationTitlesTile(MyTheme.animationZoomOut),
          animationTitlesTile(MyTheme.animationFallDown),
          animationTitlesTile(MyTheme.animationFlying),
        ],
      ),
    );
  }

  Widget sampleListTile(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: MyTheme.selectedColorScheme.primary,
        child: Center(child: Text('Note $index', style: TextStyle(fontSize: MyTheme.largeFontSize, color: MyTheme.selectedColorScheme.onPrimary))),
      ),
    );
  }

  Widget animationTitlesTile(String name) {
    bool selected = MyTheme.selectedAnimation == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          MyTheme.selectedAnimation = name;
          startAnimation();
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

  saveSelectedAnimation() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(MyTheme.animationPrefString, MyTheme.selectedAnimation);
    });
  }
}