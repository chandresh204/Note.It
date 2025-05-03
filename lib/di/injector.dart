import 'package:get_it/get_it.dart';
import 'package:note_it2/data/local/local_data_source_impl.dart';
import 'package:note_it2/data/local/local_data_source.dart';
import 'package:note_it2/data/native/native_date_source.dart';
import 'package:note_it2/data/native/notive_data_source_impl.dart';
import 'package:note_it2/database/note_database.dart';
import 'package:note_it2/repository/backup_repository.dart';
import 'package:note_it2/repository/note_repository.dart';

final getIt = GetIt.instance;

void setupLocators() {
  getIt.registerLazySingleton<NoteDatabase>(() => NoteDatabase());
  getIt.registerLazySingleton<NativeDataSource>(() => NativeDataSourceImpl());
  getIt.registerLazySingleton<LocalDataSource>(() =>
      LocalDataSourceImpl(getIt<NoteDatabase>()));
  getIt.registerLazySingleton<NoteRepository>(() =>
      NoteRepository(getIt<LocalDataSource>(), getIt<NativeDataSource>()));
  getIt.registerLazySingleton<BackupRepository>(() =>
      BackupRepository(getIt<LocalDataSource>()));
}