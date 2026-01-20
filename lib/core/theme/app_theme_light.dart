import 'package:flutter/material.dart';

class AppThemeLight {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,

      // PRIMARY COLORS (from Light SVG)
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4DA3FF), // SVG blue
        secondary: Color(0xFF4DA3FF),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFF5F5F5),
      ),

      scaffoldBackgroundColor: const Color(0xFFFFFFFF),

      // CARD COLORS
      cardColor: const Color(0xFFF5F5F5),

      // DIVIDER / BORDER
      dividerColor: const Color(0xFFE0E0E0),

      // ICON THEME
      iconTheme: const IconThemeData(color: Color(0xFF1F1F1F)),

      // TEXT THEME
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF1F1F1F), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF3C3C3C), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF7A7A7A), fontSize: 12),
        titleLarge: TextStyle(
          color: Color(0xFF1F1F1F),
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),

      // APPBAR
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1F1F1F)),
        titleTextStyle: TextStyle(
          color: Color(0xFF1F1F1F),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // INPUTS
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(),
      ),
    );
  }
}
