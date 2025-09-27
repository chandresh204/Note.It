import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/empty_list_view.dart';
import '/ui/dialog/bottom_sheet_delete_confirm.dart';
import '/ui/dialog/bottom_sheet_note_actions.dart';
import '/util/extensions.dart';
import '/util/runtime_constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../di/injector.dart';
import '../../repository/note_repository.dart';
import '../component/note_list_app_bar.dart';
import '../component/note_tile.dart';
import '../dialog/enter_password_dialog.dart';
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
          onSecureClick: () {
            if(RuntimeConstants.securePassword.isNullOrEmpty()) {
              Navigator.pushNamed(context, Routes.secureIntroductionScreen);
            } else {
              showGeneralDialog(
                context: context,
                pageBuilder: (ctx, a1, a2) => EnterPasswordDialog(
                  onSubmit: (p) => context.read<NoteListBloc>().add(SecurePasswordSubmit(p)),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.editScreen);
            }, child: const Icon(Icons.add)),
        body: BlocConsumer<NoteListBloc, NoteListState>(
            builder: (ctx, state) => state is NoteListLoading
                ? const Center(child: CircularProgressIndicator())
                : state is NoteListIdle
                ? (state.notes.isEmpty) 
                  ? EmptyListView()
                  : ListView.builder(
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
                        Navigator.pushNamed(context, Routes.editScreen, arguments: NoteEditArguments(note.id, false));
                      },
                      onLongClick: () {
                        showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            builder: (ctx) => BottomSheetNoteActions(
                              noteText: note.noteText,
                              onNoteShare: () {
                                SharePlus.instance.share(ShareParams(title: 'Share with', text: note.noteText));
                              },
                              onDelete: () {
                                showModalBottomSheet(context: context, builder: (ctx) => BottomSheetDeleteConfirm(
                                    noteText: note.noteText,
                                    onDelete: () => context.read<NoteListBloc>().add(NoteDeleteEvent(note.id))
                                ));
                              }
                            ));
                      },
                    ),
                  );
                })
                : const Text('Something went wrong'),
          listener: (BuildContext context, NoteListState state) {
              if(state is NoteErrorMessage) {
                context.snackBar(state.message);
              }
              if(state is NoteEnterSecure) {
                Navigator.pushNamed(context, Routes.secureListScreen);
              }
          },
        )
    );
  }
}
