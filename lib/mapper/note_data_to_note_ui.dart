import 'package:note_it/util/date_time_converter.dart';

import '../data/encryption/encrypt_decrypt.dart';
import '../database/note_database.dart';
import '../ui/model/note_item.dart';

extension ToNoteItem on List<NoteData> {
  List<NoteItem> toNoteItem() {
    return map((note) => NoteItem(
      id: note.id,
      noteText: note.isEncrypt ? EncDec.getDecryptText(note.note) : note.note,
      createdTime: note.id.toReadableDateTime(),
      lastEditTime: note.editTime.toReadableDateTime(),
    )).toList();
  }
}