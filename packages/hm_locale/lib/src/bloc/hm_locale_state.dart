part of 'hm_locale_bloc.dart';

class HMLocaleState {
  final Locale? locale;

  HMLocaleState({this.locale});

  HMLocaleState copyWith({Locale? locale}) {
    return HMLocaleState(locale: locale ?? this.locale);
  }
}
