import 'package:floor/floor.dart';
import 'note.dart';

@dao
abstract class NoteDao {

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOneNote(Note note);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRestoredNotes(List<Note> notes);

  @Query('select * from Note where id = :id')
  Future<Note?> getNoteFromId(int id);

  @Query('select * from Note where isEncrypt = :isEnc order by editTime desc')
  Future<List<Note>> getAllNotes(bool isEnc);

  @delete
  Future<void> deleteNote(Note note);
}