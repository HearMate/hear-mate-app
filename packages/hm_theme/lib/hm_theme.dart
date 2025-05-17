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
    labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
    bodyMedium: TextStyle(fontSize: 16.0),
  );

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: customTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    filledButtonTheme:
        FilledButtonThemeData(style: defaultFilledButtonStyle(colorScheme)),
    outlinedButtonTheme:
        OutlinedButtonThemeData(style: defaultOutlinedButtonStyle(colorScheme)),
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
    padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
    backgroundColor: WidgetStateProperty.all(colorScheme.primary),
    foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
    textStyle: WidgetStateProperty.all(const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    )),
  );
}

ButtonStyle defaultOutlinedButtonStyle(ColorScheme colorScheme) {
  return ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(252, 48)),
    padding: WidgetStateProperty.all(const EdgeInsets.all(12.0)),
    foregroundColor: WidgetStateProperty.all(colorScheme.primary),
    side: WidgetStateProperty.all(
      BorderSide(color: colorScheme.primary),
    ),
  );
}

TextStyle textStylePickedOptionGreen() {
  return TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.green,
  );
}

InputDecorationTheme inputDecorationDropownMenu() {
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.only(left: 8.0),
  );
}

ButtonStyle dropdownEntriesStyle() {
  return ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
    ),
  );
}
