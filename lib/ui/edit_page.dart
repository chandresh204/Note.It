import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_text/view/interactive_text.dart';
import 'package:note_it/custome_widgets/bottom_sheet_url_open.dart';
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

class _EditPageState extends State<EditPage> with SingleTickerProviderStateMixin {

  String textToEdit = "";
  bool inReadOnlyMode = false;
  late AnimationController aController;
  int animationDuration = 500;

  @override
  void initState() {
    super.initState();
    aController = AnimationController(vsync: this, duration: Duration(milliseconds: animationDuration));
    if (widget.editId > 0) {
      _getFromDatabase();
      inReadOnlyMode = true;
    }
    aController.forward();
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

  Future<bool> _onWillPop() async {
    if(inReadOnlyMode == false && _textEditingController.text.isNotEmpty) {
      showGeneralDialog(context: context,
          pageBuilder: (ctx, a1, a2) => Container(),
          transitionBuilder: (ctx, a1, a2, child) {
            return MyTheme.getSelectedDialogTransition(a1, _backPressAlertDialog(ctx));
          },
          transitionDuration: Duration(milliseconds: (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt())
      );
      return false;
    } else {
      Navigator.pop(context, true);
      return true;
    }
  }

  /* Future<bool> _onWillPop() async{
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
        }));
  } */

  Widget _backPressAlertDialog(BuildContext ctx) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
      ),
      title: const Text('Save Changes?'),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(ctx, true);
          Navigator.pop(ctx, true);
        }, child: const Text('Discard')),
        ElevatedButton(onPressed: () {
          _saveNoteAndExit(widget.isEncrypted);
          Navigator.pop(ctx, true);
        }, child: const Text('Save')),
        ElevatedButton(onPressed: () {
          Navigator.pop(ctx, false);
        }, child: const Text('Cancel')),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Widget _getEditingUI() {
    Color appBarForeground = MyTheme.selectedColorScheme.onPrimary;
    aController.forward();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _getBackgroundColor(),
        appBar: AppBar(
          foregroundColor: appBarForeground,
          backgroundColor: MyTheme.selectedColorScheme.primary,
          title: const Text(
            'Note.it - Editor',),
          actions: [
            PopupMenuButton(
                itemBuilder: (ctx) {
                  return [
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
                  ];
                }),
            Container(width: 10,)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SizeTransition(
            axisAlignment: -1,
            sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: aController, curve: Curves.easeInExpo)
            ),
            child: Column(
              children: [
                Expanded(
                  child:  TextField(
                    style: TextStyle(fontSize: MyTheme.primaryFontSize, color: _getTextColor()),
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
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: appBarForeground,
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
    ScrollController controller = ScrollController();
    Color appBarForeground = MyTheme.selectedColorScheme.onPrimary;
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        foregroundColor: appBarForeground,
        backgroundColor: MyTheme.selectedColorScheme.basicColor,
        title: const Text('Note.It - Read Only'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
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
              ];
            },
          ),
          Container(width: 10,)
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizeTransition(
          axisAlignment: -1,
          sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: aController, curve: Curves.easeInExpo)),
          child: ListView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                InteractiveText(text: textToEdit, textStyle: TextStyle(fontSize: MyTheme.primaryFontSize, color: _getTextColor()),
                  linkStyle: TextStyle(color: MyTheme.selectedHyperlinkColor.basicColor, fontSize: MyTheme.primaryFontSize),
                  onUrlClick: (url) {
                    final dialog = BottomSheetUrlOpen(url: url, context: context);
                    dialog.getUi();
                  }),
            /*    Text(
                  textToEdit,
                  style: TextStyle(fontSize: MyTheme.primaryFontSize, color: _getTextColor()),
                ), */
                const SizedBox(height: 100)
              ]
          ),
        ),
      ),
      floatingActionButton: RotationTransition(
        turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: aController, curve: Curves.bounceOut)
        ),
        child: FloatingActionButton(
          foregroundColor: appBarForeground,
          onPressed: () {
            aController.reverse();
            Future.delayed(Duration(milliseconds: animationDuration), () {
              setState(() {
                inReadOnlyMode = false;
                _textEditingController.text = textToEdit;
              });
            });
          },
          backgroundColor: MyTheme.selectedColorScheme.primary,
          child: const Icon(Icons.edit),
        ),
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

  Color _getTextColor() {
    Color bgColor = _getBackgroundColor();
    if ((bgColor.red + bgColor.green + bgColor.blue) < 420) {
      return Colors.white;
    }
    return Colors.black;
  }
}