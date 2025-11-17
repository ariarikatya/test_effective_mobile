import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:test_effective_mobile/data/api/api_client.dart';
import 'package:test_effective_mobile/data/database/database.dart';
import 'package:test_effective_mobile/data/repository/character_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<ApiClient>(ApiClient(getIt<Dio>()));

  getIt.registerSingleton<CharacterRepository>(
    CharacterRepository(getIt<ApiClient>(), getIt<AppDatabase>()),
  );
}
