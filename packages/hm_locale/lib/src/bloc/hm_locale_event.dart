part of 'hm_locale_bloc.dart';

abstract class HMLocaleEvent {}

class HMLocaleInitEvent extends HMLocaleEvent {}

class HMLocaleChangedEvent extends HMLocaleEvent {
  final Locale locale;

  HMLocaleChangedEvent(this.locale);
}
