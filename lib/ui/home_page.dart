import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:note_it/ui/settings_page.dart';

import '../custome_widgets/dialog_enter_secure_room.dart';
import '../custome_widgets/note_in_list.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../data/note_database.dart';
import '../main.dart';
import '../other/custom_delegate.dart';
import '../themes/theme.dart';
import 'edit_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  NoteDao? noteDao;

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> allNotes = [];

  _showAllNotes() async {
    if (widget.noteDao == null) {
      final database = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
      database.build().then((database) {
        widget.noteDao = database.noteDao;
     //   print('noteDao created');
        widget.noteDao?.getAllNotes(false).then((notes) {
          setState(() {
            allNotes = notes;
       //     print('State updated');
          });
        });
      });
    } else {
//      print('noteDao already available');
      widget.noteDao?.getAllNotes(false).then((notes) {
        setState(() {
          allNotes = notes;
  //        print('State updated');
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showAllNotes();
  }

  void notifiyMe() {
    _showAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.selectedColorScheme.primary,
        title: const Text('Note.it'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyTheme.selectedColorScheme.basicColor,
          statusBarBrightness: Brightness.light
        ),
        actions: [
          IconButton(onPressed: () {
            if (widget.noteDao != null) {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(allNotes, context, widget.noteDao!, notifiyMe));
            } else {
              const Text('note dao null');
       //       print('note dao is null search not possible');
            }
          }, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {
            if (MyTheme.securePassword.isEmpty) {
              DialogEnterSecure(context).getFirstEntryDialog();
            } else {
              DialogEnterSecure(context).getAskPasswordDialog();
            }
          },
              icon: const Icon(Icons.lock)),
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
          }, icon: const Icon(Icons.settings)),
          const Padding(padding: EdgeInsets.all(8))
        ],
      ),
      body: Center(
        child: getListUI(allNotes)
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

  _gotoEditPage(int editId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(editId: editId, isEncrypted: false);
    })).then((value) {
      _showAllNotes();
    });
  }

  Widget getListUI(List<Note> notes) {
    if (widget.noteDao != null
    ) {
      final ui = NoteInList(notes, context, widget.noteDao!, notifiyMe);
      return ui.getListUI();
    }
    _showAllNotes();
    return const Text('Loading...');
  }

}
