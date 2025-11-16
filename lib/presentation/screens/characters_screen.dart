import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/characters/characters_bloc.dart';
import 'package:test_effective_mobile/presentation/widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CharactersBloc>().add(LoadCharacters());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharactersBloc>().add(LoadMoreCharacters());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            if (state is CharactersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CharactersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CharactersBloc>().add(LoadCharacters());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CharactersLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CharactersBloc>().add(
                    LoadCharacters(refresh: true),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.hasReachedMax
                      ? state.characters.length
                      : state.characters.length + 2,
                  itemBuilder: (context, index) {
                    if (index >= state.characters.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final character = state.characters[index];
                    final isFavorite = state.favoriteIds.contains(character.id);

                    return CharacterCard(
                      character: character,
                      isFavorite: isFavorite,
                      onFavoriteToggle: () {
                        context.read<CharactersBloc>().add(
                          ToggleFavorite(character, !isFavorite),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
