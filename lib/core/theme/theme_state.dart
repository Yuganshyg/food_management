import 'package:flutter/material.dart';

/// ThemeState represents the current theme mode of the app.
/// We use Flutter's built-in ThemeMode to stay compatible
/// with MaterialApp and system theming.
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  /// Helper getters (optional but clean)
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;

  /// Copy method for future extensibility
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}
