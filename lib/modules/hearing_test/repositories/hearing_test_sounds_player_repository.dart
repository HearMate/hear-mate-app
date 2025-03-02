import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class HearingTestSoundsPlayerRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<int, Map<String, String>> _soundAssets =
      {}; // Stores both left and right variants
  final List<int> frequencies = [125, 250, 500, 1000, 2000, 4000, 8000];

  // Duration for each tone
  final Duration soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in frequencies) {
      String basePath = 'tone_${freq}Hz';
      String leftPath = '${basePath}_left.wav';
      String rightPath = '${basePath}_right.wav';

      _soundAssets[freq] = {'left': leftPath, 'right': rightPath};
    }

    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playSound(
    int frequency, {
    required double decibels,
    required bool leftEarOnly,
  }) async {
    if (_soundAssets.containsKey(frequency)) {
      try {
        String assetPath =
            leftEarOnly
                ? _soundAssets[frequency]!['left']!
                : _soundAssets[frequency]!['right']!;

        double volume = _decibelsToVolume(decibels);

        await _audioPlayer.setSource(AssetSource(assetPath));
        await _audioPlayer.setVolume(volume);
        await _audioPlayer.resume();

        await Future.delayed(soundDuration, () {
          _audioPlayer.stop();
        });
      } catch (e) {
        print("Error loading sound file: $e");
      }
    } else {
      print('No sound found for frequency $frequency Hz');
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  // This needs some work, to be honest I don't know how to do it properly. Right now, using exponential function I see the difference, with logarithmic it was too small..
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
