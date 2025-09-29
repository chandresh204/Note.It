import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/theme/text_styles.dart';
import 'package:note_it/util/runtime_constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../di/injector.dart';
import '../../repository/note_repository.dart';
import '../component/my_interactive_text.dart';
import '../dialog/confirmation_dialog.dart';
import '../routes.dart';
import 'note_edit_bloc.dart';
import 'note_edit_event.dart';
import 'note_edit_state.dart';

class NoteEditScreen extends StatelessWidget {
  const NoteEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as NoteEditArguments?;
    return BlocProvider<NoteEditBloc>(
      create: (_) => NoteEditBloc(getIt<NoteRepository>(), args?.id ?? -1, args?.isSecure ?? false),
      child: BlocConsumer<NoteEditBloc, NoteEditState>(
        builder: (ctx, state) {
          if (state is NoteEditIdle) {
            return _NoteReadOnly(noteText: state.initNote ?? "");
          } else if (state is NoteEditEditingState) {
            return _NoteEditPage();
          } else {
            return Text('Bad state ');
          }
        },
        listener: (ctx, state) {
          if (state is NoteError) {
            ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
          }
          if (state is NoteSaved) {
            Navigator.pop(ctx);
          }
        },
      ),
    );
  }
}

class _NoteReadOnly extends StatelessWidget {
  final String noteText;
  const _NoteReadOnly({required this.noteText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note.It - Read Only'),
        shadowColor: RuntimeConstants.lightThemeData.primaryColor,
        scrolledUnderElevation: 12,
        actions: appBarReadOnlyActions(noteText),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
                child: MyInteractiveText(text: noteText)
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NoteEditBloc>().add(EnterEditEvent(noteText));
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  List<Widget> appBarReadOnlyActions(String textToEdit) {
    return [
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: const Text('Copy all'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: textToEdit));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            PopupMenuItem(
              child: const Text('Share'),
              onTap: () {
                SharePlus.instance.share(ShareParams(text: textToEdit));
              },
            ),
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () {
                context.read<NoteEditBloc>().add(EnterEditEvent(noteText));
              },
            ),
          ];
        },
      ),
      Container(width: 10),
    ];
  }
}

class _NoteEditPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = context.read<NoteEditBloc>().getEditedText();
    _controller.addListener(() {
      context.read<NoteEditBloc>().add(
        OnNoteTextChange(editedText: _controller.text),
      );
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) {
        if(!didPop && context.read<NoteEditBloc>().isTextChanged()) {
          showDialog(context: context, builder: (ctx) {
            return ConfirmationDialog(
              confirmationText: 'Do you want to discard this changes and close editor?',
              positiveButtonText: 'Yes',
              positiveButtonClick: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              negativeButtonText: 'No, Stay',
              negativeButtonClick: () {
                Navigator.pop(context);
              },
            );
          });
        } else {
          if(!didPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Note.It - Editor'),
          shadowColor: Colors.blue,
          scrolledUnderElevation: 12,
          actions: appBarEditingActions(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: TextField(
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: null,
                controller: _controller,
                autofocus: true,
                style: AppTextStyles.body.copyWith(
                  fontSize: 20*RuntimeConstants.currentTextScaler
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<NoteEditBloc>().add(SaveNoteEvent(_controller.text));
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  List<Widget> appBarEditingActions() {
    return [
      PopupMenuButton(
        itemBuilder: (ctx) {
          return [
            PopupMenuItem(
              child: const Text('Paste'),
              onTap: () {
                Clipboard.getData('text/plain').then((cData) {
                  if (cData?.text != null) {
                    _controller.text = '${_controller.text} ${cData!.text!}';
                  } else {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Clipboard empty')),
                      );
                    }
                  }
                });
              },
            ),
            PopupMenuItem(
              child: const Text('Copy all'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: _controller.text)).then((
                  c,
                ) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Copied to Clipboard')),
                    );
                  }
                });
              },
            ),
            PopupMenuItem(
              child: const Text('Share'),
              onTap: () {
                SharePlus.instance.share(ShareParams(text: _controller.text));
              },
            ),
            PopupMenuItem(
              child: const Text('Close without save'),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            PopupMenuItem(
              child: const Text('Save and close'),
              onTap: () {
                ctx.read<NoteEditBloc>().add(SaveNoteEvent(_controller.text));
              },
            ),
          ];
        },
      ),
      Container(width: 10),
    ];
  }
}
