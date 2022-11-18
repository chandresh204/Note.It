import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'note.dart';
import 'note_dao.dart';

part 'note_database.g.dart';

@Database(version :1, entities : [Note])
abstract class NoteDatabase extends FloorDatabase {

  NoteDao get noteDao;
}