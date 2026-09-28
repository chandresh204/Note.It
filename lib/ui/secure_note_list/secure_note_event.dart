import '../model/note_item.dart';

abstract class SecureNoteEvent{}

class NoteListUpdatedEvent extends SecureNoteEvent {
  List<NoteItem> notes;
  NoteListUpdatedEvent(this.notes);
}

class RefreshListEvent extends SecureNoteEvent {}

class NoteDeleteEvent extends SecureNoteEvent {
  final int id;
  NoteDeleteEvent(this.id);
}

class NoteListSearch extends SecureNoteEvent {
  final String query;
  NoteListSearch(this.query);
}