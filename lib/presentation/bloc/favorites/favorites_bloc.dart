import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_effective_mobile/data/models/character_model.dart';
import 'package:test_effective_mobile/data/repository/character_repository.dart';

// Events
abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class SortFavorites extends FavoritesEvent {
  final SortType sortType;

  SortFavorites(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

class RemoveFromFavorites extends FavoritesEvent {
  final CharacterModel character;

  RemoveFromFavorites(this.character);

  @override
  List<Object?> get props => [character];
}

enum SortType { name, status, species }

// States
abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<CharacterModel> favorites;
  final SortType currentSort;

  FavoritesLoaded({required this.favorites, this.currentSort = SortType.name});

  FavoritesLoaded copyWith({
    List<CharacterModel>? favorites,
    SortType? currentSort,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      currentSort: currentSort ?? this.currentSort,
    );
  }

  @override
  List<Object?> get props => [favorites, currentSort];
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CharacterRepository _repository;

  FavoritesBloc(this._repository) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<SortFavorites>(_onSortFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());

      final favorites = await _repository.getFavoriteCharacters();
      final sorted = _sortCharacters(favorites, SortType.name);

      emit(FavoritesLoaded(favorites: sorted));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onSortFavorites(
    SortFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final sorted = _sortCharacters(currentState.favorites, event.sortType);
      emit(
        currentState.copyWith(favorites: sorted, currentSort: event.sortType),
      );
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      await _repository.toggleFavorite(event.character.id, false);

      final updatedFavorites = currentState.favorites
          .where((c) => c.id != event.character.id)
          .toList();

      emit(currentState.copyWith(favorites: updatedFavorites));
    }
  }

  List<CharacterModel> _sortCharacters(
    List<CharacterModel> characters,
    SortType sortType,
  ) {
    final sorted = List<CharacterModel>.from(characters);

    switch (sortType) {
      case SortType.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.status:
        sorted.sort((a, b) => a.status.compareTo(b.status));
        break;
      case SortType.species:
        sorted.sort((a, b) => a.species.compareTo(b.species));
        break;
    }

    return sorted;
  }
}
