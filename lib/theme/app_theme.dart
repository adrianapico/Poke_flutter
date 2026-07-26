import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF00E676);

  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
    textTheme: _textTheme,
    useMaterial3: true,
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    useMaterial3: true,
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),

  );

  static const TextTheme _textTheme = TextTheme(
    titleLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 15),
  );
}
