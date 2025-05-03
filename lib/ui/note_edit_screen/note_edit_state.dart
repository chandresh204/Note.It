import 'package:equatable/equatable.dart';

abstract class NoteEditState extends Equatable {

  @override
  List<Object?> get props => [];
}

class NoteEditIdle extends NoteEditState {
  final String? initNote;
  NoteEditIdle({this.initNote});

  @override
  List<Object?> get props => [initNote];
}

class NoteSaved extends NoteEditIdle {}

class NoteError extends NoteEditIdle {
  final String errorMsg;
  NoteError(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}