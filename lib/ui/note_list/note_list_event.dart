import '../model/note_item.dart';

abstract class NoteListEvent {}

class NoteListUpdatedEvent extends NoteListEvent {
  List<NoteItem> notes;
  NoteListUpdatedEvent(this.notes);
}

class RefreshListEvent extends NoteListEvent {}

class NoteDeleteEvent extends NoteListEvent {
  final int id;
  NoteDeleteEvent(this.id);
}

class NoteListSearch extends NoteListEvent {
  final String query;
  NoteListSearch(this.query);
}

class SecurePasswordSubmit extends NoteListEvent {
  final String password;
  SecurePasswordSubmit(this.password);
}