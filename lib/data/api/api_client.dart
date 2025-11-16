import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_effective_mobile/data/models/character_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://rickandmortyapi.com/api')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/character')
  Future<CharactersResponse> getCharacters(@Query('page') int page);

  @GET('/character/{id}')
  Future<CharacterModel> getCharacter(@Path('id') int id);

  @GET('/character/{ids}')
  Future<List<CharacterModel>> getCharactersByIds(@Path('ids') String ids);
}
