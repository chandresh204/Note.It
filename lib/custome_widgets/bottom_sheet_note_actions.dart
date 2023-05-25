import 'package:flutter/material.dart';
import 'package:note_it/data/encrypt_decrypt.dart';
import 'package:share_plus/share_plus.dart';

import '../data/note.dart';
import '../data/note_dao.dart';
import '../themes/theme.dart';

class BottomSheetNoteOptions {
  final Note note;
  final BuildContext context;
  final NoteDao noteDao;
  final Function notifyParent;
  BottomSheetNoteOptions(
      this.note, this.context, this.noteDao, this.notifyParent);

  getUI() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.center,
                children: [
              Text(
                _decodeText(note),
                maxLines: 4,
                style: TextStyle(fontSize: MyTheme.primaryFontSize),
              ),
              Row(
                children: [
                  //-------------------------------------------------delete button
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getDeleteUI();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.white,),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Delete', style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  )),

                  ///------------------------------------------------ export Button

                  //------------------------------------------------- Share Button
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Share.share(note.note);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.share),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Share'),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ]),
          );
        });
  }

  getDeleteUI() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Sure To delete this?',
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(_decodeText(note), maxLines: 2,),
                  ],
                ),
                Row(
                  children: [
                    //---------------------------------------------confirm delete
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red),
                          ),
                          onPressed: () {
                            noteDao.deleteNote(note).then((value) {
                              Navigator.pop(context);
                              notifyParent();
                            });
                          },
                          child: Row(children: const [
                            Icon(Icons.check, color: Colors.white),
                            Padding(padding: EdgeInsets.all(4.0)),
                            Text('Delete', style: TextStyle(color: Colors.white),),
                          ]),
                        ),
                      ),
                    ),
                    //-----------------------------------------------cancel delete
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(children: const [
                            Icon(Icons.cancel_outlined),
                            Padding(padding: EdgeInsets.all(4.0)),
                            Text('Cancel'),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  String _decodeText(Note note) {
    if (note.isEncrypt) {
      return EncDec.getDecryptText(note.note);
    }
    return note.note;
  }
}
