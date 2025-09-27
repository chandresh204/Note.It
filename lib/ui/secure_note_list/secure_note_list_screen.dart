import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/ui/change_password/change_password_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../di/injector.dart';
import '../../repository/note_repository.dart';
import '../dialog/bottom_sheet_delete_confirm.dart';
import '../dialog/bottom_sheet_note_actions.dart';
import '../component/note_tile.dart';
import '../routes.dart';
import 'secure_note_bloc.dart';
import 'secure_note_event.dart';
import 'secure_note_state.dart';

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

class _SecureNoteListPageState extends State<_SecureNoteListPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note.It - Secure'),
        actions: [IconButton(onPressed: () {
          showGeneralDialog(context: context, pageBuilder: (ctx,a1,a2) => ChangePasswordDialog());
        }, icon: Icon(Icons.lock_reset))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.editScreen, arguments: NoteEditArguments(-1, true));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<SecureNoteBloc, SecureNoteState>(
        builder:
            (ctx, state) =>
                state is NoteListLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is NoteListIdle
                    ? ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (ctx, index) {
                        final note = state.notes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: NoteTile(
                            noteText: note.noteText,
                            createdTime: note.createdTime,
                            editTime: note.lastEditTime,
                            onClick: () {
                              Navigator.pushNamed(
                                context,
                                Routes.editScreen,
                                arguments: NoteEditArguments(note.id, true),
                              );
                            },
                            onLongClick: () {
                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (ctx) => BottomSheetNoteActions(
                                      noteText: note.noteText,
                                      onNoteShare: () {
                                        SharePlus.instance.share(
                                          ShareParams(
                                            title: 'Share with',
                                            text: note.noteText,
                                          ),
                                        );
                                      },
                                      onDelete: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder:
                                              (ctx) => BottomSheetDeleteConfirm(
                                                noteText: note.noteText,
                                                onDelete:
                                                    () => context
                                                        .read<SecureNoteBloc>()
                                                        .add(
                                                          NoteDeleteEvent(
                                                            note.id,
                                                          ),
                                                        ),
                                              ),
                                        );
                                      },
                                    ),
                              );
                            },
                          ),
                        );
                      },
                    )
                    : const Text('Something went wrong'),
      ),
    );
  }
}
