import 'dart:convert';
import 'dart:io';

import 'package:note_it/util/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/encryption/encrypt_decrypt.dart';
import '../data/local/local_data_source.dart';
import '../database/note_database.dart';
import '../util/runtime_constants.dart';
import '../util/shared_preference_constants.dart';

class BackupRepository {

  final LocalDataSource _localDataSource;
  BackupRepository(this._localDataSource);

  /// this function will return backup data in encrypted form to be written on file
  Future<String> prepareNotesInJson() async {
    List<NoteData> notes = [];
    final gNotes = await _localDataSource.getAllNotes(false);
    final sNotes = await _localDataSource.getAllNotes(true);
    if(gNotes.isEmpty && sNotes.isEmpty) {
      return '';
    }
    notes.addAll(gNotes);
    notes.addAll(sNotes);
    return _convertNotesToJson(notes);
  }

  Future<String> _convertNotesToJson(List<NoteData> notes) async {
    PackageInfo pInfo = await PackageInfo.fromPlatform();
    String passwordEncrypted = '';
    if (RuntimeConstants.securePassword != null &&  RuntimeConstants.securePassword!.isNotEmpty) {
      passwordEncrypted = EncDec.getEncryptedText(RuntimeConstants.securePassword!);
    }
    final bkObj = {
      Constants.backUpNotesJson : notes,
      Constants.backUpPasswordJson : passwordEncrypted,
      Constants.backUpAppVersionJson : pInfo.buildNumber
    };
    final bkString = json.encode(bkObj);
    final enBackup = EncDec.getEncryptedText(bkString);

    return enBackup;
  }

  Future<int> restoreNotesFromFile(File restoreFile) async {
    PackageInfo pInfo = await PackageInfo.fromPlatform();
    final encString = await restoreFile.readAsString();
    final jsonString = EncDec.getDecryptText(encString);
    try {
      final listArray = json.decode(jsonString)[Constants.backUpNotesJson] as List;
      List<NoteData> notes =
      listArray
          .map((noteJson) => NoteData.fromJson(noteJson))
          .toList();
      final passEnc = json.decode(jsonString)[Constants.backUpPasswordJson] as String;
      if (passEnc.isNotEmpty) {
        RuntimeConstants.securePassword = EncDec.getDecryptText(passEnc);
        SharedPreferences.getInstance().then((pref) {
          pref.setString(
            SharedPreferencesConstants.securePasswordPrefString,
            passEnc,
          );
        });
      }
      try {
        final backedUpFromAppVersion = json.decode(jsonString)[Constants.backUpAppVersionJson] as int;
        // perform operation on backed up from version
        if(backedUpFromAppVersion > int.parse(pInfo.buildNumber)) {
          print('backed up from future release....$backedUpFromAppVersion');
        }
      } catch (e) {
        // if back up file is too old then the appVersion might be missing in backup file
        print('Error when getting app version from backup file: $e');
      }
      return _insertRestoredNotes(notes);
    } catch (e) {
      print('Error when restoring notes: $e');
      return -1;
    }
  }

  Future<int> _insertRestoredNotes(List<NoteData> notes) async {
    try {
      final inserted = await _localDataSource.insertNoteList(notes);
      return inserted;
    } catch (e) {
      print('Error when restoring notes: $e');
      return -1;
    }
  }
}