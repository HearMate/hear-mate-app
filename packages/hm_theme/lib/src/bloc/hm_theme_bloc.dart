import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'hm_theme_event.dart';
part 'hm_theme_state.dart';

class HMThemeBloc extends Bloc<HMThemeEvent, HMThemeState> {
  HMThemeBloc() : super(HMThemeInitialState(isDarkMode: false)) {
    on<HMTHemeInitEvent>(_onInitTheme);
    on<HMThemeToggleEvent>(_onToggleTheme);
  }

  Future<void> _onInitTheme(
    HMTHemeInitEvent event,
    Emitter<HMThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(HMThemeChanged(isDarkMode: isDarkMode));
  }

  Future<void> _onToggleTheme(
    HMThemeToggleEvent event,
    Emitter<HMThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = !state.isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
    emit(HMThemeChanged(isDarkMode: isDarkMode));
  }
}
