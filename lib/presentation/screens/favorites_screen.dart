import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/characters/characters_bloc.dart';
import 'package:test_effective_mobile/presentation/widgets/character_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Name'),
              leading: const Icon(Icons.sort_by_alpha),
              onTap: () {
                context.read<FavoritesBloc>().add(SortFavorites(SortType.name));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Status'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                context.read<FavoritesBloc>().add(
                  SortFavorites(SortType.status),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Species'),
              leading: const Icon(Icons.pets),
              onTap: () {
                context.read<FavoritesBloc>().add(
                  SortFavorites(SortType.species),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: _showSortDialog,
                    tooltip: 'Sort',
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FavoritesError) {
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
                              context.read<FavoritesBloc>().add(
                                LoadFavorites(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_border,
                              size: 100,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No favorites yet',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add characters to your favorites\nfrom the main screen',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final character = state.favorites[index];

                        return Dismissible(
                          key: Key(character.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          onDismissed: (direction) {
                            context.read<FavoritesBloc>().add(
                              RemoveFromFavorites(character),
                            );
                            context.read<CharactersBloc>().add(
                              ToggleFavorite(character, false),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${character.name} removed from favorites',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: CharacterCard(
                            character: character,
                            isFavorite: true,
                            onFavoriteToggle: () {
                              context.read<FavoritesBloc>().add(
                                RemoveFromFavorites(character),
                              );
                              context.read<CharactersBloc>().add(
                                ToggleFavorite(character, false),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
