import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/featuers/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_classification_repository.dart';
import 'package:hear_mate_app/repositories/database_repository.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:hear_mate_app/featuers/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_test_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

part 'hearing_test_module_event.dart';
part 'hearing_test_module_state.dart';

class HearingTestModuleBloc
    extends Bloc<HearingTestModuleBlocEvent, HearingTestModuleState> {
  final HearingTestBloc hearingTestBloc;
  final AppLocalizations l10n;
  final DatabaseRepository databaseRepository;

  HearingTestModuleBloc({required this.l10n, required this.databaseRepository})
    : hearingTestBloc = HearingTestBloc(l10n: l10n),
      super(HearingTestModuleState()) {
    on<HearingTestModuleNavigateToWelcome>(_onNavigateToWelcome);
    on<HearingTestModuleNavigateToHistory>(_onNavigateToHistory);
    on<HearingTestModuleNavigateToTest>(_onNavigateToTest);
    on<HearingTestModuleTestCompleted>(_onTestCompleted);
    on<HearingTestModuleSaveTestResults>(_onSaveTestResult);
    on<HearingTestModuleSelectHeadphoneFromSearch>(_onSelectHeadphones);

    hearingTestBloc.stream.listen((hearingTestState) {
      if (hearingTestState.isTestCompleted) {
        add(HearingTestModuleTestCompleted(results: hearingTestState.results));
      }
    });
  }

  void _onNavigateToWelcome(
    HearingTestModuleNavigateToWelcome event,
    Emitter<HearingTestModuleState> emit,
  ) {
    hearingTestBloc.add(HearingTestInitialize());
    emit(HearingTestModuleState());
    emit(state.copyWith(currentStep: HearingTestPageStep.welcome));
  }

  void _onNavigateToHistory(
    HearingTestModuleNavigateToHistory event,
    Emitter<HearingTestModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HearingTestPageStep.history));
  }

  void _onNavigateToTest(
    HearingTestModuleNavigateToTest event,
    Emitter<HearingTestModuleState> emit,
  ) {
    hearingTestBloc.add(
      HearingTestStartTest(
        headphonesModel: state.headphonesModel ?? HeadphonesModel.empty(),
      ),
    );
    emit(state.copyWith(currentStep: HearingTestPageStep.test));
  }

  Future<void> _onTestCompleted(
    HearingTestModuleTestCompleted event,
    Emitter<HearingTestModuleState> emit,
  ) async {
    emit(
      state.copyWith(
        results: event.results,
        currentStep: HearingTestPageStep.result,
      ),
    );
  }

  Future<void> _onSaveTestResult(
    HearingTestModuleSaveTestResults event,
    Emitter<HearingTestModuleState> emit,
  ) async {
    final data = jsonEncode(state.results?.toJson());
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

      emit(state.copyWith(resultsSaved: true));
    } catch (e) {
      debugPrint("Error saving CSV file: $e");
    }
  }

  void _onSelectHeadphones(
    HearingTestModuleSelectHeadphoneFromSearch event,
    Emitter<HearingTestModuleState> emit,
  ) async {
    final headphonesModel =
        await databaseRepository.searchHeadphone(name: event.headphone.name) ??
        HeadphonesModel.empty(name: event.headphone.name);

    emit(state.copyWith(headphonesModel: headphonesModel));
  }
}
