import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  _ChangeDialog();

  final _currentPasswordController = TextEditingController();

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
                    _currentPasswordController,
                    state.errorMsg
                  );
                } else if (state is CreateNewPassword) {
                  return _createNewPasswordUi(ctx);
                } else if (state is ChangePasswordDone) {
                  return _changePasswordDoneUi();
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
    TextEditingController controller,
    String? error,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                obscureText: true,
                controller: controller,
                decoration: InputDecoration(labelText: 'Current Password'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ChangePasswordBloc>().checkCurrentPassword(
                  controller.text,
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
        if (!error.isNullOrEmpty())
          Text(
            error!,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _createNewPasswordUi(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(decoration: InputDecoration(labelText: 'New Password')),
        TextField(
          decoration: InputDecoration(labelText: 'Re-enter New Password'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ChangePasswordBloc>().changePassword();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  Widget _changePasswordDoneUi() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: Colors.green),
        Text('Password Changed'),
        ElevatedButton(onPressed: () {}, child: Text('Ok')),
      ],
    );
  }
}
