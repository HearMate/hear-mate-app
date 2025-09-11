import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Add this import

class Cooldown {
  static Future<void> startCooldown(Duration cooldownDuration) async {
    final prefs = await SharedPreferences.getInstance();
    final cooldownEnd =
        DateTime.now().add(cooldownDuration).millisecondsSinceEpoch;
    await prefs.setInt('cooldown_end', cooldownEnd);
  }

  static Future<bool> isCooldownActive() async {
    if (kDebugMode) return false; // Always false in debug mode
    final prefs = await SharedPreferences.getInstance();
    final cooldownEnd = prefs.getInt('cooldown_end') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now < cooldownEnd;
  }
}
