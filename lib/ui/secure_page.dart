import 'package:flutter/material.dart';
import '../themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custome_widgets/note_in_list2.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../data/note_database.dart';
import '../main.dart';
import 'edit_page.dart';

class SecurePage extends StatefulWidget {
  SecurePage({Key? key}) : super(key: key);
  NoteDao? noteDao;
  @override
  State<SecurePage> createState() => _SecurePageState();
}

class _SecurePageState extends State<SecurePage> {

  List<Note> allNotes = [];

  _showAllNotes() async {
    if (widget.noteDao == null) {
      final database = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
      database.build().then((database) {
        widget.noteDao = database.noteDao;
        //     print('noteDao created');
        widget.noteDao?.getAllNotes(true).then((notes) {
          setState(() {
            allNotes = notes;
            //        print('State updated');
          });
        });
      });
    } else {
      //    print('noteDao already available');
      widget.noteDao?.getAllNotes(true).then((notes) {
        setState(() {
          allNotes = notes;
          //       print('State updated');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note.it - Secure'),
        backgroundColor: MyTheme.selectedColorScheme.primary,
        actions: [
          IconButton(onPressed: () {
            _showPasswordChangeDialog2(0);
          }, icon: const Icon(Icons.lock_reset)),
          const Padding(padding: EdgeInsets.all(4)),
        ],),
      body: Center(
        child: getListUI(allNotes),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyTheme.selectedColorScheme.primary,
        onPressed: () {
          _gotoEditPage(-1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void notifyMe() {
    _showAllNotes();
  }

  _gotoEditPage(int editId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(editId: editId, isEncrypted: true);
    })).then((value) {
      _showAllNotes();
    });
  }

  Widget getListUI(List<Note> notes) {
    if (widget.noteDao != null
    ) {
      // final ui = NoteInList(notes, context, widget.noteDao!, notifyMe);
      // return ui.getListUI();
      return NoteInList2(notesToShow: notes, noteDao: widget.noteDao!, notifyParent: notifyMe);
    }
    _showAllNotes();
    return const Text('Loading...');
  }

  _showPasswordChangeDialog2(int step) {
    showGeneralDialog(
        context: context,
        pageBuilder: (ctx, a1, a2) => Container(),
        transitionBuilder: (ctx, a1, a2,child) {
          return MyTheme.getSelectedDialogTransition(a1, _passwordChangeDialogChild(step));
        },
        transitionDuration: Duration(milliseconds: (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt())
    );
  }

  Widget _passwordChangeDialogChild(int step) {
    TextEditingController controller = TextEditingController();
    switch(step) {
      case 0:
        {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Change Password',
                      style: TextStyle(fontSize: MyTheme.largeFontSize),),
                    const SizedBox(height: 20),
                    Text('Please enter current password to continue',
                        style: TextStyle(fontSize: MyTheme.primaryFontSize), textAlign: TextAlign.center),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: TextStyle(color: MyTheme.getTextButtonColor()),)),
                        const SizedBox(width: 40),
                        ElevatedButton(onPressed: () {
                          if (controller.text == MyTheme.securePassword) {
                            Navigator.pop(context);
                            _showPasswordChangeDialog2(1);
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    'Wrong Password, Please try again'))
                            );
                          }
                        }, child: const Text('Next')),
                      ],
                    ),
                  ]
              ),
            ),
          );
        }
      case 1:
        {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Change Password',
                    style: TextStyle(fontSize: MyTheme.largeFontSize),),
                  const SizedBox(height: 20),
                  Text('Please enter new Password',
                      style: TextStyle(fontSize: MyTheme.primaryFontSize), textAlign: TextAlign.center),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel', style: TextStyle(color: MyTheme.getTextButtonColor()),)),
                      const SizedBox(width: 20),
                      ElevatedButton(onPressed: () {
                        if (controller.text.isNotEmpty) {
                          MyTheme.securePassword = controller.text;
                          Navigator.pop(context);
                          _showPasswordChangeDialog2(2);
                        }
                      }, child: const Text('Next')),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      case 2:
        {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Change Password',
                    style: TextStyle(fontSize: MyTheme.largeFontSize),),
                  const SizedBox(height: 20),
                  Text('Please enter new Password again',
                    style: TextStyle(fontSize: MyTheme.primaryFontSize), textAlign: TextAlign.center,),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel', style: TextStyle(color: MyTheme.getTextButtonColor()))),
                      const SizedBox(width: 20),
                      ElevatedButton(onPressed: () {
                        if (controller.text.isNotEmpty) {
                          if (controller.text == MyTheme.securePassword) {
                            SharedPreferences.getInstance().then((value) {
                              value.setString(MyTheme.securePasswordPrefString,
                                  MyTheme.securePassword);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      'Password changed successfully'))
                              );
                            });
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            SharedPreferences.getInstance().then((value) {
                              final oldPassword = value.getString(
                                  MyTheme.securePasswordPrefString);
                              if (oldPassword != null) {
                                MyTheme.securePassword = oldPassword;
                              }
                              _showPasswordChangeDialog2(1);
                            });
                          }
                        }
                      }, child: const Text('Next')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    }
    return Container();
  }
}