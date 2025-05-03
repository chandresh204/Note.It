import 'package:note_it2/database/note_database.dart';

abstract class LocalDataSource {
  Future<int> insertNote(String noteText);
  Future<int> insertNoteList(List<NoteData> notes);
  Stream<List<NoteData>> watchAllNotes();
  Stream<List<NoteData>> watchAllEncryptedNotes();
  Future<NoteData?> getNoteById(int id);
  Future<bool> updateNote(NoteData note);
  Future<int> deleteNote(int id);
  Future<List<NoteData>> searchNotes(String query);
  Future<List<NoteData>> searchEncryptedNotes(String query);
  Future<List<NoteData>> getAllNotes(bool encrypted);
}