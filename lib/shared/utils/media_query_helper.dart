import 'package:flutter/material.dart';

class MediaQueryHelper {
  static bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 700;
  }
}
