import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'hm_locale_event.dart';
part 'hm_locale_state.dart';

const String _localeKey = 'preferred_locale';

class HMLocaleBloc extends Bloc<HMLocaleEvent, HMLocaleState> {
  HMLocaleBloc() : super(HMLocaleState()) {
    on<HMLocaleInitEvent>(_onInit);
    on<HMLocaleChangedEvent>(_onLocaleChanged);
  }

  void _onInit(HMLocaleInitEvent event, Emitter<HMLocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? localeCode = prefs.getString(_localeKey);

    if (localeCode != null) {
      emit(state.copyWith(locale: Locale(localeCode)));
    } else {
      // Default to system locale if nothing is saved
      final systemLocale = PlatformDispatcher.instance.locale;
      emit(state.copyWith(locale: Locale(systemLocale.languageCode)));
    }
  }

  void _onLocaleChanged(
    HMLocaleChangedEvent event,
    Emitter<HMLocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, event.locale.languageCode);

    emit(state.copyWith(locale: event.locale));
  }
}
