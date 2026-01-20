import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

/// ThemeCubit controls switching between light and dark themes.
/// This cubit will be provided at the top of the app (main.dart).
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  /// Toggle between light and dark theme
  void toggleTheme() {
    final isCurrentlyDark = state.themeMode == ThemeMode.dark;

    emit(
      ThemeState(themeMode: isCurrentlyDark ? ThemeMode.light : ThemeMode.dark),
    );
  }

  /// Explicit setters (useful later)
  void setLightTheme() {
    emit(const ThemeState(themeMode: ThemeMode.light));
  }

  void setDarkTheme() {
    emit(const ThemeState(themeMode: ThemeMode.dark));
  }
}
