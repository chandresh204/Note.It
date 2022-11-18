import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/encrypt_decrypt.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../themes/theme.dart';
import '../ui/edit_page.dart';
import 'bottom_sheet_note_actions.dart';

class NoteInList {
  final List<Note> notesToShow;
  final BuildContext context;
  final NoteDao noteDao;
  final Function notifyParent;
  NoteInList(this.notesToShow, this.context, this.noteDao, this.notifyParent);

  Widget getListUI() {
    return ListView.builder(
        itemCount: notesToShow.length + 1,
        itemBuilder: (context, i) {
          if (i == notesToShow.length) {
            return Container(height: 100,);
          }
          if (notesToShow.isEmpty) {
            return Container();
          }
          return GestureDetector(
            onTap: () {
          //    print('Tapped ${notesToShow[i].note}');
              _gotoEditPage(notesToShow[i].id, notesToShow[i].isEncrypt);
            },
            onLongPress: () {
         //     print('Long pressed');
              final sheet = BottomSheetNoteOptions(notesToShow[i], context, noteDao, notifyParent);
              sheet.getUI();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(8),
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(blurRadius: 10.0, color: Color(0x66000000), offset: Offset(0,5)),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getTileColor()
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getNoteTitle(notesToShow[i]),
                    maxLines: 1,
                    style: TextStyle(fontSize: MyTheme.primaryFontSize),
                  ),
                  Container(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.add_box_outlined),
                            const Padding(padding: EdgeInsets.all(3.0)),
                            Text(
                              _formatInDate(notesToShow[i].id),
                              style: TextStyle(fontSize: MyTheme.smallFontSize),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_box_outlined),
                          const Padding(padding: EdgeInsets.all(3.0)),
                          Text(
                            _formatInDate(notesToShow[i].editTime),
                            style: TextStyle(fontSize: MyTheme.smallFontSize),
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
        });
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

  _gotoEditPage(int id, bool isEnc) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(editId: id, isEncrypted: isEnc);
    })).then((value) {
      notifyParent.call();
//      print('back from edit');
    });
  }

  List<Color> _getTileColor() {
    List<Color> colors = [];
    if(MyTheme.isDarkMode) {
      colors.add(MyTheme.selectedColorScheme.primaryDark);
      colors.add(MyTheme.selectedColorScheme.primary);
    } else {
      colors.add(MyTheme.selectedColorScheme.primaryLight);
      colors.add(MyTheme.selectedColorScheme.primary);
    }
    return colors;
  }
}
