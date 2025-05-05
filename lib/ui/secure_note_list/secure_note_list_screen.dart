import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injector.dart';
import '../../repository/note_repository.dart';
import '../component/note_list_app_bar.dart';
import '../component/note_tile.dart';
import '../routes.dart';
import 'secure_note_bloc.dart';
import 'secure_note_state.dart';
import 'secure_note_event.dart';

class SecureNoteListScreen extends StatelessWidget {

  const SecureNoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SecureNoteBloc(getIt<NoteRepository>()),
      child: _SecureNoteListPage(),
    );
  }
}

class _SecureNoteListPage extends StatefulWidget {
  const _SecureNoteListPage();

  @override
  State<_SecureNoteListPage> createState() => _SecureNoteListPageState();
}

class _SecureNoteListPageState extends State<_SecureNoteListPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NoteListAppBar( // TODO replace this app bar
          cancelSearch: context.read<SecureNoteBloc>().getSearchCancelStream(),
          onSearchQuery: (query) {
            context.read<SecureNoteBloc>().add(NoteListSearch(query));
          },
          onSecureClick: () { },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.editScreen);
            }, child: const Icon(Icons.add)),
        body: BlocBuilder<SecureNoteBloc, SecureNoteState>(
          builder: (ctx, state) => state is NoteListLoading
              ? const Center(child: CircularProgressIndicator())
              : state is NoteListIdle
              ? ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (ctx, index) {
                final note = state.notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: NoteTile(
                    noteText: note.noteText,
                    createdTime: note.createdTime,
                    editTime: note.lastEditTime,
                    onClick: () {
                      Navigator.pushNamed(context, Routes.editScreen, arguments: NoteEditArguments(note.id));
                    },
                    onLongClick: () {
                      context.read<SecureNoteBloc>().add(NoteDeleteEvent(note.id));
                    },
                  ),
                );
              })
              : const Text('Something went wrong'),
        )
    );
  }
}
