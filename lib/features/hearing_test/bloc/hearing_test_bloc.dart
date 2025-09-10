import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_loss.dart';
import 'package:hear_mate_app/features/headphones_search/models/headphones_model.dart';
import 'package:hear_mate_app/features/hearing_test/repositories/hearing_test_classification_repository.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_ear.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hear_mate_app/features/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/shared/utils/logger.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/features/hearing_test/utils/hearing_test_constants.dart'
    as HearingTestConstants;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'hearing_test_event.dart';
part 'hearing_test_state.dart';

class HearingTestBloc extends Bloc<HearingTestEvent, HearingTestState> {
  final HearingTestSoundsPlayerRepository _soundsPlayerRepository;
  final HearingTestAudiogramClassificationRepository
  _audiogramClassificationRepository;
  final AppLocalizations l10n;

  HearingTestBloc({required this.l10n})
    : _soundsPlayerRepository = HearingTestSoundsPlayerRepository(),
      _audiogramClassificationRepository =
          HearingTestAudiogramClassificationRepository(),
      super(HearingTestState()) {
    on<HearingTestInitialize>(_onInitialize);
    on<HearingTestStartTest>(_onStartTest);
    on<HearingTestButtonPressed>(_onButtonPressed);
    on<HearingTestButtonReleased>(_onButtonReleased);
    on<HearingTestPlayingSound>(_onPlayingSound);
    on<HearingTestNextFrequency>(_onNextFrequency);
    on<HearingTestChangeEar>(_onChangeEar);
    on<HearingTestCompleted>(_onTestCompleted);
    on<HearingTestStartMaskedTest>(_onStartMaskedTest);
    on<HearingTestPlayingMaskedSound>(_onPlayingMaskedSound);
    on<HearingTestNextMaskedFrequency>(_onNextMaskedFrequency);
    // DEBUG
    on<HearingTestDebugEarLeftPartial>(_onDebugEarLeftPartial);
    on<HearingTestDebugEarRightPartial>(_onDebugEarRightPartial);
    on<HearingTestDebugBothEarsFull>(_onDebugBothEarsFull);
  }

  void _onInitialize(
    HearingTestInitialize event,
    Emitter<HearingTestState> emit,
  ) async {
    await _soundsPlayerRepository.stopSound();
    emit(HearingTestState());
  }

  void _onStartTest(
    HearingTestStartTest event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(HearingTestState());

    _soundsPlayerRepository.headphonesModel = event.headphonesModel;

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
      _soundsPlayerRepository.reset();
      return;
    }

    await _soundsPlayerRepository.playSound(
      frequency:
          HearingTestConstants.TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentDBLevel,
      ear: state.currentEar,
    );

    if (state.isTestCompleted || state.isMaskingStarted) {
      _soundsPlayerRepository.reset();
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
    // Copy lists before modifying
    final updatedLeft = List<double?>.from(state.leftEarResults);
    final updatedRight = List<double?>.from(state.rightEarResults);

    if (state.currentEar == HearingTestEar.LEFT) {
      updatedLeft[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    } else {
      updatedRight[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    }

    final isLast =
        state.currentFrequencyIndex ==
        HearingTestConstants.TEST_FREQUENCIES.length - 1;

    if (isLast) {
      // If we just finished RIGHT ear, decide on masking or completion
      if (state.currentEar == HearingTestEar.RIGHT) {
        if (_getFrequenciesThatRequireMasking(state).contains(true)) {
          emit(
            state.copyWith(
              leftEarResults: updatedLeft,
              rightEarResults: updatedRight,
              isMaskingStarted: true,
            ),
          );
          return add(HearingTestStartMaskedTest());
        }
        emit(
          state.copyWith(
            leftEarResults: updatedLeft,
            rightEarResults: updatedRight,
          ),
        );
        return add(HearingTestCompleted());
      }

      // Otherwise switch to RIGHT ear
      emit(
        state.copyWith(
          leftEarResults: updatedLeft,
          rightEarResults: updatedRight,
        ),
      );
      return add(HearingTestChangeEar());
    }

    // Proceed to next frequency on the current ear
    emit(
      state.copyWith(
        leftEarResults: updatedLeft,
        rightEarResults: updatedRight,
        currentFrequencyIndex: state.currentFrequencyIndex + 1,
        currentDBLevel: state.currentDBLevel + 10,
        dbLevelToHearCountMap: {},
      ),
    );

    add(HearingTestPlayingSound());
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
        results: state.results,
      ),
    );
    add(HearingTestPlayingSound());
  }

  void _onTestCompleted(
    HearingTestCompleted event,
    Emitter<HearingTestState> emit,
  ) async {
    await _soundsPlayerRepository.stopSound(stopNoise: true);

    List<HearingLoss?> buildHearingLoss(
      List<double?> earResults,
      List<double?> earResultsMasked,
    ) {
      // Merge masked values with original results and mark if masked
      List<HearingLoss?> merged = List<HearingLoss?>.generate(
        earResults.length,
        (i) {
          final frequency = HearingTestConstants.TEST_FREQUENCIES[i];
          if (earResultsMasked[i] != null) {
            return HearingLoss(
              frequency: frequency,
              value: earResultsMasked[i]!,
              isMasked: true,
            ); // masked
          } else if (earResults[i] != null) {
            return HearingLoss(
              frequency: frequency,
              value: earResults[i]!,
              isMasked: false,
            ); // unmasked
          } else {
            return null; // missing value
          }
        },
      );

      // Define the frequency mapping order
      List<int> frequencyMapping =
          [
            7,
            6,
            5,
            (merged.length > 4 && merged[4] != null) ? 4 : 0,
            1,
            2,
            3,
          ].where((i) => i < merged.length).toList();

      // Build the hearing loss array with exactly the mapping length
      return frequencyMapping.map((i) => merged[i]).toList();
    }

    final hearingLossLeft = buildHearingLoss(
      state.leftEarResults,
      state.leftEarResultsMasked,
    );

    final hearingLossRight = buildHearingLoss(
      state.rightEarResults,
      state.rightEarResultsMasked,
    );

    final classification = await _audiogramClassificationRepository
        .getAudiogramDescription(
          l10n: l10n,
          leftEarResults: hearingLossLeft,
          rightEarResults: hearingLossRight,
        );

    final result = HearingTestResult(
      filePath: "",
      dateLabel: DateTime.now().toIso8601String(),
      hearingLossLeft: hearingLossLeft,
      hearingLossRight: hearingLossRight,
      audiogramDescription: classification,
    );

    HMLogger.print("Test completed: $result");

    emit(state.copyWith(results: result, isTestCompleted: true));
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
        state.leftEarResults[state.currentFrequencyIndex]! <
                state.rightEarResults[state.currentFrequencyIndex]!
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
      _soundsPlayerRepository.reset();
      return;
    }

    await _soundsPlayerRepository.playSound(
      frequency:
          HearingTestConstants.TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentDBLevel,
      ear: ear,
    );

    if (state.isTestCompleted) {
      _soundsPlayerRepository.reset();
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

  void _onStartMaskedTest(
    HearingTestStartMaskedTest event,
    Emitter<HearingTestState> emit,
  ) async {
    await _soundsPlayerRepository.stopSound();
    List<bool> frequenciesThatRequireMasking =
        _getFrequenciesThatRequireMasking(state);
    int maskedIndex = frequenciesThatRequireMasking.indexWhere(
      (element) => element == true,
    );
    emit(
      state.copyWith(
        frequenciesThatRequireMasking: frequenciesThatRequireMasking,
        currentFrequencyIndex: maskedIndex,
        currentMaskingDBLevel:
            min(
              state.leftEarResults[maskedIndex]!,
              state.rightEarResults[maskedIndex]!,
            ) +
            15.0,
        currentDBLevel: max(
          state.leftEarResults[maskedIndex]!,
          state.rightEarResults[maskedIndex]!,
        ),
        maskedHeardCount: 0,
        wasSoundHeard: false,
      ),
    );
    add(HearingTestPlayingMaskedSound());
  }

  void _onNextMaskedFrequency(
    HearingTestNextMaskedFrequency event,
    Emitter<HearingTestState> emit,
  ) async {
    await _soundsPlayerRepository.stopSound(stopNoise: true);

    final ear =
        state.leftEarResults[state.currentFrequencyIndex]! >
                state.rightEarResults[state.currentFrequencyIndex]!
            ? HearingTestEar.LEFT
            : HearingTestEar.RIGHT;

    // Copy masked results lists before modifying
    final updatedLeftMasked = List<double?>.from(state.leftEarResultsMasked);
    final updatedRightMasked = List<double?>.from(state.rightEarResultsMasked);

    if (ear == HearingTestEar.LEFT) {
      updatedLeftMasked[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    } else {
      updatedRightMasked[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    }

    if (state.frequenciesThatRequireMasking == null) {
      debugPrint("frequenciesThatRequireMasking was null during masking test");
      return;
    }

    // Copy masking flags before modifying
    final updatedMaskFlags = List<bool>.from(
      state.frequenciesThatRequireMasking!,
    );

    updatedMaskFlags[state.currentFrequencyIndex] = false;

    // handle double 1k record
    if (state.currentFrequencyIndex == 0 && updatedMaskFlags.length > 4) {
      updatedMaskFlags[4] = false;
    }

    if (!updatedMaskFlags.contains(true)) {
      emit(
        state.copyWith(
          leftEarResultsMasked: updatedLeftMasked,
          rightEarResultsMasked: updatedRightMasked,
          frequenciesThatRequireMasking: updatedMaskFlags,
          isTestCompleted: true,
        ),
      );
      return add(HearingTestCompleted());
    }

    final maskedIndex = updatedMaskFlags.indexWhere(
      (element) => element == true,
    );

    emit(
      state.copyWith(
        leftEarResultsMasked: updatedLeftMasked,
        rightEarResultsMasked: updatedRightMasked,
        frequenciesThatRequireMasking: updatedMaskFlags,
        currentFrequencyIndex: maskedIndex,
        currentMaskingDBLevel:
            min(
              state.leftEarResults[maskedIndex]!,
              state.rightEarResults[maskedIndex]!,
            ) +
            15.0,
        currentDBLevel: max(
          state.leftEarResults[maskedIndex]!,
          state.rightEarResults[maskedIndex]!,
        ),
        maskedHeardCount: 0,
      ),
    );

    add(HearingTestPlayingMaskedSound());
  }

  // DEBUG: partial left ear
  void _onDebugEarLeftPartial(
    HearingTestDebugEarLeftPartial event,
    Emitter<HearingTestState> emit,
  ) async {
    if (!kDebugMode) return;

    await _soundsPlayerRepository.stopSound(stopNoise: true);

    // Set left ear results; only first 3 frequencies have values
    final leftResults = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );
    for (int i = 0; i < 3; i++) {
      leftResults[i] = 30.0 + i * 5;
    }

    // Masked left results empty
    final leftResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    // Right ear remains empty
    final rightResults = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );
    final rightResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    emit(
      state.copyWith(
        leftEarResults: leftResults,
        leftEarResultsMasked: leftResultsMasked,
        rightEarResults: rightResults,
        rightEarResultsMasked: rightResultsMasked,
      ),
    );

    add(HearingTestCompleted());
  }

  // DEBUG: partial right ear
  void _onDebugEarRightPartial(
    HearingTestDebugEarRightPartial event,
    Emitter<HearingTestState> emit,
  ) async {
    if (!kDebugMode) return;

    await _soundsPlayerRepository.stopSound(stopNoise: true);

    // Left ear full values
    final leftResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => 30.0 + i * 5,
    );
    final leftResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    // Right ear: only first 3 frequencies
    final rightResults = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );
    for (int i = 0; i < 3; i++) {
      rightResults[i] = 45.0 + i * 5;
    }
    final rightResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    emit(
      state.copyWith(
        leftEarResults: leftResults,
        leftEarResultsMasked: leftResultsMasked,
        rightEarResults: rightResults,
        rightEarResultsMasked: rightResultsMasked,
      ),
    );

    add(HearingTestCompleted());
  }

  // DEBUG: full both ears
  void _onDebugBothEarsFull(
    HearingTestDebugBothEarsFull event,
    Emitter<HearingTestState> emit,
  ) async {
    if (!kDebugMode) return;

    await _soundsPlayerRepository.stopSound(stopNoise: true);

    // Left ear full values
    final leftResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => i * 5.0,
    );
    final leftResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    // Right ear full values
    final rightResults = List<double?>.generate(
      HearingTestConstants.TEST_FREQUENCIES.length,
      (i) => 75.0 - i * 5,
    );
    final rightResultsMasked = List<double?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    );

    emit(
      state.copyWith(
        leftEarResults: leftResults,
        leftEarResultsMasked: leftResultsMasked,
        rightEarResults: rightResults,
        rightEarResultsMasked: rightResultsMasked,
        //isMaskingStarted: true,
      ),
    );

    add(HearingTestCompleted());
    //return add(HearingTestStartMaskedTest());
  }

  List<bool> _getFrequenciesThatRequireMasking(HearingTestState state) {
    final frequencies = HearingTestConstants.TEST_FREQUENCIES;
    final thresholds = HearingTestConstants.MASKING_THRESHOLDS;

    List<bool> result = List<bool>.generate(frequencies.length, (i) {
      final left =
          (i < state.leftEarResults.length) ? state.leftEarResults[i] : null;
      final right =
          (i < state.rightEarResults.length) ? state.rightEarResults[i] : null;

      if (left != null && right != null) {
        return (left - right).abs() >= thresholds[i];
      }
      return false;
    });

    if (result.length > 4) {
      result[0] = result[4];
    }
    if (result.length > 3) {
      result[3] = false;
    }

    return result;
  }
}
