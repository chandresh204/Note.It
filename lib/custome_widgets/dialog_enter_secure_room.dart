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

  getFirstEntryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                  ElevatedButton(onPressed: () {
                    if (initState == enterFirstStep) {
                      _enteredPassword1 = _controller1.text;
                      _controller1.text = '';
                      infoText = 'Please type password again to continue';
                      Navigator.pop(context);
                      initState = enterPasswordAgain;
                      getFirstEntryDialog();
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
                        });
                        Navigator.pop(context);
                        return;
                      } else {
                        _controller1.text = '';
                        infoText = 'Wrong password, please type the same password as before';
                        Navigator.pop(context);
                        getFirstEntryDialog();
                        return;
                      }
                    }
                  }, child: const Text('Next')),
                ],
              ),
            ),
          );
        });
  }

  getAskPasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                        }
                      },
                      child: const Text('Next'))
                ],
              ),
            ),
          );
        }
    );
  }
}