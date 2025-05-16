import 'package:flutter/material.dart';

export 'src/bloc/hm_theme_bloc.dart';

class AppColors {
  static const red = Color(0xFFF94F46);
  static const green = Colors.teal;
  static const white = Colors.white;
}


ThemeData buildHearMateTheme({required bool isDarkMode}) {

  const TextTheme customTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.0
    ),
    bodyMedium: TextStyle(fontSize: 16.0),
  );

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
  );

  return ThemeData(
    useMaterial3: true, // ✅ Enables Material 3
    colorScheme: colorScheme,
    textTheme: customTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: defaultFilledButtonStyle(colorScheme)
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(252, 48)),
        foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        side: WidgetStateProperty.all(
          BorderSide(color: colorScheme.primary),
        ),
      ),
    ),
  );
}

ButtonStyle attentionFilledButtonStyle(ColorScheme colorScheme) {
  return ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(252, 48)),
    padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
    backgroundColor: WidgetStateProperty.all(AppColors.red),
    foregroundColor: WidgetStateProperty.all(AppColors.white),
    textStyle: WidgetStateProperty.all(const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    )),
  );
}

ButtonStyle defaultFilledButtonStyle(ColorScheme colorScheme) {
  return ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(252, 48)),
    padding: WidgetStateProperty.all(const EdgeInsets.all(8.0)),
    backgroundColor: WidgetStateProperty.all(colorScheme.primary),
    foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
    textStyle: WidgetStateProperty.all(const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    )),
  );
}