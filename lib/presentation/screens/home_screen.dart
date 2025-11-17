import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/theme/theme_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_effective_mobile/presentation/screens/characters_screen.dart';
import 'package:test_effective_mobile/presentation/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [CharactersScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 1) {
                context.read<FavoritesBloc>().add(LoadFavorites());
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            backgroundColor: Colors.transparent,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.people_outline, size: 24),
                selectedIcon: Icon(Icons.people, size: 24),
                label: 'Персонажи',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_border, size: 24),
                selectedIcon: Icon(Icons.star, size: 24),
                label: 'Избранное',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
          tooltip: 'Toggle Theme',
          elevation: 4,
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Icon(
                state.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 20,
              );
            },
          ),
        ),
      ),
    );
  }
}
