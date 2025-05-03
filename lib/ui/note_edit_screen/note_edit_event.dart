abstract class NoteEditEvent {}

class AddNoteEvent extends NoteEditEvent {
  final String noteText;
  AddNoteEvent(this.noteText);
}

class SetInitNote extends NoteEditEvent {
  final String initText;
  SetInitNote(this.initText);
}