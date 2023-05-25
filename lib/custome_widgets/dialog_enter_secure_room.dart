import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/theme.dart';
import '../ui/secure_page.dart';

class DialogEnterSecure {

  final BuildContext context;
  DialogEnterSecure(this.context);

  String _enteredPassword1 = "";
  final TextEditingController _controller1 = TextEditingController();
  final int enterFirstStep = 1;
  final int enterPasswordAgain =2;
  final int wrongPasswordState = 3;
  int initState = 1;
  String infoText = 'Please select a password to create a Secure note room, this notes can not be accessed without password';

getFirstEntryDialog2() {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) => Container(),
    transitionBuilder: (ctx, a1, a2, child) {
      return MyTheme.getSelectedDialogTransition(a1, _firstEntryDialog());
    },
    transitionDuration: Duration(milliseconds: (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt()),
  );
}

getAskPasswordDialog2() {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) => Container(),
    transitionBuilder: (ctx, a1, a2, child) {
      return MyTheme.getSelectedDialogTransition(a1, _askPasswordDialog());
    },
    transitionDuration: Duration(milliseconds: (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt()),
  );
}

Widget _firstEntryDialog() {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
    ),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(infoText,
            style: TextStyle(fontSize: MyTheme.primaryFontSize),
            textAlign: TextAlign.center,),
          TextField(
            controller: _controller1,
            style: TextStyle(fontSize: MyTheme.largeFontSize),
            textAlign: TextAlign.center,
            autofocus: true,
            keyboardType: TextInputType.number,
            obscureText: true,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Cancel', style: TextStyle(color: MyTheme.getTextButtonColor()),)),
              const SizedBox(width: 60),
              ElevatedButton(onPressed: () {
                if (initState == enterFirstStep) {
                  _enteredPassword1 = _controller1.text;
                  _controller1.text = '';
                  infoText = 'Please type password again to continue';
                  Navigator.pop(context);
                  initState = enterPasswordAgain;
                  getFirstEntryDialog2();
                  return;
                }
                if (initState == enterPasswordAgain) {
                  if (_controller1.text == _enteredPassword1) {
                    final password = _controller1.text;
                    SharedPreferences.getInstance().then((value) {
                      value.setString(MyTheme.securePasswordPrefString, password);
                      MyTheme.securePassword = password;
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SecurePage();
                      }));
                      _showFinishDialog();
                    });
                    Navigator.pop(context);
                    return;
                  } else {
                    Navigator.pop(context);
                    _showErrorDialog();
                    //    getFirstEntryDialog(animController);
                    return;
                  }
                }
              }, child: const Text('Next')),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showErrorDialog() {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) => Container(),
      transitionBuilder: (ctx, a1, a2, child) {
        return MyTheme.getSelectedDialogTransition(a1,
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
              ),
              icon: const Icon(Icons.error, color: Colors.red, size: 100),
              content: Text('Provided password didn\'t match, Please try again',
                  style: TextStyle(fontSize: MyTheme.primaryFontSize), textAlign: TextAlign.center),
              actions: [
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Dismiss')),
              ],
              actionsAlignment: MainAxisAlignment.center,
            )
        );
      },
      transitionDuration: Duration(milliseconds: (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt())
  );
}

void _showFinishDialog() {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) => Container(),
    transitionBuilder: (ctx, a1, a2, child) {
      return MyTheme.getSelectedDialogTransition(a1,
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
            ),
            icon: const Icon(Icons.check_circle_outline_rounded,
                color: Colors.green, size: 100),
            content: Text('Successfully set password for Secure Notes. '
                'Please do not forget the password. To change your password tap '
                'on the icon button at the top right corner',
                style: TextStyle(fontSize: MyTheme.primaryFontSize), textAlign: TextAlign.center),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.pop(ctx);
              }, child: Text('Dismiss')),
            ],
            actionsAlignment: MainAxisAlignment.center,
          )
      );
    },
    transitionDuration: Duration(milliseconds:
    (MyTheme.animationTiming * MyTheme.animationDialogTimingConst).toInt()),
  );
}

Widget _askPasswordDialog() {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyTheme.dialogCornerRadius)
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter Password', style: TextStyle(fontSize: MyTheme.primaryFontSize),),
          TextField(
            controller: _controller1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
            obscureText: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: MyTheme.getTextButtonColor()),)),
              const SizedBox(width: 60),
              ElevatedButton(
                  onPressed: () {
                    if (_controller1.text == MyTheme.securePassword) {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SecurePage();
                      }));
                    } else {
                      _controller1.text = '';
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Wrong password, Try Again'))
                      );
                      Navigator.pop(context);
                      getAskPasswordDialog2();
                    }
                  },
                  child: const Text('Next'))
            ],
          ),
        ],
      ),
    ),
  );
}
}