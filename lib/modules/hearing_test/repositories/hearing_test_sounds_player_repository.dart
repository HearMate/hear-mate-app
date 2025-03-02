import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';

class HearingTestSoundsPlayerRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<int, String> _soundAssets = {};

  final List<int> frequencies = [125, 250, 500, 1000, 2000, 4000, 8000];

  // Duration for each tone
  final Duration soundDuration = Duration(seconds: 1);

  Future<void> initialize() async {
    for (int freq in frequencies) {
      String path = 'assets/tone_${freq}Hz.wav';
      _soundAssets[freq] = path;
      // this will probably cache these sounds in audio player, but I'm not sure
      _loadSound(path);
    }
  }

  Future<void> playSound(int frequency, {required double decibels}) async {
    if (_soundAssets.containsKey(frequency)) {
      String assetPath = _soundAssets[frequency]!;
      await _loadSound(assetPath);

      double volume = _decibelsToVolume(decibels);
      await _audioPlayer.setVolume(volume);

      await _audioPlayer.play();

      Future.delayed(soundDuration, () {
        _audioPlayer.stop();
      });
    } else {
      print('No sound found for frequency $frequency Hz');
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  Future<void> _loadSound(String assetPath) async {
    try {
      final audioSource = AudioSource.asset(assetPath);

      await _audioPlayer.setAudioSource(audioSource);
    } catch (e) {
      print("Error loading sound file: $e");
    }
  }

  // This function will need some work, to be honest I don't know how to scale decibels to volume parameter needed by AudioPlayer.
  // Right now it is exponentialy scaled, and I hear the difference. With logarithimic one it was too small...
  double _decibelsToVolume(double decibels) {
    // Clamp decibels between -10 and 120 dB
    decibels = decibels.clamp(-10.0, 120.0);

    // Exponential scaling factor for more pronounced differences
    double volume;

    // For negative decibels, scale it exponentially
    if (decibels < 0) {
      volume = 0.1 * (pow(10.0, decibels / 20));
    } else {
      // For positive decibels, apply a higher scaling factor for noticeable change
      volume = 0.05 * (pow(10.0, decibels / 20));
    }

    // Clamp the final volume value between 0.0 and 1.0
    return volume.clamp(0.0, 1.0);
  }
}
