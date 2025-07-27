import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_ear.dart';
import 'package:hear_mate_app/utils/logger.dart';

class HearingTestSoundsPlayerRepository {
  HearingTestSoundsPlayerRepository() {
    initialize();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _leftPlayer = AudioPlayer();
  final AudioPlayer _rightPlayer = AudioPlayer();
  final Map<int, Map<String, String>> _soundAssets =
      {}; // Stores both left and right variants
  bool _playCanceled = false;
  final String _pinkNoiseAssetPath = 'tones/pink_noise_stereo.wav';
  // Duration for each tone
  final Duration _soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      String basePath = 'tones/tone_${freq}Hz';
      String leftPath = '${basePath}_left.wav';
      String rightPath = '${basePath}_right.wav';

      _soundAssets[freq] = {'left': leftPath, 'right': rightPath};
    }

    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playSound({
    required int frequency,
    required double decibels,
    required HearingTestEar ear,
  }) async {
    if (!_soundAssets.containsKey(frequency)) {
      HMLogger.print('No sound found for frequency $frequency Hz');
      return;
    }
    try {
      String assetPath =
          ear == HearingTestEar.LEFT
              ? _soundAssets[frequency]!['left']!
              : _soundAssets[frequency]!['right']!;

      double volume = _decibelsToVolume(decibels, frequency: frequency);

      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.setVolume(volume);
      await _audioPlayer.resume();

      await Future.delayed(_soundDuration, () {
        _playCanceled = true;
      });

      if (_playCanceled) {
        _audioPlayer.stop();
      }
    } catch (e) {
      HMLogger.print("Error loading sound file: $e");
    }
  }

  Future<void> playMaskedSound({
    required int frequency,
    required double decibels,
    required double maskedDecibels,
    required HearingTestEar ear,
  }) async {
    if (!_soundAssets.containsKey(frequency)) {
      HMLogger.print('No sound found for frequency $frequency Hz');
      return;
    }
    try {
      String? assetPathL;
      String? assetPathR;

      double? volumeL;
      double? volumeR;

      if (ear == HearingTestEar.RIGHT) {
        assetPathR = _soundAssets[frequency]!['right']!;
        assetPathL = _pinkNoiseAssetPath;

        volumeR = _decibelsToVolume(decibels, frequency: frequency);
        volumeL = _decibelsToVolume(maskedDecibels, frequency: frequency);
      } else {
        assetPathR = _pinkNoiseAssetPath;
        assetPathL = _soundAssets[frequency]!['left']!;

        volumeR = _decibelsToVolume(maskedDecibels, frequency: frequency);
        volumeL = _decibelsToVolume(decibels, frequency: frequency);
      }

      await _leftPlayer.setSource(AssetSource(assetPathL));
      await _leftPlayer.setBalance(-1.0);
      await _leftPlayer.setVolume(volumeL);
      await _leftPlayer.resume();

      await _rightPlayer.setSource(AssetSource(assetPathR));
      await _rightPlayer.setBalance(1.0);
      await _rightPlayer.setVolume(volumeR);
      await _rightPlayer.resume();

      await Future.delayed(_soundDuration, () {
        _playCanceled = true;
      });

      if (_playCanceled) {
        _audioPlayer.stop();
      }
    } catch (e) {
      HMLogger.print("Error loading sound file: $e");
    }
  }

  Future<void> stopSound() async {
    _playCanceled = true;
    await _audioPlayer.stop();
    await _leftPlayer.stop();
    await _rightPlayer.stop();
  }

  bool isPlaying() {
    return (_audioPlayer.state == PlayerState.playing ||
        _leftPlayer.state == PlayerState.playing ||
        _rightPlayer.state == PlayerState.playing);
  }

  double _decibelsToVolume(
    double dBHL, {
    int frequency = 0,
    bool equalize = true,
  }) {
    dBHL = dBHL.clamp(-10.0, 120.0);
    double dBSPL = dBHL;

    if (equalize) {
      double dBSPL = _HLToSPL(dBHL, frequency);
      dBSPL = _headphoneCorrection(dBSPL, frequency);
    }

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

  double _headphoneCorrection(double dBSPL, int frequency) {
    const Map<int, double> correctionReference = {
      125: -10.0,
      250: -8.0,
      500: -6.5,
      1000: -7.5,
      2000: -7.5,
      4000: -10.0,
      8000: -4.5,
    };
    double correction =
        correctionReference[frequency] ?? 7.5; // Default to 1000 Hz reference
    double adjusted = dBSPL + correction;
    return adjusted;
  }
}
