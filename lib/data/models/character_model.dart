import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final LocationModel origin;
  final LocationModel location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    type,
    gender,
    origin,
    location,
    image,
    episode,
    url,
    created,
  ];
}

@JsonSerializable()
class LocationModel extends Equatable {
  final String name;
  final String url;

  const LocationModel({required this.name, required this.url});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  List<Object?> get props => [name, url];
}

@JsonSerializable()
class CharactersResponse extends Equatable {
  final InfoModel info;
  final List<CharacterModel> results;

  const CharactersResponse({required this.info, required this.results});

  factory CharactersResponse.fromJson(Map<String, dynamic> json) =>
      _$CharactersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersResponseToJson(this);

  @override
  List<Object?> get props => [info, results];
}

@JsonSerializable()
class InfoModel extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) =>
      _$InfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$InfoModelToJson(this);

  @override
  List<Object?> get props => [count, pages, next, prev];
}
