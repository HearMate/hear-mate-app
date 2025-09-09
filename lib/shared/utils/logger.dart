import 'package:flutter/foundation.dart';

class HMLogger {
  static void print(String? message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
