import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injector.dart';
import '../../repository/note_repository.dart';
import '../component/note_list_app_bar.dart';
import '../component/note_tile.dart';
import '../routes.dart';
import 'note_list_bloc.dart';
import 'note_list_event.dart';
import 'note_list_state.dart';

class NoteListScreen extends StatelessWidget {

  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteListBloc(getIt<NoteRepository>()),
      child: _NoteListPage(),
    );
  }
}

class _NoteListPage extends StatefulWidget {
  const _NoteListPage();

  @override
  State<_NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<_NoteListPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NoteListAppBar(
          cancelSearch: context.read<NoteListBloc>().getSearchCancelStream(),
          onSearchQuery: (query) {
            context.read<NoteListBloc>().add(NoteListSearch(query));
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.editScreen);
            }, child: const Icon(Icons.add)),
        body: BlocBuilder<NoteListBloc, NoteListState>(
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
                        context.read<NoteListBloc>().add(NoteDeleteEvent(note.id));
                      },
                    ),
                  );
                })
                : const Text('Something went wrong'),
        )
    );
  }
}
