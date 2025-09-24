import 'package:flutter/material.dart';
import 'package:hm_theme/hm_theme.dart';

class Languages {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
    Locale('de'),
  ];

  static List<DropdownMenuEntry<Locale>> getDropdownMenuEntries() {
    return supportedLocales.map((locale) {
      return DropdownMenuEntry<Locale>(
        style: dropdownEntriesStyle(),
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
      case 'uk':
        return 'Yкраїнська';
      case 'de':
        return 'Deutsch';
      default:
        return 'Unknown';
    }
  }
}
