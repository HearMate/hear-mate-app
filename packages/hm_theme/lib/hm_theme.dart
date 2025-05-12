import 'package:flutter/material.dart';

export 'src/bloc/hm_theme_bloc.dart';

ThemeData buildHearMateTheme({required bool isDarkMode}) {
  const echoParseRed = Color(0xFFF94F46);

  const TextTheme customTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 64.0,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      fontSize: 20.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(fontSize: 16.0),
  );

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: echoParseRed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: echoParseRed,
    ),
    textTheme: customTextTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(252, 48),
        padding: const EdgeInsets.all(8.0),
        backgroundColor: echoParseRed,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(252, 48),
      ),
    ),
  );
}
