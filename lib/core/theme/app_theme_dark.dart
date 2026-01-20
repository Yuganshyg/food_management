import 'package:flutter/material.dart';

class AppThemeDark {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4DA3FF),
        secondary: Color(0xFF4DA3FF),
        background: Color(0xFF0F0F0F),
        surface: Color(0xFF2E2E38),
      ),

      scaffoldBackgroundColor: const Color(0xFF0F0F0F),

      cardColor: const Color(0xFF2E2E38),

      dividerColor: const Color(0xFF3A3A3A),

      iconTheme: const IconThemeData(color: Colors.white),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFD0D0D0), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF9A9A9A), fontSize: 12),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F0F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(),
      ),
    );
  }
}
