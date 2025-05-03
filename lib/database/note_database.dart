import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'model/note.dart';

part 'note_database.g.dart';

@DriftDatabase(tables: [Note])
class NoteDatabase extends _$NoteDatabase {
  NoteDatabase() : super(_openConnection());

  NoteDatabase.test() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  Future<int> insertNote(NoteCompanion note) => into(this.note).insert(note);

  Future<void> insertMultipleNotes(List<NoteCompanion> notes) async {
    await batch((batch) {
      batch.insertAll(note, notes);
    });
  }

  Future<List<NoteData>> getNotesThatContains(String text, bool encrypted) =>
      (select(note)
            ..where((n) => n.isEncrypt.equals(encrypted))
            ..where((tbl) => tbl.note.lower().like('%$text%'))
            ..orderBy([(t) => OrderingTerm.desc(t.editTime)]))
          .get();

  Future<NoteData?> getNoteById(int id) =>
      (select(note)..where((n) => n.id.equals(id))).getSingleOrNull();

  Future<bool> updateNote(NoteData note) => update(this.note).replace(note);

  Stream<List<NoteData>> watchAllNotes(bool encrypted) {
    return (select(note)
          ..where((n) => n.isEncrypt.equals(encrypted))
          ..orderBy([(t) => OrderingTerm.desc(t.editTime)]))
        .watch();
  }

  Future<int> deleteNote(int id) =>
      (delete(note)..where((n) => n.id.equals(id))).go();

  Future<List<NoteData>> getAllNotes(bool encrypted) =>
      (select(note)
            ..where((n) => n.isEncrypt.equals(encrypted))
            ..orderBy([(t) => OrderingTerm.desc(t.editTime)]))
          .get();
}

LazyDatabase _openConnection() {
  // path: /data/user/0/chad.orionsoft.note_it/databases/note-database.db
  final dbPath = Platform.isAndroid ?
    '/data/user/0/chad.orionsoft.note_it/databases/note-database.db' : '/home/chad/note-database.db';
  return LazyDatabase(() async {
    final dbFile = File(dbPath);
    print("db path: $dbFile");
    return NativeDatabase(dbFile);
  });
}
