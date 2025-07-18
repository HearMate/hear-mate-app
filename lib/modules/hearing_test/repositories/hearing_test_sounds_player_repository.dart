import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/utils/logger.dart';

class HearingTestSoundsPlayerRepository {
  HearingTestSoundsPlayerRepository() {
    initialize();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<int, Map<String, String>> _soundAssets =
      {}; // Stores both left and right variants
  bool _playCanceled = false;

  // Duration for each tone
  final Duration soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      String basePath = 'tones/tone_${freq}Hz';
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

        double volume = _decibelsToVolume(decibels, frequency: frequency);

        await _audioPlayer.setSource(AssetSource(assetPath));
        await _audioPlayer.setVolume(volume);
        await _audioPlayer.resume();

        await Future.delayed(soundDuration, () {
          _playCanceled = true;
        });

        if (_playCanceled) {
          _audioPlayer.stop();
        }
      } catch (e) {
        HMLogger.print("Error loading sound file: $e");
      }
    } else {
      HMLogger.print('No sound found for frequency $frequency Hz');
    }
  }

  Future<void> stopSound() async {
    _playCanceled = true;
    await _audioPlayer.stop();
  }

  bool isPlaying() {
    return _audioPlayer.state == PlayerState.playing;
  }

  double _decibelsToVolume(double dBHL, {int frequency = 0}) {
    dBHL = dBHL.clamp(-10.0, 120.0);

    double dBSPL = _HLToSPL(dBHL, frequency);

    // here we should perform correction for specific headphone characteristic
    // a similar process to dB HL to dB SPL correction for each frequency

    double soundPressure = _SPLToSoundPressure(dBSPL);
    double normalizedSoundPressure = _normalizeSoundPressure(soundPressure);

    // the volume is in linear scale from 0 to 1 therefore we use normalized sound pressure
    return normalizedSoundPressure;
  }

  double _HLToSPL(double dBHL, int frequency) {
    //needs to be checked against iso 226:2003 standard / consulted with Dominika
    const Map<int, double> referenceSPL = {
      125: 45.0,
      250: 25.0,
      500: 13.5,
      1000: 7.5,
      2000: 9.0,
      4000: 12.0,
      8000: 15.5,
    };
    double reference =
        referenceSPL[frequency] ?? 7.5; // Default to 1000 Hz reference
    double dBSPL = dBHL + reference;
    return dBSPL;
  }

  double _SPLToSoundPressure(double dBSPL) {
    // Reference pressure in Pa
    const double referencePressure = 20.0e-6;
    double soundPressure =
        referencePressure *
        pow(10.0, dBSPL / 20.0).toDouble(); // Convert SPL to sound pressure
    return soundPressure;
  }

  double _normalizeSoundPressure(double soundPressure) {
    // this needs to be also limit the actual app measurement if it turns out output device does not reach 120 dB HL
    // this needs to be checked with the dummy head
    double maxDeviceOutputVolume = 60;

    double maxDBSPL = _HLToSPL(maxDeviceOutputVolume, 125);
    double normalizedSoundPressure =
        soundPressure / _SPLToSoundPressure(maxDBSPL);
    // Clamp because it seems like dB SPL can go below 0 (???)
    normalizedSoundPressure = normalizedSoundPressure.clamp(0.0, 1.0);
    return normalizedSoundPressure;
  }
}
