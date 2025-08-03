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
  final AudioPlayer _maskingPlayer = AudioPlayer();
  final Map<int, Map<String, String>> _soundAssets =
      {}; // Stores both left and right variants
  final Map<int, String> _noiseAssets = {};
  bool _playCanceled = false;
  // Duration for each tone
  final Duration _soundDuration = Duration(seconds: 2);

  Future<void> initialize() async {
    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      String basePath = 'tones/tone_${freq}Hz';
      String leftPath = '${basePath}_left.wav';
      String rightPath = '${basePath}_right.wav';

      _soundAssets[freq] = {'left': leftPath, 'right': rightPath};
    }

    for (int freq in HearingTestConstants.TEST_FREQUENCIES) {
      String path = 'tones/${freq}_3.wav';
      _noiseAssets[freq] = path;
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

      double volume = _dBHLToVolume(decibels, frequency);

      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.setVolume(volume);
      await _delay();
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
    if (!_soundAssets.containsKey(frequency) ||
        !_noiseAssets.containsKey(frequency)) {
      HMLogger.print('No sound found for frequency $frequency Hz');
      return;
    }
    try {
      String assetPathMaskingSound = _noiseAssets[frequency]!;
      String assetPathMainSound =
          ear == HearingTestEar.LEFT
              ? _soundAssets[frequency]!['left']!
              : _soundAssets[frequency]!['right']!;

      double volumeMaskingSound = _dBEMToVolume(maskedDecibels, frequency);
      double volumeMainSound = _dBHLToVolume(decibels, frequency);

      await _maskingPlayer.setSource(AssetSource(assetPathMaskingSound));
      await _maskingPlayer.setVolume(volumeMaskingSound);
      await _audioPlayer.setSource(AssetSource(assetPathMainSound));
      await _audioPlayer.setVolume(volumeMainSound);

      if (ear == HearingTestEar.RIGHT) {
        await _audioPlayer.setBalance(1.0);
        await _maskingPlayer.setBalance(-1.0);
      } else {
        await _audioPlayer.setBalance(-1.0);
        await _maskingPlayer.setBalance(1.0);
      }
      await _maskingPlayer.resume();
      await _delay();
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

  Future<void> _delay() async {
    final random = Random();
    final int delayMs = 500 + random.nextInt(1501); // 500ms to 2000ms
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  Future<void> stopSound({bool stopNoise = false}) async {
    _playCanceled = true;
    await _audioPlayer.stop();
    if (stopNoise) {
      await _maskingPlayer.stop();
    }
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
    const Map<int, double> correctionReference = {
      125: -10.0,
      250: -8.0,
      500: -6.5,
      1000: -7.5,
      2000: -7.5,
      4000: -10.0,
      8000: -4.5,
    };
    double correction = correctionReference[frequency]!;
    double adjusted = dBSPL + correction;
    return adjusted;
  }
}
