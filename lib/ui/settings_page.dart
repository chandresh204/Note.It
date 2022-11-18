import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_it/ui/backup_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import '../custome_widgets/bottom_sheet_font_selection.dart';
import '../data/encrypt_decrypt.dart';
import '../data/note.dart';
import '../data/note_dao.dart';
import '../data/note_database.dart';
import '../main.dart';
import '../themes/color.dart';
import '../themes/theme.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  NoteDao? noteDao;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: MyTheme.selectedColorScheme.primary,
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Back & Restore',
              style: TextStyle(fontSize: MyTheme.largeFontSize),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
            //            prepareNotesInJson();
                        // adding dialog to show information about backup
                        showDialog(context: context, builder: (ctx) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text('Backup information goes here'),
                                  ElevatedButton(onPressed: () {
                                    prepareNotesInJson();
                                  },
                                      child: const Text('Next'))
                                ]
                              ),
                            ),
                          );
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                          return const BackupPage();
                        }));
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.backup),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Backup Notes')
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
                        _restoreNotes();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.restore),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Restore Notes')
                        ],
                      )),
                ),
              ],
            ),
            _getDivider(),
            Text(
              'App Color',
              style: TextStyle(fontSize: MyTheme.largeFontSize),
            ),
            Flexible(
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6),
                children: [
                  _getColorPlates(MyTheme.myColorDefault),
                  _getColorPlates(MyTheme.myColorRed),
                  _getColorPlates(MyTheme.myColorGreen),
                  _getColorPlates(MyTheme.myColorBlue),
                  _getColorPlates(MyTheme.myColorGrey),
                  _getColorPlates(MyTheme.myColorBlue1),
                  _getColorPlates(MyTheme.myColorPink),
                  _getColorPlates(MyTheme.myColorPurple),
                  _getColorPlates(MyTheme.myColorGreenLight),
                  _getColorPlates(MyTheme.myColorBlack),
                ],
              ),
            ),
            _getDivider(),
            Row(
              children: [
                Expanded(
                    child: Text(
                  'Font',
                  style: TextStyle(fontSize: MyTheme.largeFontSize),
                )),
                GestureDetector(
                    onTap: () {
                      BottomSheetFontSelection(context, saveSelectedFont).getUI();
                    },
                    child: Text(MyTheme.selectedFonts, style: TextStyle(fontSize: MyTheme.primaryFontSize),)),
              ],
            ),
            _getDivider(),
            Text(
              'Text Size',
              style: TextStyle(fontSize: MyTheme.largeFontSize),
            ),
            Slider(
                min: 15,
                max: 25,
                value: MyTheme.primaryFontSize,
                onChanged: (newValue) {
                  setState(() {
                    MyTheme.setAllFonts(newValue);
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setDouble(
                          MyTheme.textSizePreferenceString, newValue);
                    });
                  });
                }),
            _getDivider(),
            ListTile(
              trailing: Switch(
                activeColor: MyTheme.selectedColorScheme.basicColor,
                onChanged: (checked) {
                  setState(() {
                    MyTheme.isDarkMode = checked;
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setBool(MyTheme.isDarkModePrefString, checked);
                      MyApp.of(context)?.changeTheme(
                          MyTheme.isDarkMode,
                          MyTheme.selectedColorScheme.primary,
                          MyTheme.selectedFonts);
                    });
                  });
                },
                value: MyTheme.isDarkMode,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: MyTheme.largeFontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getColorPlates(MyColor myColor) {
    if (myColor.basicColor == MyTheme.selectedColorScheme.basicColor) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  MyTheme.selectedColorScheme = myColor;
                  _saveSelectedColor(myColor.colorId);
                });
              },
              tileColor: myColor.basicColor,
            ),
            const Icon(Icons.check),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ListTile(
            onTap: () {
              setState(() {
                MyTheme.selectedColorScheme = myColor;
                _saveSelectedColor(myColor.colorId);
              });
            },
            tileColor: myColor.basicColor,
          ),
        ],
      ),
    );
  }

  saveSelectedFont(String fontName) {
    setState(() {
      MyTheme.selectedFonts = fontName;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(MyTheme.fontPreferenceString, fontName);
        MyApp.of(context)?.changeTheme(MyTheme.isDarkMode,
            MyTheme.selectedColorScheme.primary, MyTheme.selectedFonts);
      });
    });
  }

  _getDivider() {
    return Divider(
      color: MyTheme.selectedColorScheme.primary,
      height: 30,
      thickness: 2,
    );
  }

  _saveSelectedColor(int colorId) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(MyTheme.colorIdPrefsString, colorId);
      MyApp.of(context)?.changeTheme(MyTheme.isDarkMode,
          MyTheme.selectedColorScheme.primary, MyTheme.selectedFonts);
    });
  }


  prepareNotesInJson() {
    if (widget.noteDao == null) {
      final db = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
      db.build().then((db) {
        widget.noteDao = db.noteDao;
        List<Note> notes = [];
        widget.noteDao?.getAllNotes(false).then((notes1) {
          notes.addAll(notes1);
          widget.noteDao?.getAllNotes(true).then((notes2) {
            notes.addAll(notes2);
            _convertNotesToJson(notes);
          });
        });
      });
    } else {
      List<Note> notes = [];
      widget.noteDao?.getAllNotes(false).then((notes1) {
        notes.addAll(notes1);
        widget.noteDao?.getAllNotes(true).then((notes2) {
          notes.addAll(notes2);
          _convertNotesToJson(notes);
        });
      });
    }
  }

  _convertNotesToJson(List<Note> notes) {
 //   print('password: ${MyTheme.securePassword}');
    String passwordEncrypted = '';
    if (MyTheme.securePassword.isNotEmpty) {
      passwordEncrypted = EncDec.getEncryptedText(MyTheme.securePassword);
    }
  //  print('password Encrpt: $passwordEncrypted');
    final bkObj = {
      'notes' : notes,
      'password' : passwordEncrypted
    };
    final bkString = json.encode(bkObj);
    final enBackup = EncDec.getEncryptedText(bkString);
 //   print(enBackup);

    getApplicationDocumentsDirectory().then((dir) {
 //     print('got dir: $dir');
      final file = File('${dir.path}/noteit.nbk');
      file.writeAsString(enBackup).then((value) {
 //         print('bkFilee created');
          Share.shareFiles([file.path], text: 'Save your Backup');
      });
    });
  }

  _restoreNotes() {
    FilePicker.platform.pickFiles(allowMultiple: false).then((files) {
      if (files != null) {
        final restoreFile = File(files.files.first.path!);
        restoreFile.readAsString().then((encString) {
     //     print('restoreEnc : $encString');
          final jsonString = EncDec.getDecryptText(encString);
     //     print('mainJson: $jsonString');
          try {
            final listArray = json.decode(jsonString)['notes'] as List;
     //       print('listArray: $listArray');
            List<Note> notes =
            listArray.map((noteJson) => Note.fromJson(noteJson)).toList();
    //        print('restored Data found : $jsonString');
    //        print('notes found ${notes.length}');
            final passEnc = json.decode(jsonString)['password'] as String;
            if (passEnc.isNotEmpty) {
              MyTheme.securePassword = EncDec.getDecryptText(passEnc);
     //         print('Password: ${MyTheme.securePassword}');
              SharedPreferences.getInstance().then((pref) {
                pref.setString(MyTheme.securePasswordPrefString, MyTheme.securePassword);
              });
            }
            _insertRestoredNotes(notes);
          } on Exception catch(_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Restore Failed, Invalid File'))
            );
          }
        });
      }
    });
  }

  _insertRestoredNotes(List<Note> notes) {
    if (widget.noteDao == null) {
      final db = $FloorNoteDatabase.databaseBuilder(MyApp.DB_NAME);
      db.build().then((db) {
        widget.noteDao = db.noteDao;
        widget.noteDao?.insertRestoredNotes(notes).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${notes.length} Notes restored')));
        });
      });
    } else {
      widget.noteDao?.insertRestoredNotes(notes).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${notes.length} Notes restored')));
      });
    }
  }
}
