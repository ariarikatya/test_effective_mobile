import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {}

// States
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.light});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
