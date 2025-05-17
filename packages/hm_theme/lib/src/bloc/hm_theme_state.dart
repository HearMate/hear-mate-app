part of 'hm_theme_bloc.dart';

abstract class HMThemeState {
  final bool isDarkMode;

  HMThemeState({required this.isDarkMode});
}

class HMThemeInitialState extends HMThemeState {
  HMThemeInitialState({required super.isDarkMode});
}

class HMThemeChanged extends HMThemeState {
  HMThemeChanged({required super.isDarkMode});
}
