part of 'hearing_test_module_bloc.dart';

enum HearingTestPageStep { welcome, test, result, history }

class HearingTestModuleState {
  final HearingTestPageStep currentStep;
  final bool disclaimerShown;
  final HearingTestResult? results;
  final bool isLoadingAudiogramClassificationResults;
  final String audiogramClassification;
  final bool resultsSaved;

  HearingTestModuleState({
    this.currentStep = HearingTestPageStep.welcome,
    this.disclaimerShown = false,
    this.results,
    this.isLoadingAudiogramClassificationResults = false,
    this.audiogramClassification = "",
    this.resultsSaved = false,
  });

  HearingTestModuleState copyWith({
    HearingTestPageStep? currentStep,
    bool? disclaimerShown,
    HearingTestResult? results,
    bool? isLoadingAudiogramClassificationResults,
    String? audiogramClassification,
    bool? resultsSaved,
  }) {
    return HearingTestModuleState(
      currentStep: currentStep ?? this.currentStep,
      disclaimerShown: disclaimerShown ?? this.disclaimerShown,
      results: results ?? this.results,
      isLoadingAudiogramClassificationResults:
          isLoadingAudiogramClassificationResults ??
          this.isLoadingAudiogramClassificationResults,
      audiogramClassification:
          audiogramClassification ?? this.audiogramClassification,
      resultsSaved: resultsSaved ?? this.resultsSaved,
    );
  }
}
