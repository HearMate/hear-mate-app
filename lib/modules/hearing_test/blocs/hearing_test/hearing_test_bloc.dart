import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_ear.dart';
import 'package:meta/meta.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_result.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;

part 'hearing_test_event.dart';
part 'hearing_test_state.dart';

class HearingTestBloc extends Bloc<HearingTestEvent, HearingTestState> {
  final HearingTestSoundsPlayerRepository _soundsPlayerRepository;

  HearingTestBloc({
    required HearingTestSoundsPlayerRepository
    hearingTestSoundsPlayerRepository,
  }) : _soundsPlayerRepository = hearingTestSoundsPlayerRepository,
       super(HearingTestState()) {
    on<HearingTestStartTest>(_onStartTest);
    on<HearingTestButtonPressed>(_onButtonPressed);
    on<HearingTestButtonReleased>(_onButtonReleased);
    on<HearingTestPlayingSound>(_onPlayingSound);
    on<HearingTestNextFrequency>(_onNextFrequency);
    on<HearingTestEndTestEarly>(_onEndTestEarly);
    on<HearingTestChangeEar>(_onChangeEar);
    on<HearingTestCompleted>(_onCompleted);
    on<HearingTestSaveResult>(_saveTestResult);
    on<HearingTestStartMaskedTest>(_onStartMaskedTest);
    on<HearingTestPlayingMaskedSound>(_onPlayingMaskedSound);
    on<HearingTestNextMaskedFrequency>(_onNextMaskedFrequency);
    // DEBUG
    on<HearingTestDebugEarLeftPartial>(_onDebugEarLeftPartial);
    on<HearingTestDebugEarRightPartial>(_onDebugEarRightPartial);
    on<HearingTestDebugBothEarsFull>(_onDebugBothEarsFull);
  }

  void _onStartTest(
    HearingTestStartTest event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(
      state.copyWith(
        currentEar: state.currentEar,
        isTestCompleted: false,
        isMaskingStarted: false,
        isButtonPressed: false,
        wasSoundHeard: false,
        currentFrequencyIndex: 0,
        currentDBLevel: 20,
        dbLevelToHearCountMap: const {},
        resultSaved: false,
        results: HearingTestResult(
          filePath: "",
          dateLabel: "",
          leftEarResults: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          rightEarResults: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          leftEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          rightEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
        ),
        frequenciesThatRequireMasking: null,
      ),
    );

    add(HearingTestPlayingSound());
  }

  void _onButtonPressed(
    HearingTestButtonPressed event,
    Emitter<HearingTestState> emit,
  ) async {
    if (_soundsPlayerRepository.isPlaying()) {
      _soundsPlayerRepository.stopSound();
      emit(state.copyWith(isButtonPressed: true, wasSoundHeard: true));
      return;
    } else {
      emit(state.copyWith(isButtonPressed: true));
      return;
    }
  }

  void _onButtonReleased(
    HearingTestButtonReleased event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(state.copyWith(isButtonPressed: false));
  }

  void _onPlayingSound(
    HearingTestPlayingSound event,
    Emitter<HearingTestState> emit,
  ) async {
    if (state.isTestCompleted || state.isMaskingStarted) {
      return;
    }

    if (state.currentDBLevel < HearingTestConstants.MIN_DB_LEVEL) {
      return add(HearingTestNextFrequency());
    }

    final random = Random();
    final int delayMs = 500 + random.nextInt(1501); // 500ms to 2000ms
    await Future.delayed(Duration(milliseconds: delayMs));

    if (state.isTestCompleted || state.isMaskingStarted) {
      return;
    }

    await _soundsPlayerRepository.playSound(
      frequency:
          HearingTestConstants.TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentDBLevel,
      ear: state.currentEar,
    );

    if (state.isTestCompleted || state.isMaskingStarted) {
      return;
    }

    if (state.wasSoundHeard) {
      emit(
        state.copyWith(
          currentDBLevel: state.currentDBLevel - 5,
          wasSoundHeard: false,
        ),
      );
      return add(HearingTestPlayingSound());
    }

    // if user didn't hear the sound 2 times, switch frequencies
    if (state.dbLevelToHearCountMap[state.currentDBLevel] == 0) {
      emit(state.copyWith(currentDBLevel: state.currentDBLevel + 5));
      return add(HearingTestNextFrequency());
    }

    // else give him one more chance to hear the sound
    emit(
      state.copyWith(
        currentDBLevel: state.currentDBLevel + 5,
        dbLevelToHearCountMap: Map.from(state.dbLevelToHearCountMap)..update(
          state.currentDBLevel,
          (value) => value - 1,
          ifAbsent: () => 0,
        ),
      ),
    );

    add(HearingTestPlayingSound());
  }

  void _onNextFrequency(
    HearingTestNextFrequency event,
    Emitter<HearingTestState> emit,
  ) async {
    if (state.currentEar == HearingTestEar.LEFT) {
      state.results.leftEarResults[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    } else {
      state.results.rightEarResults[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    }

    if (state.currentFrequencyIndex ==
        HearingTestConstants.TEST_FREQUENCIES.length - 1) {
      // check if we have already covered two ears
      if (state.currentEar == HearingTestEar.RIGHT) {
        if (state.results.getFrequenciesThatRequireMasking().contains(true)) {
          emit(state.copyWith(isMaskingStarted: true));
          return add(HearingTestStartMaskedTest());
        }
        return add(HearingTestCompleted());
      }
      return add(HearingTestChangeEar());
    }

    emit(
      state.copyWith(
        results: state.results,
        currentFrequencyIndex: state.currentFrequencyIndex + 1,
        currentDBLevel: state.currentDBLevel + 10,
        dbLevelToHearCountMap: {},
      ),
    );

    add(HearingTestPlayingSound());
  }

  // It could be probably merged with onCompleted. Right now, we will leave it, because it may be useful in the future.
  void _onEndTestEarly(
    HearingTestEndTestEarly event,
    Emitter<HearingTestState> emit,
  ) {
    _soundsPlayerRepository.stopSound(stopNoise: true);
    emit(state.copyWith(isTestCompleted: true));
    HMLogger.print("${state.results}");
  }

  void _onChangeEar(
    HearingTestChangeEar event,
    Emitter<HearingTestState> emit,
  ) {
    emit(
      state.copyWith(
        currentEar: HearingTestEar.RIGHT,
        isButtonPressed: false,
        wasSoundHeard: false,
        currentFrequencyIndex: 0,
        currentDBLevel: 20,
        dbLevelToHearCountMap: const {},
        resultSaved: false,
        results: state.results,
      ),
    );
    add(HearingTestPlayingSound());
  }

  void _onCompleted(
    HearingTestCompleted event,
    Emitter<HearingTestState> emit,
  ) {
    HMLogger.print("${state.results}");
    emit(state.copyWith(isTestCompleted: true));
  }

  Future<void> _saveTestResult(
    HearingTestSaveResult event,
    Emitter<HearingTestState> emit,
  ) async {
    final data = jsonEncode(state.results.toJson());
    final timestamp = DateTime.now()
        .toIso8601String()
        .split('T')
        .join('_')
        .split('.')
        .first
        .replaceAll(':', '-');
    final defaultFileName = 'test_result_$timestamp.json';

    try {
      final baseDir = await getApplicationSupportDirectory();
      final echoParseDir = Directory('${baseDir.path}/HearingTest');
      if (!await echoParseDir.exists()) {
        await echoParseDir.create(recursive: true);
      }
      final internalPath = '${echoParseDir.path}/$defaultFileName';
      final internalFile = File(internalPath);
      await internalFile.writeAsString(data);
      emit(state.copyWith(resultSaved: true));
    } catch (e) {
      debugPrint("Error saving CSV file: $e");
    }
  }

  void _onPlayingMaskedSound(
    HearingTestPlayingMaskedSound event,
    Emitter<HearingTestState> emit,
  ) async {
    if (state.isTestCompleted) {
      return;
    }

    if (state.currentDBLevel < HearingTestConstants.MIN_DB_LEVEL) {
      return add(HearingTestNextMaskedFrequency());
    }

    final ear =
        state.results.leftEarResults[state.currentFrequencyIndex]! <
                state.results.rightEarResults[state.currentFrequencyIndex]!
            ? HearingTestEar.RIGHT
            : HearingTestEar.LEFT;

    final oppositeEar =
        ear == HearingTestEar.LEFT ? HearingTestEar.RIGHT : HearingTestEar.LEFT;

    await _soundsPlayerRepository.playMaskedSound(
      frequency:
          HearingTestConstants.TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentMaskingDBLevel,
      ear: oppositeEar,
    );

    final random = Random();
    final int delayMs = 500 + random.nextInt(1501); // 500ms to 2000ms
    await Future.delayed(Duration(milliseconds: delayMs));

    if (state.isTestCompleted) {
      return;
    }

    await _soundsPlayerRepository.playSound(
      frequency:
          HearingTestConstants.TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentDBLevel,
      ear: ear,
    );

    if (state.isTestCompleted) {
      return;
    }

    if (state.wasSoundHeard) {
      if (state.maskedHeardCount! >= 2) {
        return add(HearingTestNextMaskedFrequency());
      }

      emit(
        state.copyWith(
          currentMaskingDBLevel: state.currentMaskingDBLevel + 5,
          wasSoundHeard: false,
          maskedHeardCount: state.maskedHeardCount! + 1,
        ),
      );
      return add(HearingTestPlayingMaskedSound());
    }

    emit(
      state.copyWith(
        currentDBLevel: state.currentDBLevel + 5,
        maskedHeardCount: 0,
      ),
    );

    add(HearingTestPlayingMaskedSound());
  }

  void _onNextMaskedFrequency(
    HearingTestNextMaskedFrequency event,
    Emitter<HearingTestState> emit,
  ) async {
    _soundsPlayerRepository.stopSound(stopNoise: true);
    final ear =
        state.results.leftEarResults[state.currentFrequencyIndex]! >
                state.results.rightEarResults[state.currentFrequencyIndex]!
            ? HearingTestEar.LEFT
            : HearingTestEar.RIGHT;

    if (ear == HearingTestEar.LEFT) {
      state.results.leftEarResultsMasked[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    } else {
      state.results.rightEarResultsMasked[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    }

    if (state.frequenciesThatRequireMasking == null) {
      debugPrint("frequenciesThatRequireMasking was null during masking test");
      return;
    }
    state.frequenciesThatRequireMasking![state.currentFrequencyIndex] = false;
    // handle double 1k record
    if (state.currentFrequencyIndex == 0) {
      state.frequenciesThatRequireMasking![4] = false;
    }

    if (state.frequenciesThatRequireMasking!.contains(true) == false) {
      emit(state.copyWith(isTestCompleted: true));
      return add(HearingTestCompleted());
    }

    int maskedIndex = state.frequenciesThatRequireMasking!.indexWhere(
      (element) => element == true,
    );

    emit(
      state.copyWith(
        currentFrequencyIndex: maskedIndex,
        currentMaskingDBLevel:
            min(
              state.results.leftEarResults[maskedIndex]!,
              state.results.rightEarResults[maskedIndex]!,
            ) +
            15.0,
        currentDBLevel: max(
          state.results.leftEarResults[maskedIndex]!,
          state.results.rightEarResults[maskedIndex]!,
        ),
        maskedHeardCount: 0,
      ),
    );

    add(HearingTestPlayingMaskedSound());
  }

  void _onStartMaskedTest(
    HearingTestStartMaskedTest event,
    Emitter<HearingTestState> emit,
  ) async {
    await _soundsPlayerRepository.stopSound();
    List<bool> frequenciesThatRequireMasking =
        state.results.getFrequenciesThatRequireMasking();
    int maskedIndex = frequenciesThatRequireMasking.indexWhere(
      (element) => element == true,
    );
    emit(
      state.copyWith(
        frequenciesThatRequireMasking: frequenciesThatRequireMasking,
        currentFrequencyIndex: maskedIndex,
        currentMaskingDBLevel:
            min(
              state.results.leftEarResults[maskedIndex]!,
              state.results.rightEarResults[maskedIndex]!,
            ) +
            15.0,
        currentDBLevel: max(
          state.results.leftEarResults[maskedIndex]!,
          state.results.rightEarResults[maskedIndex]!,
        ),
        maskedHeardCount: 0,
        wasSoundHeard: false,
      ),
    );
    add(HearingTestPlayingMaskedSound());
  }

  // DEBUG

  void _onDebugEarLeftPartial(
    HearingTestDebugEarLeftPartial event,
    Emitter<HearingTestState> emit,
  ) {
    if (!kDebugMode) {
      return;
    }

    final leftEarResults = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );
    leftEarResults[0] = 30.0;
    leftEarResults[1] = 35.0;
    leftEarResults[2] = 40.0;

    emit(
      state.copyWith(
        results: HearingTestResult(
          filePath: "",
          dateLabel: "DEBUG_LEFT_PARTIAL",
          leftEarResults: leftEarResults,
          rightEarResults: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          leftEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          rightEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
        ),
        isTestCompleted: true,
      ),
    );
  }

  void _onDebugEarRightPartial(
    HearingTestDebugEarRightPartial event,
    Emitter<HearingTestState> emit,
  ) {
    if (!kDebugMode) {
      return;
    }

    final leftEarResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (index) => 30.0 + index * 5,
    );

    final rightEarResults = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    rightEarResults[0] = 45.0;
    rightEarResults[1] = 50.0;
    rightEarResults[2] = 55.0;

    emit(
      state.copyWith(
        results: HearingTestResult(
          filePath: "",
          dateLabel: "DEBUG_RIGHT_PARTIAL",
          leftEarResults: leftEarResults,
          rightEarResults: rightEarResults,
          leftEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
          rightEarResultsMasked: List<double?>.filled(
            HearingTestConstants.TEST_FREQUENCIES.length,
            null,
          ),
        ),
        isTestCompleted: true,
      ),
    );
  }

  void _onDebugBothEarsFull(
    HearingTestDebugBothEarsFull event,
    Emitter<HearingTestState> emit,
  ) {
    if (!kDebugMode) {
      return;
    }

    final leftEarResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => 0.0 + i * 5, // 30, 32, 34, ...
    );

    final rightEarResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => 75.0 - i * 5, // 35, 38, 41, ...
    );

    var leftEarMasked = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => null,
    );

    var rightEarMasked = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => null, //(rightEarResults[i] ?? 0) + 20,
    );

    //rightEarMasked[5] = null;
    //rightEarMasked[3] = null;

    emit(
      state.copyWith(
        results: HearingTestResult(
          filePath: "",
          dateLabel: "DEBUG_FULL",
          leftEarResults: leftEarResults,
          rightEarResults: rightEarResults,
          leftEarResultsMasked: leftEarMasked,
          rightEarResultsMasked: rightEarMasked,
        ),
        isMaskingStarted: true,
        wasSoundHeard: false,
        //isTestCompleted: true,
      ),
    );
    return add(HearingTestStartMaskedTest());
  }
}
