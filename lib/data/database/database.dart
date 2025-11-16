import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class Characters extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  TextColumn get species => text()();
  TextColumn get type => text()();
  TextColumn get gender => text()();
  TextColumn get originName => text()();
  TextColumn get originUrl => text()();
  TextColumn get locationName => text()();
  TextColumn get locationUrl => text()();
  TextColumn get image => text()();
  TextColumn get episodes => text()(); // JSON string
  TextColumn get url => text()();
  TextColumn get created => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Characters])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Characters CRUD operations
  Future<List<Character>> getAllCharacters() => select(characters).get();

  Future<List<Character>> getFavoriteCharacters() =>
      (select(characters)..where((c) => c.isFavorite.equals(true))).get();

  Stream<List<Character>> watchFavoriteCharacters() =>
      (select(characters)..where((c) => c.isFavorite.equals(true))).watch();

  Future<Character?> getCharacterById(int id) =>
      (select(characters)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCharacter(CharactersCompanion character) =>
      into(characters).insert(character, mode: InsertMode.insertOrReplace);

  Future<void> insertCharacters(List<CharactersCompanion> characterList) =>
      batch((batch) {
        batch.insertAll(
          characters,
          characterList,
          mode: InsertMode.insertOrReplace,
        );
      });

  Future<bool> updateCharacter(CharactersCompanion character) =>
      update(characters).replace(character);

  Future<int> toggleFavorite(int id, bool isFavorite) =>
      (update(characters)..where((c) => c.id.equals(id))).write(
        CharactersCompanion(isFavorite: Value(isFavorite)),
      );

  Future<int> deleteCharacter(int id) =>
      (delete(characters)..where((c) => c.id.equals(id))).go();

  Future<void> clearCache() => delete(characters).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'characters.sqlite'));
    return NativeDatabase(file);
  });
}
