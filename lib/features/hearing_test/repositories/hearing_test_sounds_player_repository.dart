import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:hear_mate_app/features/hearing_test/utils/hearing_test_constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_ear.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/models/headphones_model.dart';
import 'package:hear_mate_app/shared/utils/logger.dart';

class HearingTestSoundsPlayerRepository {
  HeadphonesModel headphonesModel = HeadphonesModel.empty();

  HearingTestSoundsPlayerRepository() {
    initialize();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _maskingPlayer = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final Map<int, String> _soundAssetsLeft =
      {}; // Stores both left and right variants
  final Map<int, String> _noiseAssetsLeft = {};
  final Map<int, String> _soundAssetsRight =
      {}; // Stores both left and right variants
  final Map<int, String> _noiseAssetsRight = {};

  bool _playCanceled = false;
  // Duration for each tone
  final Duration _soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      _soundAssetsLeft[freq] = 'tones/tone_${freq}Hz_left.wav';
      _soundAssetsRight[freq] = 'tones/tone_${freq}Hz_right.wav';
    }

    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      _noiseAssetsLeft[freq] = 'tones/${freq}_3_left.wav';
      _noiseAssetsRight[freq] = 'tones/${freq}_3_right.wav';
    }

    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playSound({
    required int frequency,
    required double decibels,
    required HearingTestEar ear,
  }) async {
    if (!_soundAssetsLeft.containsKey(frequency) ||
        !_soundAssetsRight.containsKey(frequency)) {
      HMLogger.print('No sound found for frequency $frequency Hz');
      return;
    }
    try {
      String assetPath =
          ear == HearingTestEar.LEFT
              ? _soundAssetsLeft[frequency]!
              : _soundAssetsRight[frequency]!;

      double volume = _dBHLToVolume(decibels, frequency);

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
    required HearingTestEar ear,
  }) async {
    if (!_noiseAssetsLeft.containsKey(frequency) ||
        !_noiseAssetsRight.containsKey(frequency)) {
      HMLogger.print('No noise sound found for frequency $frequency Hz');
      return;
    }
    try {
      String assetPathMaskingSound =
          ear == HearingTestEar.LEFT
              ? _noiseAssetsLeft[frequency]!
              : _noiseAssetsRight[frequency]!;

      double volumeMaskingSound = _dBEMToVolume(decibels, frequency);

      await _maskingPlayer.setSource(AssetSource(assetPathMaskingSound));
      await _maskingPlayer.setVolume(volumeMaskingSound);

      await _maskingPlayer.resume();
    } catch (e) {
      HMLogger.print("Error loading sound file: $e");
    }
  }

  Future<void> playAmbient() async {
    try {
      String assetPath = 'tones/ambient.wav';

      await _ambientPlayer.setSource(AssetSource(assetPath));
      await _ambientPlayer.setVolume(0.00001);
      await _ambientPlayer.resume();
    } catch (e) {
      HMLogger.print("Error loading sound file: $e");
    }
  }

  Future<void> stopSound({bool stopNoise = false}) async {
    _playCanceled = true;
    await _audioPlayer.stop();
    if (stopNoise) {
      await _maskingPlayer.stop();
    }
  }

  Future<void> reset() async {
    await _audioPlayer.release();
    await _maskingPlayer.release();
    await _ambientPlayer.release();
  }

  bool isPlaying() {
    return _audioPlayer.state == PlayerState.playing;
  }

  double _dBEMToVolume(double dBEM, int frequency) {
    dBEM = dBEM.clamp(0, 120.0);

    double dBHL = _EMCorrection(dBEM, frequency);
    double dBSPL = _HLToSPL(dBHL, frequency);

    dBSPL = dBSPL.clamp(0, 115); // upper limit according to ANSI

    double soundPressure = _SPLToSoundPressure(dBSPL);
    double normalizedSoundPressure = _normalizeSoundPressure(soundPressure);

    // the volume is in linear scale from 0 to 1 therefore we use normalized sound pressure
    return normalizedSoundPressure;
  }

  double _EMCorrection(double dBEM, int frequency) {
    const Map<int, double> oneThirdOctiveCorrection = {
      125: 4,
      250: 4,
      500: 5,
      1000: 6,
      2000: 6,
      4000: 5,
      8000: 5,
    };
    return oneThirdOctiveCorrection[frequency]! + _HLToSPL(dBEM, frequency);
  }

  double _dBHLToVolume(double dBHL, int frequency) {
    dBHL = dBHL.clamp(-10.0, 120.0);

    double dBSPL = _HLToSPL(dBHL, frequency);

    double soundPressure = _SPLToSoundPressure(dBSPL);
    double normalizedSoundPressure = _normalizeSoundPressure(soundPressure);

    // the volume is in linear scale from 0 to 1 therefore we use normalized sound pressure
    return normalizedSoundPressure;
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
    double maxDeviceDBSPL = 100; // it aint perfect but there is no other way
    double normalizedSoundPressure =
        soundPressure / _SPLToSoundPressure(maxDeviceDBSPL);
    return normalizedSoundPressure;
  }

  double _HLToSPL(double dBSPL, int frequency) {
    Map<int, double> correctionReference = {
      125: headphonesModel.hz125Correction,
      250: headphonesModel.hz250Correction,
      500: headphonesModel.hz500Correction,
      1000: headphonesModel.hz1000Correction,
      2000: headphonesModel.hz2000Correction,
      4000: headphonesModel.hz4000Correction,
      8000: headphonesModel.hz8000Correction,
    };

    double correction = correctionReference[frequency]!;
    double adjusted = dBSPL + correction;
    return adjusted;
  }
}
