import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it2/di/injector.dart';
import 'package:note_it2/repository/backup_repository.dart';
import 'package:note_it2/ui/settings/settings_bloc.dart';
import 'package:note_it2/ui/settings/settings_event.dart';
import 'package:note_it2/ui/settings/settings_state.dart';
import 'package:note_it2/ui/theme/text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(getIt<BackupRepository>()),
      child: _SettingsPage(),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        builder: (ctx, state) {
          if (state is SettingStateIdle) {
            return _settingsView(ctx);
          }
          return Center(child: CircularProgressIndicator());
        },
        listener: (ctx, state) {
          if(state is SnackBarInState) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.msg))
            );
          }
          if(state is BackupDataReceivedState) {
            getApplicationDocumentsDirectory().then((dir) {
              final file = File('${dir.path}/noteit.nbk');
              print('file at: $file');
              file.writeAsString(state.backupData).then((value) {
                SharePlus.instance.share(
                  ShareParams(
                    text: 'Save your Backup',
                    files: [XFile(file.path)]
                  )
                ).then((result) {
                  if(result.status == ShareResultStatus.success) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('Backup saved on selected location'))
                    );
                  }
                }
                );
              });
            });
          }
        },
      ),
    );
  }

  Widget _settingsView(BuildContext context) {
    ScrollController controller = ScrollController();
    return ListView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      //       mainAxisAlignment: MainAxisAlignment.start,
      //      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Back & Restore', style: AppTextStyles.heading2),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  //            prepareNotesInJson();
                  // adding dialog to show information about backup
                  context.read<SettingsBloc>().add(BackupNotesEvent());
                },
                child: Row(
                  children: const [
                    Icon(Icons.backup),
                    SizedBox(width: 10),
                    Text('Backup Notes'),
                  ],
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  //      _restoreNotes();
                  // TODO perfrom restore
                  context.read<SettingsBloc>().add(RestoreNotesEvent());
                },
                child: const Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 10),
                    Text('Restore Notes'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
