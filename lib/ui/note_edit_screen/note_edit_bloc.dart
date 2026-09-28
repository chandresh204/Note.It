import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/encryption/encrypt_decrypt.dart';

import '../../database/note_database.dart';
import '../../repository/note_repository.dart';
import 'note_edit_event.dart';
import 'note_edit_state.dart';

class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {

  final NoteRepository _noteRepository;
  final int _editNoteId;
  final bool isSecure;
  NoteData? _editableNote;
  String _editedText = "";

  NoteEditBloc(this._noteRepository, this._editNoteId, this.isSecure) : super(NoteEditIdle()) {
    on<SaveNoteEvent>(_saveNote);
    on<SetInitNote>(_setInitNote);
    on<EnterEditEvent>(_switchToEditMode);
    on<OnNoteTextChange>(_onNoteTextChange);
    if(_editNoteId > 0) {
      _setNoteInUi(_editNoteId);
    } else {
      add(EnterEditEvent(''));
    }
  }

  // event handlers
  _setNoteInUi(int id) async {
    _editableNote = await _noteRepository.getNoteById(id);
    if(_editableNote != null) {
      if(isSecure) {
        add(SetInitNote(EncDec.getDecryptText(_editableNote!.note)));
      } else {
        add(SetInitNote(_editableNote!.note));
      }
    }
  }

  _switchToEditMode(EnterEditEvent event, emit) {
    emit(NoteEditEditingState(editedText: event.noteText));
  }

  _saveNote(SaveNoteEvent event, Emitter<NoteEditState> emit) {
    if(event.noteText.isNotEmpty) {
      if(_editableNote == null) {
        _noteRepository.addNote(event.noteText, isSecure);
      } else {
        final saveText = isSecure ? EncDec.getEncryptedText(event.noteText) : event.noteText;
        _noteRepository.updateNote(_editableNote!.copyWith(
          note: saveText,
          editTime: DateTime.now().millisecondsSinceEpoch
        ));
      }
      emit(NoteSaved(editedText: event.noteText));
    } else {
      emit(NoteError('Note cannot be empty'));
    }
  }

  _setInitNote(SetInitNote event, Emitter<NoteEditState> emit) {
    _editedText = event.initText;
    emit(NoteEditIdle(initNote: event.initText));
  }

  _onNoteTextChange(OnNoteTextChange event, Emitter<NoteEditState> emit) {
    _editedText = event.editedText;
  }

  String getEditedText() {
    return _editedText;
  }

  bool isTextChanged() {
    bool isTextChanged = false;
    if(_editableNote == null) {
      isTextChanged = _editedText.isNotEmpty;
    } else {
      if(isSecure) {
        isTextChanged = EncDec.getDecryptText(_editableNote!.note) != _editedText;
      } else {
        isTextChanged = _editableNote!.note != _editedText;
      }
    }
    return isTextChanged;
  }
}