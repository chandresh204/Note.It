abstract class ChangePasswordState {}

class ChangePasswordInit extends ChangePasswordState{
  final String? errorMsg;
  ChangePasswordInit({this.errorMsg});
}

class CreateNewPassword extends ChangePasswordState{
  final String? errorMsg;
  CreateNewPassword({required this.errorMsg});
}

class ChangePasswordDone extends ChangePasswordState{}