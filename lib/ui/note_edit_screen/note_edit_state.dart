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

class NoteEditEditingState extends NoteEditState {}

class NoteSaved extends NoteEditEditingState {}

class NoteError extends NoteEditEditingState {
  final String errorMsg;
  NoteError(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}