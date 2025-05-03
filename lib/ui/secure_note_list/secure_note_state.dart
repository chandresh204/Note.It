import '../model/note_item.dart';

abstract class SecureNoteState {}

class NoteListLoading extends SecureNoteState {}

class NoteListIdle extends SecureNoteState {
  final List<NoteItem> notes;
  NoteListIdle(this.notes);
}