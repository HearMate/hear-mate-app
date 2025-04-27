library hm_theme;

import 'package:flutter/material.dart';

export 'src/bloc/hm_theme_bloc.dart';

ThemeData buildHearMateTheme({required bool isDarkMode}) {
  const echoParseRed = Color(0xFFF94F46);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: echoParseRed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: echoParseRed,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 64.0,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(fontSize: 16.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
