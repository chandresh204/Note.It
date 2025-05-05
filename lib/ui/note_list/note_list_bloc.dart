import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/mapper/note_data_to_note_ui.dart';
import 'package:note_it/util/runtime_constants.dart';

import '../../database/note_database.dart';
import '../../repository/note_repository.dart';
import 'note_list_event.dart';
import 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {

  final NoteRepository _noteRepository;
  StreamSubscription<List<NoteData>>? _noteSubscription;

  final StreamController<bool> _searchCancelStream = StreamController<bool>();

  late Timer _timer;
  bool _timerRunning = false;
  List<NoteData>? _currentNoteList;

  NoteListBloc(this._noteRepository) : super(NoteListLoading()) {
    _noteSubscription?.cancel();
    _noteSubscription = _noteRepository.watchAllNotes().listen((notes) {
      _currentNoteList = notes;
      add(NoteListUpdatedEvent(notes.toNoteItem()));
      if(_currentNoteList != null && _currentNoteList!.isNotEmpty && !_timerRunning) {
        _timerRunning = true;
        startTimer();
      }
    });
    on<NoteListUpdatedEvent>(_onNoteListUpdated);
    on<RefreshListEvent>(_onRefreshListEvent);
    on<NoteDeleteEvent>(_onNoteDelete);
    on<NoteListSearch>(_onNoteListSearch);
    on<SecurePasswordSubmit>(_onSecurePasswordSubmit);
  }

  _onNoteListUpdated(NoteListUpdatedEvent event,Emitter<NoteListState> emit) {
    emit(NoteListIdle(event.notes));
  }

  _onRefreshListEvent(RefreshListEvent event, Emitter<NoteListState> emit) {
    print('timer refresh');
    if(_currentNoteList != null) {
      add(NoteListUpdatedEvent(_currentNoteList!.toNoteItem()));
    }
  }

  _onNoteDelete(NoteDeleteEvent event, Emitter<NoteListState> emit) {
    _noteRepository.deleteNote(event.id);
    _searchCancelStream.add(true);
  }

  _onNoteListSearch(NoteListSearch event, Emitter<NoteListState> emit) async {
    final searchedNotes = await _noteRepository.searchNotes(event.query) ?? List.empty();
    _currentNoteList = searchedNotes;
    add(NoteListUpdatedEvent(searchedNotes.toNoteItem()));
  }

  _onSecurePasswordSubmit(SecurePasswordSubmit event, Emitter<NoteListState> emit) async {
    final actualPassword = RuntimeConstants.securePassword;
    if(actualPassword == event.password) {
      emit(NoteEnterSecure());
    } else {
      final notes = (state as NoteListIdle).notes;
      emit(NoteErrorMessage('Incorrect Password, Please try again', notes));
    }
  }

  void startTimer() {
    print('timer started');
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => add(RefreshListEvent()));
  }

  Stream<bool> getSearchCancelStream() => _searchCancelStream.stream;

  @override
  Future<void> close() {
    _timer.cancel();
    print('timer stopped');
    return super.close();
  }
}