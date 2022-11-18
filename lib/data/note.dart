import 'package:floor/floor.dart';

@entity
class Note {

  @primaryKey
  final int id;
  final String note;
  final int editTime;
  final bool isEncrypt;

  Note(this.id, this.note, this.editTime, this.isEncrypt);

  Map toJson() => {
    'id' : id,
    'note' : note,
    'editTime' : editTime,
    'isEncrypt' : isEncrypt
  };

  factory Note.fromJson(dynamic json) {
    return Note(json['id'], json['note'], json['editTime'], json['isEncrypt']);
  }
}