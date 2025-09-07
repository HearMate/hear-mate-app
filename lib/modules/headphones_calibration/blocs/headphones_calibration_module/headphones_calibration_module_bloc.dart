import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/featuers/hearing_test/utils/hearing_test_utils.dart'
    as HearingTestUtils;
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_search_result.dart';
import 'package:hear_mate_app/modules/headphones_calibration/repositories/headphones_searcher_repository.dart';
import 'package:hear_mate_app/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'headphones_calibration_module_event.dart';
part 'headphones_calibration_module_state.dart';

class HeadphonesCalibrationModuleBloc
    extends
        Bloc<
          HeadphonesCalibrationModuleEvent,
          HeadphonesCalibrationModuleState
        > {
  final DatabaseRepository databaseRepository;
  final HeadphonesSearcherRepository headphonesSearcherRepository;
  final AppLocalizations l10n;
  final HearingTestBloc hearingTestBloc;

  Timer? _searchDebounceTimer;
  static const Duration _searchDebounceDelay = Duration(milliseconds: 500);

  final HEADPHONES_GRADE_THRESHOLD = 3;
  final LOCAL_STORAGE_REFERENCE_HEADPHONES = "available_reference_headphones";
  final LOCAL_STORAGE_TARGET_HEADPHONES = "available_target_headphones";

  HeadphonesCalibrationModuleBloc({
    required this.l10n,
    required this.databaseRepository,
  }) : hearingTestBloc = HearingTestBloc(l10n: l10n),
       headphonesSearcherRepository = HeadphonesSearcherRepository(),
       super(HeadphonesCalibrationModuleState()) {
    on<HeadphonesCalibrationModuleStart>(_onStart);
    on<HeadphonesCalibrationModuleNavigateToWelcome>(_onNavigateToWelcome);
    on<HeadphonesCalibrationModuleNavigateToFirstTest>(_onNavigateToFirstTest);
    on<HeadphonesCalibrationModuleNavigateToInformationBetweenTests>(
      _onNavigateToInformationBetweenTests,
    );
    on<HeadphonesCalibrationModuleNavigateToSecondTest>(
      _onNavigateToSecondTest,
    );
    on<HeadphonesCalibrationModuleNavigateToEnd>(_onNavigateToEnd);
    on<HeadphonesCalibrationModuleNavigateToExit>(_onNavigateToExit);
    on<HeadphonesCalibrationModuleSelectReferenceHeadphone>(
      _onSelectReferenceHeadphone,
    );
    on<HeadphonesCalibrationModuleSelectTargetHeadphone>(
      _onSelectTargetHeadphone,
    );
    on<HeadphonesCalibrationModuleRemoveReferenceHeadphone>(
      _onRemoveReferenceHeadphone,
    );
    on<HeadphonesCalibrationModuleRemoveTargetHeadphone>(
      _onRemoveTargetHeadphone,
    );
    on<HeadphonesCalibrationModuleUpdateSearchQuery>(_onUpdateSearchQuery);
    on<HeadphonesCalibrationModulePerformSearch>(_onPerformSearch);
    on<HeadphonesCalibrationModuleAddHeadphoneFromSearch>(
      _onAddHeadphoneFromSearch,
    );
    on<HeadphonesCalibrationModuleTestCompleted>(_onHearingTestCompleted);

    hearingTestBloc.stream.listen((hearingTestState) {
      if (hearingTestState.isTestCompleted) {
        add(
          HeadphonesCalibrationModuleTestCompleted(
            results: hearingTestState.results,
          ),
        );
      }
    });

    add(HeadphonesCalibrationModuleStart());
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> _saveHeadphonesToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
      LOCAL_STORAGE_REFERENCE_HEADPHONES,
      state.availableReferenceHeadphones.map((h) => h.name).toList(),
    );
    prefs.setStringList(
      LOCAL_STORAGE_TARGET_HEADPHONES,
      state.availableTargetHeadphones.map((h) => h.name).toList(),
    );
  }

  Future<void> _loadHeadphonesFromLocalStorage(
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final storedReferenceNames =
        prefs.getStringList(LOCAL_STORAGE_REFERENCE_HEADPHONES) ?? [];
    final storedTargetNames =
        prefs.getStringList(LOCAL_STORAGE_TARGET_HEADPHONES) ?? [];

    final allNames = {...storedReferenceNames, ...storedTargetNames}.toList();
    final futures =
        allNames
            .map((name) => databaseRepository.searchHeadphone(name: name))
            .toList();

    // Wait for all async results
    final allHeadphonesWithNulls = await Future.wait(futures);

    // Remove nulls
    final allHeadphones =
        allHeadphonesWithNulls.whereType<HeadphonesModel>().toList();

    // Split based on grade threshold
    final availableReferences =
        allHeadphones
            .where((h) => h.grade > HEADPHONES_GRADE_THRESHOLD)
            .toList();

    final availableTargets =
        allHeadphones
            .where((h) => h.grade <= HEADPHONES_GRADE_THRESHOLD)
            .toList();

    emit(
      state.copyWith(
        availableReferenceHeadphones: availableReferences,
        availableTargetHeadphones: availableTargets,
      ),
    );
  }

  void _onStart(
    HeadphonesCalibrationModuleStart event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    emit(HeadphonesCalibrationModuleState());

    await _loadHeadphonesFromLocalStorage(emit);
  }

  void _onNavigateToExit(
    HeadphonesCalibrationModuleNavigateToExit event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.exit));
  }

  void _onNavigateToWelcome(
    HeadphonesCalibrationModuleNavigateToWelcome event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    hearingTestBloc.add(HearingTestInitialize());
    emit(HeadphonesCalibrationModuleState());

    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.welcome));
  }

  void _onNavigateToFirstTest(
    HeadphonesCalibrationModuleNavigateToFirstTest event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.firstTest));
    hearingTestBloc.add(HearingTestStartTest());
  }

  void _onNavigateToInformationBetweenTests(
    HeadphonesCalibrationModuleNavigateToInformationBetweenTests event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(
      state.copyWith(
        currentStep: HeadphonesCalibrationStep.informationBetweenTests,
      ),
    );
  }

  void _onNavigateToSecondTest(
    HeadphonesCalibrationModuleNavigateToSecondTest event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    hearingTestBloc.add(HearingTestInitialize());
    hearingTestBloc.add(HearingTestStartTest());
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.secondTest));
  }

  void _onNavigateToEnd(
    HeadphonesCalibrationModuleNavigateToEnd event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.end));
  }

  void _onSelectReferenceHeadphone(
    HeadphonesCalibrationModuleSelectReferenceHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(
      state.copyWith(
        selectedReferenceHeadphone:
            event.headphone == state.selectedReferenceHeadphone
                ? null
                : event.headphone,
      ),
    );
  }

  void _onSelectTargetHeadphone(
    HeadphonesCalibrationModuleSelectTargetHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(
      state.copyWith(
        selectedTargetHeadphone:
            event.headphone == state.selectedTargetHeadphone
                ? null
                : event.headphone,
      ),
    );
  }

  void _onRemoveReferenceHeadphone(
    HeadphonesCalibrationModuleRemoveReferenceHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    final updated = List.of(state.availableReferenceHeadphones)
      ..remove(event.headphone);
    emit(
      state.copyWith(
        availableReferenceHeadphones: updated,
        selectedReferenceHeadphone: null,
      ),
    );
    _saveHeadphonesToLocalStorage();
  }

  void _onRemoveTargetHeadphone(
    HeadphonesCalibrationModuleRemoveTargetHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    final updated = List.of(state.availableTargetHeadphones)
      ..remove(event.headphone);
    emit(
      state.copyWith(
        availableTargetHeadphones: updated,
        selectedTargetHeadphone: null,
      ),
    );
    _saveHeadphonesToLocalStorage();
  }

  void _onUpdateSearchQuery(
    HeadphonesCalibrationModuleUpdateSearchQuery event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        searchResult: '',
        isSearching: false,
      ),
    );

    _searchDebounceTimer?.cancel();

    emit(state.copyWith(isSearching: true));

    _searchDebounceTimer = Timer(_searchDebounceDelay, () {
      if (!isClosed) {
        add(HeadphonesCalibrationModulePerformSearch(event.query));
      }
    });
  }

  void _onPerformSearch(
    HeadphonesCalibrationModulePerformSearch event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    // Only perform search if the query matches the current state
    if (event.query != state.searchQuery) {
      return;
    }

    emit(state.copyWith(isSearching: true));

    final searchResult = await headphonesSearcherRepository.searchHeadphones(
      keyword: event.query,
    );

    // Check again if the query is still current after async operation
    if (event.query == state.searchQuery) {
      emit(
        state.copyWith(
          searchResult: searchResult.extractedModel,
          isSearching: false,
        ),
      );
    }
  }

  void _onAddHeadphoneFromSearch(
    HeadphonesCalibrationModuleAddHeadphoneFromSearch event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    // Check in what place there should go
    HeadphonesModel? headphones = await databaseRepository.searchHeadphone(
      name: event.headphone.name,
    );

    // If they are new or are not reference headphones.
    if (headphones == null || headphones.grade < HEADPHONES_GRADE_THRESHOLD) {
      final alreadyExists = state.availableTargetHeadphones.any(
        (h) => h.name.toLowerCase() == event.headphone.name.toLowerCase(),
      );

      if (!alreadyExists) {
        final updatedTargetHeadphones = [
          ...state.availableTargetHeadphones,
          event.headphone,
        ];

        emit(
          state.copyWith(
            availableTargetHeadphones: updatedTargetHeadphones,
            searchResult: '',
            searchQuery: '',
          ),
        );
      }

      _saveHeadphonesToLocalStorage();

      return;
    }

    // They are reference headphones
    final alreadyExists = state.availableReferenceHeadphones.any(
      (h) => h.name.toLowerCase() == event.headphone.name.toLowerCase(),
    );

    if (!alreadyExists) {
      final updatedReferenceHeadphones = [
        ...state.availableReferenceHeadphones,
        event.headphone,
      ];

      emit(
        state.copyWith(
          availableReferenceHeadphones: updatedReferenceHeadphones,
          searchResult: '',
          searchQuery: '',
        ),
      );
    }

    _saveHeadphonesToLocalStorage();
  }

  void _onHearingTestCompleted(
    HeadphonesCalibrationModuleTestCompleted event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    if (state.currentStep == HeadphonesCalibrationStep.firstTest) {
      emit(
        state.copyWith(
          firstTestResults: event.results,
          currentStep: HeadphonesCalibrationStep.informationBetweenTests,
        ),
      );
    } else if (state.currentStep == HeadphonesCalibrationStep.secondTest) {
      emit(
        state.copyWith(
          secondTestResults: event.results,
          currentStep: HeadphonesCalibrationStep.end,
        ),
      );

      final firstResults = state.firstTestResults;
      final secondResults = event.results;

      // If this returns, something went horribly wrong.
      if (firstResults == null) return;

      // TODO: Inform user about it.
      if (firstResults.hasMissingValues() || secondResults.hasMissingValues()) {
        return;
      }

      final targetFrequencies = [125, 250, 500, 1000, 2000, 4000, 8000];

      final firstLeftMapping = HearingTestUtils.getFrequencyMapping(
        firstResults.leftEarResults.toList(),
      );
      final firstRightMapping = HearingTestUtils.getFrequencyMapping(
        firstResults.rightEarResults.toList(),
      );
      final secondLeftMapping = HearingTestUtils.getFrequencyMapping(
        secondResults.leftEarResults.toList(),
      );
      final secondRightMapping = HearingTestUtils.getFrequencyMapping(
        secondResults.rightEarResults.toList(),
      );

      Map<int, double> avgCorrections = {};

      final firstLeftMapped = _mapHearingTestResults(
        firstResults.leftEarResults,
      );
      final firstRightMapped = _mapHearingTestResults(
        firstResults.rightEarResults,
      );
      final secondLeftMapped = _mapHearingTestResults(
        secondResults.leftEarResults,
      );
      final secondRightMapped = _mapHearingTestResults(
        secondResults.rightEarResults,
      );

      // Calculate average corrections for each frequency
      for (int i = 0; i < targetFrequencies.length; i++) {
        final freq = targetFrequencies[i];

        // Calculate average difference between second and first test
        avgCorrections[freq] =
            ((secondLeftMapped[i] - firstLeftMapped[i]) +
                (secondRightMapped[i] - firstRightMapped[i])) /
            2.0;
      }

      await databaseRepository.insertOrUpdateHeadphone(
        name: state.selectedTargetHeadphone!.name,
        hz125Correction: avgCorrections[125] ?? 0,
        hz250Correction: avgCorrections[250] ?? 0,
        hz500Correction: avgCorrections[500] ?? 0,
        hz1000Correction: avgCorrections[1000] ?? 0,
        hz2000Correction: avgCorrections[2000] ?? 0,
        hz4000Correction: avgCorrections[4000] ?? 0,
        hz8000Correction: avgCorrections[8000] ?? 0,
      );

      hearingTestBloc.add(HearingTestInitialize());
    }
  }
}

// Maybe put it on the level of hearing test?
List<double> _mapHearingTestResults(List<double?> values) {
  var mapping = HearingTestUtils.getFrequencyMapping(values);
  List<double> mapped = List.filled(mapping.length, 0.0);
  for (final entry in mapping) {
    final sourceIndex = entry.key;
    final targetIndex = entry.value;
    if (sourceIndex >= 0 && sourceIndex < values.length) {
      mapped[targetIndex] = values[sourceIndex] ?? 0.0;
    }
  }
  return mapped;
}
