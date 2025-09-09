import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:hear_mate_app/features/hearing_test/utils/hearing_test_constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_ear.dart';
import 'package:hear_mate_app/features/headphones_search/models/headphones_model.dart';
import 'package:hear_mate_app/shared/utils/logger.dart';

class HearingTestSoundsPlayerRepository {
  HeadphonesModel headphonesModel = HeadphonesModel.empty();

  HearingTestSoundsPlayerRepository() {
    initialize();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _maskingPlayer = AudioPlayer();
  final Map<int, String> _soundAssets =
      {}; // Stores both left and right variants
  final Map<int, String> _noiseAssets = {};
  bool _playCanceled = false;
  // Duration for each tone
  final Duration _soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      _soundAssets[freq] = 'tones/tone_${freq}Hz.wav';
    }

    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      _noiseAssets[freq] = 'tones/${freq}_3.wav';
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
      String assetPath = _soundAssets[frequency]!;

      double volume = _dBHLToVolume(decibels, frequency);

      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.setVolume(volume);
      if (ear == HearingTestEar.RIGHT) {
        await _audioPlayer.setBalance(1.0);
      } else {
        await _audioPlayer.setBalance(-1.0);
      }
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
    if (!_noiseAssets.containsKey(frequency)) {
      HMLogger.print('No noise sound found for frequency $frequency Hz');
      return;
    }
    try {
      String assetPathMaskingSound = _noiseAssets[frequency]!;

      double volumeMaskingSound = _dBEMToVolume(decibels, frequency);

      await _maskingPlayer.setSource(AssetSource(assetPathMaskingSound));
      await _maskingPlayer.setVolume(volumeMaskingSound);

      if (ear == HearingTestEar.RIGHT) {
        await _maskingPlayer.setBalance(1.0);
      } else {
        await _maskingPlayer.setBalance(-1.0);
      }
      await _maskingPlayer.resume();
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
  }

  bool isPlaying() {
    return _audioPlayer.state == PlayerState.playing;
  }

  double _dBEMToVolume(double dBEM, int frequency) {
    dBEM = dBEM.clamp(0, 120.0);

    double dBSPL = _EMToSPL(dBEM, frequency);
    dBSPL = dBSPL.clamp(0, 115); // upper limit according to ANSI

    double soundPressure = _SPLToSoundPressure(dBSPL);
    double normalizedSoundPressure = _normalizeSoundPressure(soundPressure);

    // the volume is in linear scale from 0 to 1 therefore we use normalized sound pressure
    return normalizedSoundPressure;
  }

  double _EMToSPL(double dBEM, int frequency) {
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
    dBSPL = _headphoneCorrection(dBSPL, frequency);
    // later we might want to merge both mappings to one because the HL to SPL will change after testing

    double soundPressure = _SPLToSoundPressure(dBSPL);
    double normalizedSoundPressure = _normalizeSoundPressure(soundPressure);

    // the volume is in linear scale from 0 to 1 therefore we use normalized sound pressure
    return normalizedSoundPressure;
  }

  double _HLToSPL(double dBHL, int frequency) {
    // thresholds for Sennheiser HDA200 / RadioEar DD450 according to ANSI/ASA S3.6-2018 and ISO 289-8:2004
    const Map<int, double> retspl = {
      125: 30.5,
      250: 18.0,
      500: 11.0,
      1000: 5.5,
      2000: 4.5,
      4000: 9.5,
      8000: 17.5,
    };
    double reference = retspl[frequency]!;
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
    double maxDeviceDBSPL = 105;
    double normalizedSoundPressure =
        soundPressure / _SPLToSoundPressure(maxDeviceDBSPL);
    return normalizedSoundPressure;
  }

  double _headphoneCorrection(double dBSPL, int frequency) {
    // headphone characteristic flattening
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
