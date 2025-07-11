import 'package:bloc/bloc.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:hear_mate_app/modules/constants.dart';
import 'package:hear_mate_app/modules/hearing_test/modules/hearing_test_result.dart';

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
  }

  void _onStartTest(
    HearingTestStartTest event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(
      state.copyWith(
        isTestCanceled: false,
        isButtonPressed: false,
        wasSoundHeard: false,
        currentFrequencyIndex: 0,
        currentDBLevel: 20,
        dbLevelToHearCountMap: const {},
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
    if (state.isTestCanceled) {
      return;
    }

    if (state.currentDBLevel < MIN_DB_LEVEL) {
      return add(HearingTestNextFrequency());
    }

    final random = Random();
    final int delayMs = 500 + random.nextInt(1501); // 500ms to 2000ms
    await Future.delayed(Duration(milliseconds: delayMs));

    await _soundsPlayerRepository.playSound(
      TEST_FREQUENCIES[state.currentFrequencyIndex],
      decibels: state.currentDBLevel,
      leftEarOnly: state.currentEar,
    );

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
    if (state.currentFrequencyIndex == TEST_FREQUENCIES.length - 1) {
      // check if we have already covered two ears
      if (state.currentEar) {
        return add(HearingTestCompleted());
      }
      return add(HearingTestChangeEar());
    }

    if (!state.currentEar) {
      state.results.leftEarResults[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
    } else {
      state.results.rightEarResults[state.currentFrequencyIndex] =
          state.currentDBLevel.toDouble();
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

  void _onEndTestEarly(
    HearingTestEndTestEarly event,
    Emitter<HearingTestState> emit,
  ) {
    _soundsPlayerRepository.stopSound();
    emit(state.copyWith(isTestCanceled: true));
    HMLogger.print("${state.results}");
  }

  void _onChangeEar(
    HearingTestChangeEar event,
    Emitter<HearingTestState> emit,
  ) {
    emit(
      state.copyWith(
        currentEar: true,
        isButtonPressed: false,
        wasSoundHeard: false,
        currentFrequencyIndex: 0,
        currentDBLevel: 20,
        dbLevelToHearCountMap: const {},
      ),
    );
    add(HearingTestStartTest());
  }

  void _onCompleted(
    HearingTestCompleted event,
    Emitter<HearingTestState> emit,
  ) {
    HMLogger.print("${state.results}");
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
    final defaultFileName = 'audiogram_result_$timestamp.csv';

    try {
      final baseDir = await getApplicationSupportDirectory();
      final echoParseDir = Directory('${baseDir.path}/HearingTest');
      if (!await echoParseDir.exists()) {
        await echoParseDir.create(recursive: true);
      }
      final internalPath = '${echoParseDir.path}/$defaultFileName';
      final internalFile = File(internalPath);
      await internalFile.writeAsString(data);
    } catch (e) {
      debugPrint("Error saving CSV file: $e");
    }
  }
}
