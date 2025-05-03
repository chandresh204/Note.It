import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it2/di/injector.dart';
import 'package:note_it2/repository/note_repository.dart';
import 'package:note_it2/ui/note_edit_screen/note_edit_bloc.dart';
import 'package:note_it2/ui/routes.dart';

import 'note_edit_event.dart';
import 'note_edit_state.dart';

class NoteEditScreen extends StatelessWidget {
  const NoteEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as NoteEditArguments?;
    final noteEditController = TextEditingController();
    return BlocProvider<NoteEditBloc>(
      create: (_) => NoteEditBloc(getIt<NoteRepository>(), args?.id ?? -1),
      child: _NoteEditPage(noteEditController),
    );
  }
}

class _NoteEditPage extends StatelessWidget {
  final TextEditingController _controller;
  const _NoteEditPage(this._controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: BlocConsumer<NoteEditBloc, NoteEditState>(
        builder: (ctx, state) {
            if(state is NoteEditIdle) {
                return Column(
              children: [
                Expanded(
                  child: Text(
                    _controller.text,
                  ),
                ),
              ],
            );
            } else {
              return const Text('Unknown State');
            }
          },
        listener: (BuildContext context, NoteEditState state) {
            if(state is NoteEditIdle) {
              if(state.initNote != null) {
                _controller.text = state.initNote!;
              }
            }
            if(state is NoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMsg))
              );
            }
            if(state is NoteSaved) {
              Navigator.pop(context);
            }
      },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        context.read<NoteEditBloc>().add(AddNoteEvent(_controller.text));
      }),
    );
  }
}
