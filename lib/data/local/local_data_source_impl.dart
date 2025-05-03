import 'package:drift/drift.dart';

import '../../database/note_database.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final NoteDatabase _noteDb;

  LocalDataSourceImpl(this._noteDb);

  @override
  Future<int> insertNote(String noteText) => _noteDb.insertNote(
    NoteCompanion(
      id: Value(DateTime.now().millisecondsSinceEpoch),
      note: Value(noteText),
      editTime: Value(DateTime.now().millisecondsSinceEpoch),
      isEncrypt: const Value(false),
    ),
  );

  @override
  Future<int> insertNoteList(List<NoteData> notes) async {
    final noteCompanionList =
        notes
            .map(
              (note) => NoteCompanion(
                id: Value(note.id),
                note: Value(note.note),
                editTime: Value(note.editTime),
                isEncrypt: Value(note.isEncrypt),
              ),
            )
            .toList();
    await _noteDb.insertMultipleNotes(noteCompanionList);
    return noteCompanionList.length;
  }

  @override
  Stream<List<NoteData>> watchAllNotes() => _noteDb.watchAllNotes(false);

  @override
  Stream<List<NoteData>> watchAllEncryptedNotes() =>
      _noteDb.watchAllNotes(true);

  @override
  Future<NoteData?> getNoteById(int id) => _noteDb.getNoteById(id);

  @override
  Future<bool> updateNote(NoteData note) {
    return _noteDb.updateNote(note);
  }

  @override
  Future<int> deleteNote(int id) => _noteDb.deleteNote(id);

  @override
  Future<List<NoteData>> searchNotes(String query) =>
      _noteDb.getNotesThatContains(query, false);

  @override
  Future<List<NoteData>> searchEncryptedNotes(String query) =>
      _noteDb.getNotesThatContains(query, true);

  @override
  Future<List<NoteData>> getAllNotes(bool encrypted) => _noteDb.getAllNotes(encrypted);
}
