import '../model/note_item.dart';

abstract class NoteListState {}

class NoteListLoading extends NoteListState {}

class NoteListIdle extends NoteListState {
  final List<NoteItem> notes;
  NoteListIdle(this.notes);
}

class NoteErrorMessage extends NoteListIdle {
  final String message;
  NoteErrorMessage(this.message, super.notes);
}

class NoteEnterSecure extends NoteListState {}