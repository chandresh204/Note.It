import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../ui/settings_page.dart';

import '../custome_widgets/dialog_enter_secure_room.dart';
import '../custome_widgets/note_in_list2.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../data/note_database.dart';
import '../main.dart';
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Note> allNotes = [];
  List<Note> searchedNotes = [];
  bool inSearchMode = false;
  String searchQuery = '';
  late AnimationController aController;
  late Animation<double> iconAnimation;
  var searchTController = TextEditingController();
  bool isLoadingSearchResults = false;

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
    aController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: aController, curve: Curves.decelerate));
    aController.forward();
    _showAllNotes();
  }

  void notifiyMe() {
    _showAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Center(
          child: isLoadingSearchResults
              ? CircularProgressIndicator(
              color: MyTheme.selectedColorScheme.primary)
              : (inSearchMode
              ? (searchedNotes.isEmpty
              ? Text('No Result Found',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MyTheme.largeFontSize))
              : getListUI(searchedNotes))
              : getListUI(allNotes))),
    /*  floatingActionButton: ScaleTransition(
        scale: iconAnimation,
        child: FloatingActionButton(
          backgroundColor: MyTheme.selectedColorScheme.primary,
          foregroundColor: MyTheme.selectedColorScheme.onPrimary,
          onPressed: () {
            _gotoEditPage(-1);
          },
          child: const Icon(Icons.add),
        ), */
      floatingActionButton: RotationTransition(
        turns: iconAnimation,
        child: FloatingActionButton(
        backgroundColor: MyTheme.selectedColorScheme.primary,
        foregroundColor: MyTheme.selectedColorScheme.onPrimary,
        onPressed: () {
        _gotoEditPage(-1);
        },
        child: const Icon(Icons.add),
      ),
      )
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
    if (widget.noteDao != null) {
      //   final ui = NoteInList(notes, context, widget.noteDao!, notifiyMe);
      //    return ui.getListUI();
      //  print('list2 getting ui');
      final ui = NoteInList2(
          notesToShow: notes,
          noteDao: widget.noteDao!,
          notifyParent: notifiyMe);
      return ui;
    }
    _showAllNotes();
    return const Text('Loading...');
  }

  PreferredSizeWidget getAppBar() {
    if (inSearchMode) {
      var foregroundColor = MyTheme.selectedColorScheme.onPrimary;
      return AppBar(
        backgroundColor: MyTheme.selectedColorScheme.primary,
        foregroundColor: foregroundColor,
        title: TextField(
            controller: searchTController,
            onChanged: (query) {
              _updateSearchResult(query);
              searchQuery = query;
            },
            cursorColor: foregroundColor,
            style: TextStyle(fontSize: MyTheme.largeFontSize,
                color: foregroundColor),
            decoration: const InputDecoration.collapsed(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
            )
        ),
        leading: BackButton(
          onPressed: () {
            //   searchTController.clear();
            setState(() {
              inSearchMode = false;
            });
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                searchTController.clear();
                searchQuery = '';
                _updateSearchResult('');
              },
              icon: const Icon(Icons.close))
        ],
      );
    }
    return AppBar(
      backgroundColor: MyTheme.selectedColorScheme.primary,
      foregroundColor: MyTheme.selectedColorScheme.onPrimary,
      title: const Text('Note.it'),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyTheme.selectedColorScheme.basicColor,
          statusBarBrightness: Brightness.light),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                inSearchMode = true;
              });
              /*   if (widget.noteDao != null) {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(allNotes, context, widget.noteDao!, notifiyMe));
          } else {
            const Text('note dao null');
            //       print('note dao is null search not possible');
          }  */
            },
            icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () {
              if (MyTheme.securePassword.isEmpty) {
                //  aController.forward();
                //          DialogEnterSecure(context).getFirstEntryDialog(aController);
                DialogEnterSecure(context).getFirstEntryDialog2();
              } else {
                DialogEnterSecure(context).getAskPasswordDialog2();
              }
            },
            icon: const Icon(Icons.lock)),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            icon: const Icon(Icons.settings)),
        const Padding(padding: EdgeInsets.all(8))
      ],
    );
  }

  Future<void> _updateSearchResult(String query) async {
    setState(() {
      isLoadingSearchResults = true;
    });
    for (int i = 0; i < 1; i++) {
      await Future.delayed(const Duration(seconds: 1), () {});
    }
    if (query == searchQuery) {
      searchedNotes.clear();
      var lowerQuery = query.toLowerCase();
      for (var note in allNotes) {
        if (note.note.toLowerCase().contains(lowerQuery)) {
          searchedNotes.add(note);
        }
      }
      setState(() {
        isLoadingSearchResults = false;
      });
    }
  }
}