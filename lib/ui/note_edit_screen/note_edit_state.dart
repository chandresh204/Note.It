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

class NoteEditEditingState extends NoteEditState {
  final String editedText;
  NoteEditEditingState({required this.editedText});
}

class NoteSaved extends NoteEditEditingState {
  NoteSaved({required super.editedText});
}

class NoteError extends NoteEditEditingState {
  final String errorMsg;
  NoteError(this.errorMsg) : super(editedText: '');

  @override
  List<Object?> get props => [errorMsg];
}