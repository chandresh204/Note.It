import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/data/encryption/encrypt_decrypt.dart';

import '../../database/note_database.dart';
import '../../repository/note_repository.dart';
import 'note_edit_event.dart';
import 'note_edit_state.dart';

class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {

  final NoteRepository _noteRepository;
  final int _editNoteId;
  NoteData? _editableNote;

  NoteEditBloc(this._noteRepository, this._editNoteId) : super(NoteEditIdle()) {
    on<AddNoteEvent>(_addNewNote);
    on<SetInitNote>(_setInitNote);
    on<EnterEditEvent>(_switchToEditMode);
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
      if(_editableNote!.isEncrypt) {
        add(SetInitNote(EncDec.getDecryptText(_editableNote!.note)));
      } else {
        add(SetInitNote(_editableNote!.note));
      }
    }
  }

  _switchToEditMode(EnterEditEvent event, emit) {
    emit(NoteEditEditingState());
  }

  _addNewNote(AddNoteEvent event, Emitter<NoteEditState> emit) {
    if(event.noteText.isNotEmpty) {
      if(_editableNote == null) {
        _noteRepository.addNote(event.noteText);
      } else {
        _noteRepository.updateNote(_editableNote!.copyWith(
          note: event.noteText,
          editTime: DateTime.now().millisecondsSinceEpoch
        ));
      }
      emit(NoteSaved());
    } else {
      emit(NoteError('Note cannot be empty'));
    }
  }

  _setInitNote(SetInitNote event, Emitter<NoteEditState> emit) {
    emit(NoteEditIdle(initNote: event.initText));
  }
}