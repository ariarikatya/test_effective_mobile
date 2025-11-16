import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:test_effective_mobile/data/api/api_client.dart';
import 'package:test_effective_mobile/data/database/database.dart';
import 'package:test_effective_mobile/data/repository/character_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Dio
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Add logging interceptor
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  getIt.registerSingleton<Dio>(dio);

  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient(getIt<Dio>()));

  // Repository
  getIt.registerSingleton<CharacterRepository>(
    CharacterRepository(getIt<ApiClient>(), getIt<AppDatabase>()),
  );
}
