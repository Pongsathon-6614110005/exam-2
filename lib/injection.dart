import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_vision_journal/config/env.dart';
import 'package:smart_vision_journal/core/settings/settings_repository.dart';
import 'package:smart_vision_journal/core/settings/theme_cubit.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_local_data_source.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_remote_data_source.dart';
import 'package:smart_vision_journal/features/note/data/datasources/summary_cache_data_source.dart';
import 'package:smart_vision_journal/features/note/data/repositories/note_repository_impl.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/add_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/get_notes.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/delete_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/summarize_text.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/update_note.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';

import 'package:smart_vision_journal/services/llm_service.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_schema.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===================== EXTERNAL =====================

  // Dio
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.geminiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['key'] = Env.geminiApiKey;
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ),
  );

  sl.registerLazySingleton(() => dio);

  // Hive (cache)
  await Hive.initFlutter();
  final summaryBox = await Hive.openBox<String>('summaryCache');
  sl.registerSingleton(summaryBox);

  // SharedPreferences (settings)
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Isar (local database)
  final appDirectory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NoteSchemaSchema],
    directory: appDirectory.path,
  );
  sl.registerSingleton<Isar>(isar);

  // ===================== SERVICES =====================

  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(prefs));
  sl.registerLazySingleton(() => ThemeCubit(sl()));

  sl.registerLazySingleton(() => LlmService(
        sl(),
        apiKey: Env.geminiApiKey,
        model: Env.geminiModel,
      ));

  // ===================== DATASOURCES =====================

  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<SummaryCacheDataSource>(
    () => SummaryCacheDataSourceImpl(sl()),
  );

  // ===================== REPOSITORY =====================

  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );

  // ===================== USECASES =====================

  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => SummarizeText(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // ===================== BLOC =====================

  sl.registerFactory(
    () => NoteBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}