import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../data/encrypt_decrypt.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../data/note_database.dart';
import '../main.dart';
import '../themes/theme.dart';

class EditPage extends StatefulWidget {
  final int editId;
  final bool isEncrypted;
  NoteDao? noteDao;
  EditPage({ Key? key, required this.editId,required this.isEncrypted}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String textToEdit = "";
  bool inReadOnlyMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.editId > 0) {
      _getFromDatabase();
      inReadOnlyMode = true;
    }
  }

  _initializeDatabase() {
    final database = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
    database.build().then((value) {
      widget.noteDao = value.noteDao;
  //    print('noteDao now available in edit mode');
    });
  }

  _getFromDatabase() {
    if (widget.noteDao == null) {
   //   print('noteDao not available, getting');
      final database = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
      database.build().then((value) {
        widget.noteDao = value.noteDao;
        widget.noteDao?.getNoteFromId(widget.editId).then((note) {
          if (note != null) {
            setState(() {
              if (note.isEncrypt) {
                textToEdit = EncDec.getDecryptText(note.note);
              } else {
                textToEdit = note.note;
              }
            });
          }
        });
      });
    } else {
      widget.noteDao?.getNoteFromId(widget.editId).then((note) {
        if (note != null) {
          setState(() {
            if (note.isEncrypt) {
              textToEdit = EncDec.getDecryptText(note.note);
            } else {
              textToEdit = note.note;
            }
          });
        }
      });
    }
  }

  _saveToDatabase(Note note) {
    widget.noteDao?.insertOneNote(note);
 //   print('new note inserted or updated');
  }

  Future<bool> _onWillPop() async{
    return (await showDialog(
        context: context,
        builder: (context) {
          if (inReadOnlyMode == false && _textEditingController.text.isNotEmpty) {
            return AlertDialog(
              title: const Text('Save Changes?'),
              actions: [
                ElevatedButton(onPressed: () {
                  Navigator.pop(context,true);
                }, child: const Text('Discard')),
                ElevatedButton(onPressed: () {
                  _saveNoteAndExit(widget.isEncrypted);
                  Navigator.pop(context, true);
                }, child: const Text('Save')),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context, false);
                }, child: const Text('Cancel')),
              ],
            );
          } else {
            Navigator.pop(context,true);
            return const Text('Exit');
          }
        })) ?? false;
  }

  Widget _getEditingUI() {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _getBackgroundColor(),
        appBar: AppBar(
          backgroundColor: MyTheme.selectedColorScheme.primary,
            title: const Text(
          'Note.it',),
          actions: [
            IconButton(onPressed: () {
              showMenu(
                  context: context,
                  position: RelativeRect.fromDirectional(
                      textDirection: TextDirection.ltr,
                      start: 1500,
                      top: 50,
                      end: 0,
                      bottom: 0),
                  items: [
                    PopupMenuItem(
                        child: const Text('Paste'),
                        onTap: () {
                          Clipboard.getData('text/plain').then((cData) {
                            if (cData?.text != null) {
                              _textEditingController.text = cData!.text!;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Clipboard empty'))
                              );
                            }
                          }
                          );
                        },),
                    PopupMenuItem(
                      child: const Text('Copy all'),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _textEditingController.text)).then(
                            (c) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied to Clipboard'))
                              );
                            }
                        );
                      },),
                    PopupMenuItem(
                      child: const Text('Share'),
                      onTap: () {
                        Share.share(_textEditingController.text);
                      },),
                    PopupMenuItem(
                      child: const Text('Close without save'),
                      onTap: () {
                        Navigator.pop(context);
                      },),
                    PopupMenuItem(
                      child: const Text('Save and close'),
                      onTap: () {
                        _saveNoteAndExit(widget.isEncrypted);
                      },),
                  ]
              );
            }, icon: const Icon(Icons.menu)),
            Container(width: 10,)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child:  TextField(
                  style: TextStyle(fontSize: MyTheme.primaryFontSize),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  controller: _textEditingController,
                ),
              ),
              Container(
                height: 80,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveNoteAndExit(widget.isEncrypted);
          },
          backgroundColor: MyTheme.selectedColorScheme.primary,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  _saveNoteAndExit(bool isEnc) {
    final thisTime = DateTime.now().millisecondsSinceEpoch;
    if (widget.editId > 0) {
      if (widget.isEncrypted) {
        var updatedNote = Note(widget.editId,
            EncDec.getEncryptedText(_textEditingController.text), thisTime, true);
        _saveToDatabase(updatedNote);
      } else {
        var updatedNote = Note(widget.editId,
          _textEditingController.text, thisTime, false);
        _saveToDatabase(updatedNote);
      }
    } else {
      if (widget.isEncrypted) {
        var newNote = Note(thisTime,
            EncDec.getEncryptedText(_textEditingController.text),
          thisTime,
          true);
        _saveToDatabase(newNote);
      } else {
        var newNote = Note(thisTime, _textEditingController.text, thisTime, false);
        _saveToDatabase(newNote);
      }
    }
    Navigator.pop(context);
  }

  Widget _getReadOnlyUI() {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: MyTheme.selectedColorScheme.basicColor,
        title: const Text('View/Edit Note'),
        actions: [
          IconButton(
              onPressed: () {
                showMenu(
                    context: context, 
                    position: RelativeRect.fromDirectional(
                        textDirection: TextDirection.ltr,
                        start: 1500,
                        top: 50,
                        end: 0,
                        bottom: 0),
                    items: [
                      PopupMenuItem(
                          child: const Text('Copy all'),
                        onTap: () {
                            Clipboard.setData(
                               ClipboardData(text: textToEdit));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard'))
                            );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Share'),
                        onTap: () {
                          Share.share(textToEdit);
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          setState(() {
                            inReadOnlyMode = false;
                            _textEditingController.text = textToEdit;
                          });
                        },
                      ),
                    ]);
              },
              icon: const Icon(Icons.menu)),
          Container(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
     child: Text(
       textToEdit,
       style: TextStyle(fontSize: MyTheme.primaryFontSize),
     ),
     /*   child: Text(
          textToEdit,
          style: TextStyle(
            fontSize: MyTheme.primaryFontSize,
          ),
        ),  */
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            inReadOnlyMode = false;
            _textEditingController.text = textToEdit;
          });
        },
        backgroundColor: MyTheme.selectedColorScheme.primary,
        child: const Icon(Icons.edit),
      ),
    );
  }

  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _initializeDatabase();
    if (inReadOnlyMode) {
      return _getReadOnlyUI();
    }
    return _getEditingUI();
  }

  Color _getBackgroundColor() {
    if (MyTheme.isDarkMode) {
      return MyTheme.selectedColorScheme.primaryDark;
    }
    return MyTheme.selectedColorScheme.primaryLight;
  }
}
