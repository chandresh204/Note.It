// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorNoteDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$NoteDatabaseBuilder databaseBuilder(String name) =>
      _$NoteDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$NoteDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$NoteDatabaseBuilder(null);
}

class _$NoteDatabaseBuilder {
  _$NoteDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$NoteDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$NoteDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<NoteDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$NoteDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$NoteDatabase extends NoteDatabase {
  _$NoteDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NoteDao? _noteDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`id` INTEGER NOT NULL, `note` TEXT NOT NULL, `editTime` INTEGER NOT NULL, `isEncrypt` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'note': item.note,
                  'editTime': item.editTime,
                  'isEncrypt': item.isEncrypt ? 1 : 0
                }),
        _noteDeletionAdapter = DeletionAdapter(
            database,
            'Note',
            ['id'],
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'note': item.note,
                  'editTime': item.editTime,
                  'isEncrypt': item.isEncrypt ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final DeletionAdapter<Note> _noteDeletionAdapter;

  @override
  Future<Note?> getNoteFromId(int id) async {
    return _queryAdapter.query('select * from Note where id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            row['id'] as int,
            row['note'] as String,
            row['editTime'] as int,
            (row['isEncrypt'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Note>> getAllNotes(bool isEnc) async {
    return _queryAdapter.queryList(
        'select * from Note where isEncrypt = ?1 order by editTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['id'] as int,
            row['note'] as String,
            row['editTime'] as int,
            (row['isEncrypt'] as int) != 0),
        arguments: [isEnc ? 1 : 0]);
  }

  @override
  Future<void> insertOneNote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertRestoredNotes(List<Note> notes) async {
    await _noteInsertionAdapter.insertList(notes, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _noteDeletionAdapter.delete(note);
  }
}
