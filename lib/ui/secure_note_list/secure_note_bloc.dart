import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/mapper/note_data_to_note_ui.dart';
import '../../database/note_database.dart';
import '../../repository/note_repository.dart';
import 'secure_note_event.dart';
import 'secure_note_state.dart';

class SecureNoteBloc extends Bloc<SecureNoteEvent, SecureNoteState> {

  final NoteRepository _noteRepository;
  StreamSubscription<List<NoteData>>? _noteSubscription;

  late Timer _timer;
  bool _timerRunning = false;
  List<NoteData>? _currentNoteList;

  final StreamController<bool> _searchCancelStream = StreamController<bool>();

  SecureNoteBloc(this._noteRepository) : super(NoteListLoading()) {
    _noteSubscription?.cancel();
    _noteSubscription = _noteRepository.watchAllSecureNotes().listen((notes) {
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
  }

  _onNoteListUpdated(NoteListUpdatedEvent event,Emitter<SecureNoteState> emit) {
    emit(NoteListIdle(event.notes));
  }

  _onRefreshListEvent(RefreshListEvent event, Emitter<SecureNoteState> emit) {
    print('secure timer refresh');
    if(_currentNoteList != null) {
      add(NoteListUpdatedEvent(_currentNoteList!.toNoteItem()));
    }
  }

  _onNoteDelete(NoteDeleteEvent event, Emitter<SecureNoteState> emit) {
    _noteRepository.deleteNote(event.id);
    _searchCancelStream.add(true);
  }

  _onNoteListSearch(NoteListSearch event, Emitter<SecureNoteState> emit) async {
    final searchedNotes = await _noteRepository.searchNotes(event.query) ?? List.empty();
    _currentNoteList = searchedNotes;
    add(NoteListUpdatedEvent(searchedNotes.toNoteItem()));
  }

  void startTimer() {
    print('secure timer started');
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => add(RefreshListEvent()));
  }

  Stream<bool> getSearchCancelStream() => _searchCancelStream.stream;

  @override
  Future<void> close() {
    _timer.cancel();
    print('secure timer stopped');
    return super.close();
  }
}