import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_effective_mobile/core/di/injection.dart';
import 'package:test_effective_mobile/core/theme/app_theme.dart';
import 'package:test_effective_mobile/data/repository/character_repository.dart';
import 'package:test_effective_mobile/presentation/bloc/characters/characters_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:test_effective_mobile/presentation/bloc/theme/theme_bloc.dart';
import 'package:test_effective_mobile/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependencies
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create: (context) => CharactersBloc(getIt<CharacterRepository>()),
        ),
        BlocProvider(
          create: (context) => FavoritesBloc(getIt<CharacterRepository>()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Rick and Morty',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
