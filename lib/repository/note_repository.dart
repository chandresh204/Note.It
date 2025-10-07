import '../data/encryption/encrypt_decrypt.dart';

import '../data/local/local_data_source.dart';
import '../database/note_database.dart';

class NoteRepository {
  final LocalDataSource _localDataSource;

  NoteRepository(this._localDataSource);

  addNote(String noteText, bool isEncrypt) async {
    final saveText = isEncrypt ? EncDec.getEncryptedText(noteText) : noteText;
    await _localDataSource.insertNote(saveText, isEncrypt);
  }

  Future<int> addMultipleNotes(List<NoteData> notes) async {
    return await _localDataSource.insertNoteList(notes);
  }

  Stream<List<NoteData>> watchAllNotes() => _localDataSource.watchAllNotes();

  Stream<List<NoteData>> watchAllSecureNotes() =>
      _localDataSource.watchAllEncryptedNotes();

  Future<NoteData?> getNoteById(int id) => _localDataSource.getNoteById(id);

  updateNote(NoteData note) async {
    _localDataSource.updateNote(note);
  }

  deleteNote(int id) async {
    _localDataSource.deleteNote(id);
  }

  Future<List<NoteData>?> searchNotes(String query) async =>
      _localDataSource.searchNotes(query);

  Future<int> getNotesEditedAfterTime(int editedAfter) async =>
      _localDataSource.getNotesEditedAfterTime(editedAfter);
}
