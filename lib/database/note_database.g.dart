// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_database.dart';

// ignore_for_file: type=lint
class $NoteTable extends Note with TableInfo<$NoteTable, NoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editTimeMeta = const VerificationMeta(
    'editTime',
  );
  @override
  late final GeneratedColumn<int> editTime = GeneratedColumn<int>(
    'editTime',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEncryptMeta = const VerificationMeta(
    'isEncrypt',
  );
  @override
  late final GeneratedColumn<bool> isEncrypt = GeneratedColumn<bool>(
    'isEncrypt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isEncrypt" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, note, editTime, isEncrypt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('editTime')) {
      context.handle(
        _editTimeMeta,
        editTime.isAcceptableOrUnknown(data['editTime']!, _editTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_editTimeMeta);
    }
    if (data.containsKey('isEncrypt')) {
      context.handle(
        _isEncryptMeta,
        isEncrypt.isAcceptableOrUnknown(data['isEncrypt']!, _isEncryptMeta),
      );
    } else if (isInserting) {
      context.missing(_isEncryptMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      note:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}note'],
          )!,
      editTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}editTime'],
          )!,
      isEncrypt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}isEncrypt'],
          )!,
    );
  }

  @override
  $NoteTable createAlias(String alias) {
    return $NoteTable(attachedDatabase, alias);
  }
}

class NoteData extends DataClass implements Insertable<NoteData> {
  final int id;
  final String note;
  final int editTime;
  final bool isEncrypt;
  const NoteData({
    required this.id,
    required this.note,
    required this.editTime,
    required this.isEncrypt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note'] = Variable<String>(note);
    map['editTime'] = Variable<int>(editTime);
    map['isEncrypt'] = Variable<bool>(isEncrypt);
    return map;
  }

  NoteCompanion toCompanion(bool nullToAbsent) {
    return NoteCompanion(
      id: Value(id),
      note: Value(note),
      editTime: Value(editTime),
      isEncrypt: Value(isEncrypt),
    );
  }

  factory NoteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteData(
      id: serializer.fromJson<int>(json['id']),
      note: serializer.fromJson<String>(json['note']),
      editTime: serializer.fromJson<int>(json['editTime']),
      isEncrypt: serializer.fromJson<bool>(json['isEncrypt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'note': serializer.toJson<String>(note),
      'editTime': serializer.toJson<int>(editTime),
      'isEncrypt': serializer.toJson<bool>(isEncrypt),
    };
  }

  NoteData copyWith({int? id, String? note, int? editTime, bool? isEncrypt}) =>
      NoteData(
        id: id ?? this.id,
        note: note ?? this.note,
        editTime: editTime ?? this.editTime,
        isEncrypt: isEncrypt ?? this.isEncrypt,
      );
  NoteData copyWithCompanion(NoteCompanion data) {
    return NoteData(
      id: data.id.present ? data.id.value : this.id,
      note: data.note.present ? data.note.value : this.note,
      editTime: data.editTime.present ? data.editTime.value : this.editTime,
      isEncrypt: data.isEncrypt.present ? data.isEncrypt.value : this.isEncrypt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteData(')
          ..write('id: $id, ')
          ..write('note: $note, ')
          ..write('editTime: $editTime, ')
          ..write('isEncrypt: $isEncrypt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, note, editTime, isEncrypt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteData &&
          other.id == this.id &&
          other.note == this.note &&
          other.editTime == this.editTime &&
          other.isEncrypt == this.isEncrypt);
}

class NoteCompanion extends UpdateCompanion<NoteData> {
  final Value<int> id;
  final Value<String> note;
  final Value<int> editTime;
  final Value<bool> isEncrypt;
  const NoteCompanion({
    this.id = const Value.absent(),
    this.note = const Value.absent(),
    this.editTime = const Value.absent(),
    this.isEncrypt = const Value.absent(),
  });
  NoteCompanion.insert({
    this.id = const Value.absent(),
    required String note,
    required int editTime,
    required bool isEncrypt,
  }) : note = Value(note),
       editTime = Value(editTime),
       isEncrypt = Value(isEncrypt);
  static Insertable<NoteData> custom({
    Expression<int>? id,
    Expression<String>? note,
    Expression<int>? editTime,
    Expression<bool>? isEncrypt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (note != null) 'note': note,
      if (editTime != null) 'editTime': editTime,
      if (isEncrypt != null) 'isEncrypt': isEncrypt,
    });
  }

  NoteCompanion copyWith({
    Value<int>? id,
    Value<String>? note,
    Value<int>? editTime,
    Value<bool>? isEncrypt,
  }) {
    return NoteCompanion(
      id: id ?? this.id,
      note: note ?? this.note,
      editTime: editTime ?? this.editTime,
      isEncrypt: isEncrypt ?? this.isEncrypt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (editTime.present) {
      map['editTime'] = Variable<int>(editTime.value);
    }
    if (isEncrypt.present) {
      map['isEncrypt'] = Variable<bool>(isEncrypt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteCompanion(')
          ..write('id: $id, ')
          ..write('note: $note, ')
          ..write('editTime: $editTime, ')
          ..write('isEncrypt: $isEncrypt')
          ..write(')'))
        .toString();
  }
}

abstract class _$NoteDatabase extends GeneratedDatabase {
  _$NoteDatabase(QueryExecutor e) : super(e);
  $NoteDatabaseManager get managers => $NoteDatabaseManager(this);
  late final $NoteTable note = $NoteTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [note];
}

typedef $$NoteTableCreateCompanionBuilder =
    NoteCompanion Function({
      Value<int> id,
      required String note,
      required int editTime,
      required bool isEncrypt,
    });
typedef $$NoteTableUpdateCompanionBuilder =
    NoteCompanion Function({
      Value<int> id,
      Value<String> note,
      Value<int> editTime,
      Value<bool> isEncrypt,
    });

class $$NoteTableFilterComposer extends Composer<_$NoteDatabase, $NoteTable> {
  $$NoteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get editTime => $composableBuilder(
    column: $table.editTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEncrypt => $composableBuilder(
    column: $table.isEncrypt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteTableOrderingComposer extends Composer<_$NoteDatabase, $NoteTable> {
  $$NoteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get editTime => $composableBuilder(
    column: $table.editTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEncrypt => $composableBuilder(
    column: $table.isEncrypt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteTableAnnotationComposer
    extends Composer<_$NoteDatabase, $NoteTable> {
  $$NoteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get editTime =>
      $composableBuilder(column: $table.editTime, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypt =>
      $composableBuilder(column: $table.isEncrypt, builder: (column) => column);
}

class $$NoteTableTableManager
    extends
        RootTableManager<
          _$NoteDatabase,
          $NoteTable,
          NoteData,
          $$NoteTableFilterComposer,
          $$NoteTableOrderingComposer,
          $$NoteTableAnnotationComposer,
          $$NoteTableCreateCompanionBuilder,
          $$NoteTableUpdateCompanionBuilder,
          (NoteData, BaseReferences<_$NoteDatabase, $NoteTable, NoteData>),
          NoteData,
          PrefetchHooks Function()
        > {
  $$NoteTableTableManager(_$NoteDatabase db, $NoteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NoteTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NoteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NoteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> editTime = const Value.absent(),
                Value<bool> isEncrypt = const Value.absent(),
              }) => NoteCompanion(
                id: id,
                note: note,
                editTime: editTime,
                isEncrypt: isEncrypt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String note,
                required int editTime,
                required bool isEncrypt,
              }) => NoteCompanion.insert(
                id: id,
                note: note,
                editTime: editTime,
                isEncrypt: isEncrypt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteTableProcessedTableManager =
    ProcessedTableManager<
      _$NoteDatabase,
      $NoteTable,
      NoteData,
      $$NoteTableFilterComposer,
      $$NoteTableOrderingComposer,
      $$NoteTableAnnotationComposer,
      $$NoteTableCreateCompanionBuilder,
      $$NoteTableUpdateCompanionBuilder,
      (NoteData, BaseReferences<_$NoteDatabase, $NoteTable, NoteData>),
      NoteData,
      PrefetchHooks Function()
    >;

class $NoteDatabaseManager {
  final _$NoteDatabase _db;
  $NoteDatabaseManager(this._db);
  $$NoteTableTableManager get note => $$NoteTableTableManager(_db, _db.note);
}
