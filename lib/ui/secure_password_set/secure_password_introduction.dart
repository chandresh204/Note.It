import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injector.dart';
import '../../repository/settings_repository.dart';
import '../component/text_icon_button.dart';
import '../dialog/dialog_with_icon.dart';
import '../theme/text_styles.dart';
import 'secure_settings_bloc.dart';
import 'secure_settings_event.dart';
import 'secure_settings_states.dart';

class SecurePasswordIntroduction extends StatelessWidget {
  const SecurePasswordIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SecureSettingsBloc(getIt<SettingsRepository>()),
      child: _SecureSettingsPage(),
    );
  }
}

class _SecureSettingsPage extends StatefulWidget {
  const _SecureSettingsPage();

  @override
  State<_SecureSettingsPage> createState() => _SecureSettingsPageState();
}

class _SecureSettingsPageState extends State<_SecureSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _passwordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<SecureSettingsBloc, SecureSettingsState>(
        listener: (ctx, state) {
          if (state is SecureSettingsIdle) {
            _tabController.animateTo(state.page);
          } else if (state is SecureSettingsError) {
            showDialog(
              context: context,
              builder: (ctx) => DialogWithIcon(
                icon: Icons.error,
                title: 'Failed',
                description: state.error,
                onDismiss: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is SecureSettingsSuccess) {
            showDialog(
              context: context,
              builder: (ctx) => DialogWithIcon(
                icon: Icons.lock,
                title: 'Success',
                description:
                    'Password set successfully, Now you can create or edit notes in the secure mode. click on the lock icon in the app bar to enter in the secure note mode',
                onDismiss: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            _secureSettingsInstructions(context),
            _secureSettingsAddPassword(context, _passwordController),
            _secureSettingsConfirmPassword(context, _confirmPasswordController),
          ],
        ),
      ),
    );
  }

  Widget _secureSettingsInstructions(BuildContext ctx) {
    const widgetSpacing = 16.0;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome to secure Notes', style: AppTextStyles.heading2),
            SizedBox(height: widgetSpacing),
            Icon(Icons.lock_open, size: 100),
            SizedBox(height: widgetSpacing),
            Text(
              'Here you can create any note that can not be accessed without a password',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            SizedBox(height: widgetSpacing),
            TextIconButton(icon: Icons.password,
                text: 'Set up', onClick: () {
                  context.read<SecureSettingsBloc>().add(MoveToNext());
                })
          ],
        ),
      ),
    );
  }

  Widget _secureSettingsAddPassword(
    BuildContext ctx,
    TextEditingController controller,
  ) {
    const widgetSpacing = 16.0;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add a Password to set up your secure notes room',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: widgetSpacing),
            Icon(Icons.lock_open, size: 100),
            SizedBox(height: widgetSpacing),
            SizedBox(
              width: 200,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Your Password'),
                ),
              ),
            ),
            SizedBox(height: widgetSpacing),
            (controller.text.length > 3)
                ? TextIconButton(icon: Icons.navigate_next,
                text: 'Next', onClick: () {
                  context.read<SecureSettingsBloc>().add(
                    InitPasswordSet(firstPassword: controller.text),
                  );
                }) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _secureSettingsConfirmPassword(
    BuildContext ctx,
    TextEditingController controller,
  ) {
    const widgetSpacing = 16.0;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Confirm Your Password',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: widgetSpacing),
            Icon(Icons.lock_open, size: 100),
            Text(
              'Please type the same password again to confirm it',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            SizedBox(height: widgetSpacing),
            SizedBox(
              width: 200,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Your Password'),
                ),
              ),
            ),
            SizedBox(height: widgetSpacing),
            (controller.text.length > 3)
                ? TextIconButton(
                icon: Icons.check,
                text: 'Finish',
                backgroundColor: Colors.green,
                onClick: () {
                  context.read<SecureSettingsBloc>().add(
                    ComparePasswords(confirmPassword: controller.text),
                  );
                }
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
