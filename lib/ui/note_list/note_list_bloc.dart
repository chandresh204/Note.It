import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '/mapper/note_data_to_note_ui.dart';
import '/util/runtime_constants.dart';

import '../../database/note_database.dart';
import '../../repository/note_repository.dart';
import 'note_list_event.dart';
import 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {

  final NoteRepository _noteRepository;
  StreamSubscription<List<NoteData>>? _noteSubscription;

  final StreamController<bool> _searchCancelStream = StreamController<bool>();

  /// This timer is used to update the note insert/ edit timing for readable way.
  /// e.g. just now, 1 min ago, 10 min ago etc. this text need to update regularly with time elapse
  late Timer _timer;

  bool _timerRunning = false;
  List<NoteData>? _currentNoteList;
  String _searchQuery = "";

  NoteListBloc(this._noteRepository) : super(NoteListLoading()) {
    _noteSubscription?.cancel();
    _noteSubscription = _noteRepository.watchAllNotes().listen((notes) {
      _currentNoteList = notes;
      _toggleTimer();
      add(NoteListUpdatedEvent(notes.toNoteItem()));
    });
    // _toggleTimer();
    on<NoteListUpdatedEvent>(_onNoteListUpdated);
    on<RefreshListEvent>(_onRefreshListEvent);
    on<NoteDeleteEvent>(_onNoteDelete);
    on<NoteListSearch>(_onNoteListSearch);
    on<SecurePasswordSubmit>(_onSecurePasswordSubmit);
  }

  _toggleTimer() async {
    final editedAfter = await _noteRepository.getNotesEditedAfterTime(DateTime.now().millisecondsSinceEpoch - 3600000);
    if(editedAfter > 0) {
      if(!_timerRunning) {
        _timerRunning = true;
        startTimer();
      }
    } else {
      if(_timerRunning) {
        _timer.cancel();
      }
    }
  }

  _onNoteListUpdated(NoteListUpdatedEvent event,Emitter<NoteListState> emit) {
    emit(NoteListIdle(event.notes));
  }

  _onRefreshListEvent(RefreshListEvent event, Emitter<NoteListState> emit) {
    if(_currentNoteList != null) {
      add(NoteListUpdatedEvent(_currentNoteList!.toNoteItem()));
    }
  }

  _onNoteDelete(NoteDeleteEvent event, Emitter<NoteListState> emit) {
    _noteRepository.deleteNote(event.id);
    _searchCancelStream.add(true);
  }

  _onNoteListSearch(NoteListSearch event, Emitter<NoteListState> emit) async {
    _searchQuery = event.query.trim();
    final searchedNotes = await _noteRepository.searchNotes(_searchQuery) ?? List.empty();
    _currentNoteList = searchedNotes;
    add(NoteListUpdatedEvent(searchedNotes.toNoteItem()));
  }

  _onSecurePasswordSubmit(SecurePasswordSubmit event, Emitter<NoteListState> emit) async {
    final actualPassword = RuntimeConstants.securePassword;
    if(actualPassword == event.password) {
      emit(NoteEnterSecure((state as NoteListIdle).notes));
    } else {
      final notes = (state as NoteListIdle).notes;
      emit(NoteErrorMessage('Incorrect Password, Please try again', notes));
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => add(RefreshListEvent()));
  }

  Stream<bool> getSearchCancelStream() => _searchCancelStream.stream;

  String getSearchQuery() => _searchQuery;

  @override
  Future<void> close() {
    if(_timer.isActive) {
      _timer.cancel();
    }
    return super.close();
  }
}