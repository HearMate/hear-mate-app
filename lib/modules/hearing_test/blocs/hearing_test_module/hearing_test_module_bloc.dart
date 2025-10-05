import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/features/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/models/headphones_model.dart';
import 'package:hear_mate_app/shared/repositories/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'hearing_test_module_event.dart';
part 'hearing_test_module_state.dart';

class HearingTestModuleBloc
    extends Bloc<HearingTestModuleBlocEvent, HearingTestModuleState> {
  final HearingTestBloc hearingTestBloc;
  final AppLocalizations l10n;
  final DatabaseRepository databaseRepository;
  final localStorageReferenceHeadphones = "available_reference_headphones";

  HearingTestModuleBloc({required this.l10n, required this.databaseRepository})
    : hearingTestBloc = HearingTestBloc(l10n: l10n),
      super(HearingTestModuleState()) {
    on<HearingTestModuleNavigateToWelcome>(_onNavigateToWelcome);
    on<HearingTestModuleNavigateToHistory>(_onNavigateToHistory);
    on<HearingTestModuleNavigateToTest>(_onNavigateToTest);
    on<HearingTestModuleTestCompleted>(_onTestCompleted);
    on<HearingTestModuleSaveTestResults>(_onSaveTestResult);
    on<HearingTestModuleSelectHeadphoneFromSearch>(_onSelectHeadphones);
    on<HearingTestModuleRemoveSelectedHeadphone>(_onRemoveSelectedHeadphone);

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
        step: 5.0,
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
    HeadphonesModel? headphones = await databaseRepository.searchHeadphone(
      name: event.headphone.name,
    );

    HeadphonesModel selectedHeadphone;

    if (headphones == null) {
      selectedHeadphone = event.headphone.copyWith(isCalibrated: false);
    } else {
      selectedHeadphone = headphones.copyWith(isCalibrated: true);
    }

    emit(state.copyWith(selectedHeadphone: selectedHeadphone));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(localStorageReferenceHeadphones, selectedHeadphone.name);
  }

  void _onRemoveSelectedHeadphone(
    HearingTestModuleRemoveSelectedHeadphone event,
    Emitter<HearingTestModuleState> emit,
  ) async {
    emit(state.copyWith(clearSelectedHeadphone: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(localStorageReferenceHeadphones);
  }
}
