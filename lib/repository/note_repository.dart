import 'package:note_it2/data/local/local_data_source.dart';
import 'package:note_it2/data/native/constants.dart';
import 'package:note_it2/data/native/native_date_source.dart';

import '../database/note_database.dart';

class NoteRepository {
  final LocalDataSource _localDataSource;
  final NativeDataSource _nativeDataSource;

  NoteRepository(this._localDataSource, this._nativeDataSource);

  addNote(String noteText) async {
    final added = await _localDataSource.insertNote(noteText);
    if (added > 0) {
      _nativeDataSource.showNotification(
        'New Note',
        noteText,
        Constants.notificationHigh,
      );
    }
  }

  Future<int> addMultipleNotes(List<NoteData> notes) async {
    return await _localDataSource.insertNoteList(notes);
  }

  Stream<List<NoteData>> watchAllNotes() => _localDataSource.watchAllNotes();

  Stream<List<NoteData>> watchAllSecureNotes() =>
      _localDataSource.watchAllEncryptedNotes();

  Future<NoteData?> getNoteById(int id) => _localDataSource.getNoteById(id);

  updateNote(NoteData note) async {
    final updated = _localDataSource.updateNote(note);
    if (await updated) {
      _nativeDataSource.showNotification(
        'Note updated',
        note.note,
        Constants.notificationDefault,
      );
    }
  }

  deleteNote(int id) async {
    final deleted = _localDataSource.deleteNote(id);
    if (await deleted > 0) {
      _nativeDataSource.showNotification(
        'Note Deleted',
        'Note Deleted',
        Constants.notificationLow,
      );
    }
  }

  Future<List<NoteData>?> searchNotes(String query) async =>
      _localDataSource.searchNotes(query);
}
