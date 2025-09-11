import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/features/headphones_search/models/headphones_model.dart';
import 'package:hear_mate_app/shared/repositories/database_repository.dart';
import 'package:hear_mate_app/shared/utils/cooldown.dart';
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
  final AppLocalizations l10n;
  final HearingTestBloc hearingTestBloc;

  final LOCAL_STORAGE_REFERENCE_HEADPHONES = "available_reference_headphones";
  final LOCAL_STORAGE_TARGET_HEADPHONES = "available_target_headphones";

  HeadphonesCalibrationModuleBloc({
    required this.l10n,
    required this.databaseRepository,
  }) : hearingTestBloc = HearingTestBloc(l10n: l10n),
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

    // Replace nulls with HeadphonesModel using cached name
    final List<HeadphonesModel> allHeadphones = [];
    for (int i = 0; i < allNames.length; i++) {
      final headphone =
          allHeadphonesWithNulls[i] ?? HeadphonesModel.empty(name: allNames[i]);
      allHeadphones.add(headphone);
    }

    // Split based on grade threshold
    final availableReferences = allHeadphones.toList();

    final availableTargets = allHeadphones.toList();

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
    final isCooldownActive = await Cooldown.isCooldownActive();
    emit(state.copyWith(isCooldownActive: isCooldownActive));
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
    hearingTestBloc.add(
      HearingTestStartTest(
        headphonesModel:
            state.selectedReferenceHeadphone ?? HeadphonesModel.empty(),
        step: 2.5,
      ),
    );
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
    hearingTestBloc.add(HearingTestInitialize());
  }

  void _onNavigateToSecondTest(
    HeadphonesCalibrationModuleNavigateToSecondTest event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    hearingTestBloc.add(
      HearingTestStartTest(
        headphonesModel:
            state.selectedTargetHeadphone ?? HeadphonesModel.empty(),
        step: 2.5,
      ),
    );
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

  void _onAddHeadphoneFromSearch(
    HeadphonesCalibrationModuleAddHeadphoneFromSearch event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) async {
    // Check in what place there should go
    HeadphonesModel? headphones = await databaseRepository.searchHeadphone(
      name: event.headphone.name,
    );

    // If they are new or are not reference headphones.
    if (headphones == null) {
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
          firstTestResults: event.results.copy(),
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

      Cooldown.startCooldown(Duration(minutes: 20));

      final firstResults = state.firstTestResults;
      final secondResults = event.results;

      // If this returns, something went horribly wrong.
      if (firstResults == null) return;

      // TODO: Inform user about it.
      if (firstResults.hasMissingValues() || secondResults.hasMissingValues()) {
        return;
      }

      final targetFrequencies = [125, 250, 500, 1000, 2000, 4000, 8000];

      Map<int, double> corrections = {};

      // Calculate average corrections for each frequency
      for (int i = 0; i < targetFrequencies.length; i++) {
        final freq = targetFrequencies[i];

        final leftDiff =
            (secondResults.hearingLossLeft[i]?.value ?? 0) -
            (firstResults.hearingLossLeft[i]?.value ?? 0);
        final rightDiff =
            (secondResults.hearingLossRight[i]?.value ?? 0) -
            (firstResults.hearingLossRight[i]?.value ?? 0);

        if ((leftDiff - rightDiff).abs() > 10) return;
        double avgDifference = (leftDiff + rightDiff) / 2.0;
        corrections[freq] =
            avgDifference + state.selectedReferenceHeadphone!.getFreq(freq);
      }

      await databaseRepository.insertOrUpdateHeadphone(
        name: state.selectedTargetHeadphone!.name,
        hz125Correction: corrections[125] ?? 0,
        hz250Correction: corrections[250] ?? 0,
        hz500Correction: corrections[500] ?? 0,
        hz1000Correction: corrections[1000] ?? 0,
        hz2000Correction: corrections[2000] ?? 0,
        hz4000Correction: corrections[4000] ?? 0,
        hz8000Correction: corrections[8000] ?? 0,
      );
    }
  }
}
