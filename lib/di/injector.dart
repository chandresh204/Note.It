import 'package:get_it/get_it.dart';

import '../data/local/local_data_source.dart';
import '../data/local/local_data_source_impl.dart';
import '../data/native/native_date_source.dart';
import '../data/native/native_data_source_impl.dart';
import '../database/note_database.dart';
import '../repository/backup_repository.dart';
import '../repository/note_repository.dart';

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