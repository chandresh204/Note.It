import 'package:flutter/material.dart';
import 'package:note_it/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custome_widgets/note_in_list.dart';
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
            _showPasswordChangeDialog(0);
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
      final ui = NoteInList(notes, context, widget.noteDao!, notifyMe);
      return ui.getListUI();
    }
    _showAllNotes();
    return const Text('Loading...');
  }

  _showPasswordChangeDialog(int step) {
    TextEditingController controller = TextEditingController();
    showDialog(context: context,
        builder: (context) {
      switch(step) {
        case 0:
          {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children : [
                      Text('Change Password', style: TextStyle(fontSize: MyTheme.largeFontSize),),
                      Text('Please enter current password to continue', style: TextStyle(fontSize: MyTheme.primaryFontSize),),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: controller,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                      ElevatedButton(onPressed: () {
                        if (controller.text == MyTheme.securePassword) {
                          Navigator.pop(context);
                          _showPasswordChangeDialog(1);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong Password, Please try again'))
                          );
                        }
                      }, child: const Text('Next')),
                    ]
                ),
              ),
            );
          }
        case 1: {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Change Password', style: TextStyle(fontSize: MyTheme.largeFontSize),),
                    Text('Please enter new Password', style: TextStyle(fontSize: MyTheme.primaryFontSize),),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                    ElevatedButton(onPressed: () {
                      if (controller.text.isNotEmpty) {
                        MyTheme.securePassword = controller.text;
                        Navigator.pop(context);
                        _showPasswordChangeDialog(2);
                      }
                    }, child: const Text('Next')),
                  ],
                ),
              ),
            );
        }
        case 2: {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Change Password', style: TextStyle(fontSize: MyTheme.largeFontSize),),
                  Text('Please enter new Password again', style: TextStyle(fontSize: MyTheme.primaryFontSize),),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  ElevatedButton(onPressed: () {
                    if (controller.text.isNotEmpty) {
                      if (controller.text == MyTheme.securePassword) {
                        SharedPreferences.getInstance().then((value) {
                          value.setString(MyTheme.securePasswordPrefString, MyTheme.securePassword);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password changed successfully'))
                          );
                        });
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        SharedPreferences.getInstance().then((value) {
                          final oldPassword = value.getString(MyTheme.securePasswordPrefString);
                          if (oldPassword != null) {
                            MyTheme.securePassword = oldPassword;
                          }
                          _showPasswordChangeDialog(1);
                        });
                      }
                    }
                  }, child: const Text('Next')),
                ],
              ),
            ),
          );
        }
        default:
          {
            return const Text('invalid step');
          }
      }
    });
  }
}
