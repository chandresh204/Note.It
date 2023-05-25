import 'package:flutter/material.dart';

import '../data/encrypt_decrypt.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../themes/theme.dart';
import '../ui/edit_page.dart';
import 'bottom_sheet_note_actions.dart';
import 'package:intl/intl.dart';

class NoteInList2 extends StatefulWidget {
  final List<Note> notesToShow;
  final NoteDao noteDao;
  final Function notifyParent;

  const NoteInList2(
      {Key? key,
      required this.notesToShow,
      required this.noteDao,
      required this.notifyParent})
      : super(key: key);

  @override
  State<NoteInList2> createState() => _NoteInList2State();
}

class _NoteInList2State extends State<NoteInList2> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List<Note?> _notesToAnimate = [];
  bool animating = false;
  bool stopAnimationNow = false;

  @override
  void initState() {
//    print('list2 init');
    super.initState();
    startAnimation();
  }

  @override
  void didUpdateWidget(NoteInList2 oldWidget) {
    cleanNotesAndRepopulate();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> cleanNotesAndRepopulate() async {
    while(animating) {
      await Future.delayed(const Duration(seconds: 1), () {
   //     print('animating : $animating');
      });
      stopAnimationNow = true;
    }
    stopAnimationNow = false;
//    print('animation finished,now cleaning notes');
    for (int i = 0; i < _notesToAnimate.length; i++) {
      listKey.currentState?.removeItem(0, (context, animation) {
        return Container();
      });
    }
    _notesToAnimate.clear();
  //  print('cleaning done');
    startAnimation();
  }

  Future<void> startAnimation() async {
    animating = true;
 //   print('animation started');
    for (int i = 0; i <= widget.notesToShow.length; i++) {
      if(stopAnimationNow) {
  //      print('stopping animation due to an update');
        break;
      }
      if (i == widget.notesToShow.length) {
        setState(() {
          listKey.currentState?.insertItem(_notesToAnimate.length);
          _notesToAnimate.add(null);
        });
      } else {
        await Future.delayed(
            Duration(
                milliseconds:
                    MyTheme.animationTiming ~/ widget.notesToShow.length), () {
          setState(() {
            listKey.currentState?.insertItem(_notesToAnimate.length,
                duration: Duration(milliseconds: MyTheme.animationTiming));
            try {
              _notesToAnimate.add(widget.notesToShow[i]);
            } catch(e) {
              _notesToAnimate.add(null);
            }
          });
        });
      }
    }
    animating = false;
 //   print('animation finished');
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return AnimatedList(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        key: listKey,
        initialItemCount: _notesToAnimate.length,
        itemBuilder: (ctx, index, animation) {
          return showSelectedAnimatedTile(ctx, index, animation);
        });
  }

  Widget showSelectedAnimatedTile(BuildContext ctx, int index, animation) {
    return MyTheme.getSelectedAnimatedWidget(
        context, index, animation, realNoteTile(index));
  }

  Widget realNoteTile(int i) {
    if (_notesToAnimate.isEmpty) {
      return Container();
    }
    Note? noteToShow;
    try {
      noteToShow = _notesToAnimate[i];
    } catch (e) {
      noteToShow = null;
    }
    if (noteToShow == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        //    print('Tapped ${notesToShow[i].note}');
        _gotoEditPage(noteToShow!.id, noteToShow.isEncrypt);
      },
      onLongPress: () {
        //     print('Long pressed');
        final sheet = BottomSheetNoteOptions(
            noteToShow!, context, widget.noteDao, widget.notifyParent);
        sheet.getUI();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(
                blurRadius: 10.0,
                color: Color(0x66000000),
                offset: Offset(0, 5)),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getTileColor()),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getNoteTitle(noteToShow),
              maxLines: 1,
              style: TextStyle(
                  fontSize: MyTheme.primaryFontSize,
                  color: _getOnVariantColor()),
            ),
            Container(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.add_box_outlined,
                          color: _getOnVariantColor()),
                      const Padding(padding: EdgeInsets.all(3.0)),
                      Text(
                        _formatInDate(noteToShow.id),
                        style: TextStyle(
                            fontSize: MyTheme.smallFontSize,
                            color: _getOnVariantColor()),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.check_box_outlined,
                        color: MyTheme.selectedColorScheme.onPrimary),
                    const Padding(padding: EdgeInsets.all(3.0)),
                    Text(
                      _formatInDate(noteToShow.editTime),
                      style: TextStyle(
                          fontSize: MyTheme.smallFontSize,
                          color: MyTheme.selectedColorScheme.onPrimary),
                      textAlign: TextAlign.start,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _gotoEditPage(int id, bool isEnc) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(editId: id, isEncrypted: isEnc);
    })).then((value) {
      widget.notifyParent.call();
//      print('back from edit');
    });
  }

  List<Color> _getTileColor() {
    List<Color> colors = [];
    if (MyTheme.isDarkMode) {
      colors.add(MyTheme.selectedColorScheme.primaryDark);
      colors.add(MyTheme.selectedColorScheme.primary);
    } else {
      colors.add(MyTheme.selectedColorScheme.primaryLight);
      colors.add(MyTheme.selectedColorScheme.primary);
    }
    return colors;
  }

  String _getNoteTitle(Note note) {
    if (note.isEncrypt) {
      return EncDec.getDecryptText(note.note);
    }
    return note.note;
  }

  String _formatInDate(int mills) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(mills);
    return DateFormat("dd-MMM kk:mm").format(dateTime);
  }

  Color _getOnVariantColor() {
    var variantColor = MyTheme.selectedColorScheme.primaryLight;
    if(MyTheme.isDarkMode) {
      variantColor = MyTheme.selectedColorScheme.primaryDark;
    }
    if ((variantColor.red + variantColor.green + variantColor.blue) < 420) {
      return Colors.white;
    }
    return Colors.black;
  }
}
