import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/component/text_icon_button.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/ui/theme/font_family.dart';
import 'package:note_it/util/runtime_constants.dart';
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

import 'package:url_launcher/url_launcher.dart';

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
          if (state is ThemeColorChanged) {
            onThemeColorChanged();
          }
        },
      ),
    );
  }

  Widget _settingsView(BuildContext context, SettingStateIdle state) {
    final scrollController = ScrollController();
    Future.delayed(Duration(milliseconds: 200), () {
      scrollController.animateTo(
        (RuntimeConstants.selectedFontFamily.index) * 25,
        duration: Duration(seconds: 1),
        curve: Easing.emphasizedDecelerate,
      );
    });
    const double widgetSpacing = 16;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
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
          Divider(),
          Text('Text Size', style: AppTextStyles.heading2),
          Slider(
            value: state.textScaler,
            onChanged: (newVal) {
              context.read<SettingsBloc>().add(
                UpdateTextSizeEvent(newSize: newVal),
              );
            },
          ),
          SizedBox(height: widgetSpacing),
          Text(
            'This is Sample Text',
            style: AppTextStyles.body,
            textScaler: TextScaler.linear(
              state.textScaler + Constants.textScalerAndSliderDiff,
            ),
          ),
          Divider(),
          Text('Theme Color', style: AppTextStyles.heading2),
          SizedBox(
            child: GridView(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 80)
                    .toInt(),
              ),
              children: AppColors.values
                  .map(
                    (e) => _colorSetItem(e, state.selectedColor == e, () {
                      context.read<SettingsBloc>().add(
                        UpdateThemeColorEvent(color: e),
                      );
                    }),
                  )
                  .toList(),
            ),
          ),
          Divider(),
          SizedBox(height: widgetSpacing),
          Text('Fonts', style: AppTextStyles.heading2),
          SizedBox(
            height: 300,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width/150).toInt(),
                childAspectRatio: 3,
              ),
              controller: scrollController,
              children: FontFamily.values
                  .map(
                    (f) => _fontSelectItem(
                      f,
                      RuntimeConstants.selectedFontFamily == f,
                      () {
                        context.read<SettingsBloc>().add(
                          UpdateFontFamilyEvent(font: f),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          Divider(),
          SizedBox(height: widgetSpacing),
          Row(
            children: [
              Expanded(child: TextIconButton(icon: Icons.share, text: 'Share App', onClick: () {
                SharePlus.instance.share(
                  ShareParams(
                    text: 'Hello, Im using Note.It. It is a simple app to keep your notes. '
                            'You can also try it by clicking on the link: ${Constants.playStoreUrl}'
                  )
                );
              })),
              SizedBox(width: 8),
              Expanded(child: TextIconButton(icon: Icons.star, text: 'Rate App', onClick: () {
                launchUrl(Uri.parse(Constants.playStoreUrl));
              })),
            ],
          ),
          SizedBox(height: 100)
        ],
      ),
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
            isSelected ? Icon(Icons.check) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _fontSelectItem(FontFamily f, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: RuntimeConstants.selectedAppColor.mapToMaterialColor(),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                f.fontName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontFamily: f.fontName),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
