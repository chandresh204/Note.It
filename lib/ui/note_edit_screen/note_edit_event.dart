abstract class NoteEditEvent {}

class EnterEditEvent extends NoteEditEvent {
  final String noteText;
  EnterEditEvent(this.noteText);
}

class SaveNoteEvent extends NoteEditEvent {
  final String noteText;
  SaveNoteEvent(this.noteText);
}

class SetInitNote extends NoteEditEvent {
  final String initText;
  SetInitNote(this.initText);
}

class OnNoteTextChange extends NoteEditEvent {
  final String editedText;
  OnNoteTextChange({required this.editedText});
}