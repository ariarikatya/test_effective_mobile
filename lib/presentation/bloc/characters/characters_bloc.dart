import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_effective_mobile/data/models/character_model.dart';
import 'package:test_effective_mobile/data/repository/character_repository.dart';

// Events
abstract class CharactersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharactersEvent {
  final bool refresh;

  LoadCharacters({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreCharacters extends CharactersEvent {}

class ToggleFavorite extends CharactersEvent {
  final CharacterModel character;
  final bool isFavorite;

  ToggleFavorite(this.character, this.isFavorite);

  @override
  List<Object?> get props => [character, isFavorite];
}

// States
abstract class CharactersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<CharacterModel> characters;
  final int currentPage;
  final bool hasReachedMax;
  final Set<int> favoriteIds;

  CharactersLoaded({
    required this.characters,
    required this.currentPage,
    required this.hasReachedMax,
    required this.favoriteIds,
  });

  CharactersLoaded copyWith({
    List<CharacterModel>? characters,
    int? currentPage,
    bool? hasReachedMax,
    Set<int>? favoriteIds,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    currentPage,
    hasReachedMax,
    favoriteIds,
  ];
}

class CharactersError extends CharactersState {
  final String message;

  CharactersError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepository _repository;

  CharactersBloc(this._repository) : super(CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    try {
      if (!event.refresh) {
        emit(CharactersLoading());
      }

      final characters = await _repository.getCharacters(1);
      final favorites = await _repository.getFavoriteCharacters();
      final favoriteIds = favorites.map((c) => c.id).toSet();

      emit(
        CharactersLoaded(
          characters: characters,
          currentPage: 1,
          hasReachedMax: false,
          favoriteIds: favoriteIds,
        ),
      );
    } catch (e) {
      emit(CharactersError(e.toString()));
    }
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    final currentState = state;
    if (currentState is CharactersLoaded && !currentState.hasReachedMax) {
      try {
        final nextPage = currentState.currentPage + 1;
        final newCharacters = await _repository.getCharacters(nextPage);

        if (newCharacters.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              characters: [...currentState.characters, ...newCharacters],
              currentPage: nextPage,
            ),
          );
        }
      } catch (e) {
        emit(currentState.copyWith(hasReachedMax: true));
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<CharactersState> emit,
  ) async {
    final currentState = state;
    if (currentState is CharactersLoaded) {
      await _repository.toggleFavorite(event.character.id, event.isFavorite);

      final updatedFavoriteIds = Set<int>.from(currentState.favoriteIds);
      if (event.isFavorite) {
        updatedFavoriteIds.add(event.character.id);
      } else {
        updatedFavoriteIds.remove(event.character.id);
      }

      emit(currentState.copyWith(favoriteIds: updatedFavoriteIds));
    }
  }
}
