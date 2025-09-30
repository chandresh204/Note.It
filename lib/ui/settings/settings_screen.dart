import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import '../../repository/settings_repository.dart';
import '../../util/constants.dart';
import '/ui/settings/settings_bloc.dart';
import '/ui/settings/settings_event.dart';
import '/ui/settings/settings_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../di/injector.dart';
import '../../repository/backup_repository.dart';
import '../theme/text_styles.dart';

class SettingsScreen extends StatelessWidget {
  final Function() onThemeColorChanged;
  const SettingsScreen({super.key, required this.onThemeColorChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SettingsBloc(getIt<BackupRepository>(), getIt<SettingsRepository>()),
      child: _SettingsPage(onThemeColorChanged),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  final Function() onThemeColorChanged;
  const _SettingsPage(this.onThemeColorChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        builder: (ctx, state) {
          if (state is SettingStateIdle) {
            return _settingsView(ctx, state);
          }
          return Center(child: CircularProgressIndicator());
        },
        listener: (ctx, state) {
          if (state is SnackBarInState) {
            ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(SnackBar(content: Text(state.msg)));
          }
          if (state is BackupDataReceivedState) {
            getApplicationDocumentsDirectory().then((dir) {
              final file = File('${dir.path}/noteit.nbk');
              print('file at: $file');
              file.writeAsString(state.backupData).then((value) {
                SharePlus.instance
                    .share(
                      ShareParams(
                        text: 'Save your Backup',
                        files: [XFile(file.path)],
                      ),
                    )
                    .then((result) {
                      if (result.status == ShareResultStatus.success) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Backup saved on selected location'),
                          ),
                        );
                      }
                    });
              });
            });
          }
          if(state is ThemeColorChanged) {
            onThemeColorChanged();
          }
        },
      ),
    );
  }

  Widget _settingsView(BuildContext context, SettingStateIdle state) {
    ScrollController controller = ScrollController();
    const double widgetSpacing = 16;
    return ListView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Backup & Restore', style: AppTextStyles.heading2),
        SizedBox(height: widgetSpacing),
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
                  children: [
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
                  context.read<SettingsBloc>().add(RestoreNotesEvent());
                },
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 10),
                    Text('Restore Notes', overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: widgetSpacing),
        Text('Text Size', style: AppTextStyles.heading2),
        Slider(
          value: state.textScaler,
          onChanged: (newVal) {
            context.read<SettingsBloc>().add(
              UpdateTextSizeEvent(newSize: newVal),
            );
          },
        ),
        Text(
          'This is Sample Text',
          style: AppTextStyles.body,
          textScaler: TextScaler.linear(
            state.textScaler + Constants.textScalerAndSliderDiff,
          ),
        ),
        SizedBox(
          height: 200,
          child: GridView(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            children: AppColors.values
                .map((e) => _colorSetItem(e, state.selectedColor == e, () {
                  context.read<SettingsBloc>().add(UpdateThemeColorEvent(color: e));
            }))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _colorSetItem(AppColors color, bool isSelected, Function() onTap) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.mapToMaterialColor(),
              ),
            ),
            isSelected ? Icon(Icons.check) : SizedBox()
          ],
        ),
      ),
    );
  }
}
