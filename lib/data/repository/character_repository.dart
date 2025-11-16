import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:test_effective_mobile/data/api/api_client.dart';
import 'package:test_effective_mobile/data/database/database.dart';
import 'package:test_effective_mobile/data/models/character_model.dart';

class CharacterRepository {
  final ApiClient _apiClient;
  final AppDatabase _database;

  CharacterRepository(this._apiClient, this._database);

  Future<List<CharacterModel>> getCharacters(int page) async {
    try {
      final response = await _apiClient.getCharacters(page);

      // Save to database
      final charactersCompanion = response.results.map((char) {
        return CharactersCompanion(
          id: Value(char.id),
          name: Value(char.name),
          status: Value(char.status),
          species: Value(char.species),
          type: Value(char.type),
          gender: Value(char.gender),
          originName: Value(char.origin.name),
          originUrl: Value(char.origin.url),
          locationName: Value(char.location.name),
          locationUrl: Value(char.location.url),
          image: Value(char.image),
          episodes: Value(jsonEncode(char.episode)),
          url: Value(char.url),
          created: Value(char.created),
        );
      }).toList();

      await _database.insertCharacters(charactersCompanion);

      return response.results;
    } catch (e) {
      // If network fails, load from cache
      if (page == 1) {
        final cachedCharacters = await _database.getAllCharacters();
        return _convertToCharacterModels(cachedCharacters);
      }
      rethrow;
    }
  }

  Future<List<CharacterModel>> getFavoriteCharacters() async {
    final favorites = await _database.getFavoriteCharacters();
    return _convertToCharacterModels(favorites);
  }

  Stream<List<CharacterModel>> watchFavoriteCharacters() {
    return _database.watchFavoriteCharacters().map((characters) {
      return _convertToCharacterModels(characters);
    });
  }

  Future<void> toggleFavorite(int characterId, bool isFavorite) async {
    await _database.toggleFavorite(characterId, isFavorite);
  }

  Future<bool> isFavorite(int characterId) async {
    final character = await _database.getCharacterById(characterId);
    return character?.isFavorite ?? false;
  }

  List<CharacterModel> _convertToCharacterModels(List<Character> characters) {
    return characters.map((char) {
      List<String> episodes = [];
      try {
        episodes = List<String>.from(jsonDecode(char.episodes));
      } catch (e) {
        episodes = [];
      }

      return CharacterModel(
        id: char.id,
        name: char.name,
        status: char.status,
        species: char.species,
        type: char.type,
        gender: char.gender,
        origin: LocationModel(name: char.originName, url: char.originUrl),
        location: LocationModel(name: char.locationName, url: char.locationUrl),
        image: char.image,
        episode: episodes,
        url: char.url,
        created: char.created,
      );
    }).toList();
  }
}
