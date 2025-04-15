import 'package:flutter/material.dart';

class Languages {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('pl'),
  ];

  static List<DropdownMenuEntry<Locale>> getDropdownMenuEntries() {
    return supportedLocales.map((locale) {
      return DropdownMenuEntry<Locale>(
        value: locale,
        label: getLanguageName(locale),
      );
    }).toList();
  }

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'pl':
        return 'Polski';
      default:
        return 'Unknown';
    }
  }
}
