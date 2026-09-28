import 'package:drift/drift.dart';

class Note extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get note => text()();
  IntColumn get editTime => integer().named('editTime')();
  BoolColumn get isEncrypt => boolean().named('isEncrypt')();
}