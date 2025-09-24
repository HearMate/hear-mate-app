import 'package:flutter/material.dart';

class LocaleProvider extends InheritedWidget {
  const LocaleProvider({
    super.key,
    required super.child,
    required this.locale,
    required this.setLocale,
  });

  final Locale? locale;
  final void Function(Locale locale) setLocale;

  static LocaleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
  }

  @override
  bool updateShouldNotify(LocaleProvider oldWidget) {
    return locale != oldWidget.locale;
  }
}