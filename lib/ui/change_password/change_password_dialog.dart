import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_it/ui/dialog/dialog_with_icon.dart';
import '/ui/change_password/change_password_bloc.dart';
import '/ui/change_password/change_password_state.dart';
import '/ui/theme/text_styles.dart';
import '/util/extensions.dart';

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(),
      child: _ChangeDialog(),
    );
  }
}

class _ChangeDialog extends StatelessWidget {
  const _ChangeDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Change Password', style: AppTextStyles.heading2),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
              builder: (ctx, state) {
                if (state is ChangePasswordInit) {
                  return _enterCurrentPasswordUI(
                    ctx,
                    state.errorMsg,
                  );
                } else if (state is CreateNewPassword) {
                  return _createNewPasswordUi(ctx, state.errorMsg);
                } else if (state is ChangePasswordDone) {
                  return _changePasswordDoneUi(ctx);
                } else {
                  return Text('bad state');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _enterCurrentPasswordUI(
    BuildContext context,
    String? error,
  ) {
    final currentPasswordController = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                obscureText: true,
                controller: currentPasswordController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Current Password'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ChangePasswordBloc>().checkCurrentPassword(
                  currentPasswordController.text,
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
        if (!error.isNullOrEmpty())
          Text(error!, style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _createNewPasswordUi(BuildContext context, String? errorMsg) {
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'New Password'),
          controller: newPassController,
          keyboardType: TextInputType.number,
          obscureText: true,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Re-enter New Password'),
          controller: confirmPassController,
          keyboardType: TextInputType.number,
          obscureText: true,
        ),
        !errorMsg.isNullOrEmpty()
            ? Text(
                errorMsg!,
                style: AppTextStyles.small.copyWith(color: Colors.red),
              )
            : Text('', style: AppTextStyles.body.copyWith(color: Colors.red)),
        ElevatedButton(
          onPressed: () {
            context.read<ChangePasswordBloc>().changePassword(
              newPassController.text,
              confirmPassController.text,
            );
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  Widget _changePasswordDoneUi(BuildContext context) {
    return DialogWithIcon(
        icon: Icons.check,
        title: 'Success',
        description: 'Password changed successfully',
        onDismiss: () {
          Navigator.pop(context);
        });
  }
}
