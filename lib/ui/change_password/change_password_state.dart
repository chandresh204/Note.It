abstract class ChangePasswordState {}

class ChangePasswordInit extends ChangePasswordState{
  final String? errorMsg;
  ChangePasswordInit({this.errorMsg});
}

class CreateNewPassword extends ChangePasswordState{}

class ChangePasswordDone extends ChangePasswordState{}