part of 'hm_theme_bloc.dart';

abstract class HMThemeState {
  final bool isDarkMode;

  HMThemeState({required this.isDarkMode});
}

class HMThemeInitialState extends HMThemeState {
  HMThemeInitialState({required bool isDarkMode})
    : super(isDarkMode: isDarkMode);
}

class HMThemeChanged extends HMThemeState {
  HMThemeChanged({required bool isDarkMode}) : super(isDarkMode: isDarkMode);
}
