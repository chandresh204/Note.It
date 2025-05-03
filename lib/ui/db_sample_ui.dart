import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:note_it2/database/sample.dart';

class DbSampleUi extends StatefulWidget {
  const DbSampleUi({super.key});

  @override
  State<DbSampleUi> createState() => _DbSampleUiState();
}

class _DbSampleUiState extends State<DbSampleUi> {

  final db = SampleDatabase();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: ElevatedButton(onPressed: () async {
            print(await getUsers());
          }, child: Text('Add')),
        ),
    );
  }

  void insertUser() async {
    print('inserting user');
    await db.insertUser(
      const UsersCompanion(
        name: Value('Chad'),
        age: Value(30)
      )
    );
    print('inserting user done');
  }

  Future<List<User>> getUsers() async {
    return await db.getAllUsers();
  }
}
