import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'model/Users.dart';

part 'sample.g.dart';

@DriftDatabase(tables: [Users])
class SampleDatabase extends _$SampleDatabase{

  SampleDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Step 3: DAO-like methods
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
  Future<List<User>> getAllUsers() => select(users).get();
  Future updateUser(User user) => update(users).replace(user);
  Future deleteUser(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  Future<List<User>> getUsersWithAge(int age) =>
     (select(users)..where((u) => u.age.equals(age))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'app.db'));
    print('db location: ${dbFile.path}');
    return NativeDatabase(dbFile);
  });
}