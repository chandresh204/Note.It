abstract class NoteEditEvent {}

class EnterEditEvent extends NoteEditEvent {
  final String noteText;
  EnterEditEvent(this.noteText);
}

class AddNoteEvent extends NoteEditEvent {
  final String noteText;
  AddNoteEvent(this.noteText);
}

class SetInitNote extends NoteEditEvent {
  final String initText;
  SetInitNote(this.initText);
}