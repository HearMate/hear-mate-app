part of 'hearing_test_module_bloc.dart';

enum HearingTestPageStep { welcome, test, result, history }

class HearingTestModuleState {
  final HearingTestPageStep currentStep;
  final bool disclaimerShown;
  final HearingTestResult? results;
  final bool resultsSaved;
  final HeadphonesModel? headphonesModel;
  final String? searchResult;
  final HeadphonesModel? selectedReferenceHeadphone;
  final HeadphonesModel? selectedTargetHeadphone;

  HearingTestModuleState({
    this.currentStep = HearingTestPageStep.welcome,
    this.disclaimerShown = false,
    this.results,
    this.resultsSaved = false,
    this.headphonesModel,
    this.searchResult,
    this.selectedReferenceHeadphone,
    this.selectedTargetHeadphone,
  });

  HearingTestModuleState copyWith({
    HearingTestPageStep? currentStep,
    bool? disclaimerShown,
    HearingTestResult? results,
    bool? resultsSaved,
    HeadphonesModel? headphonesModel,
    String? searchResult,
    HeadphonesModel? selectedReferenceHeadphone,
    HeadphonesModel? selectedTargetHeadphone,
  }) {
    return HearingTestModuleState(
      currentStep: currentStep ?? this.currentStep,
      disclaimerShown: disclaimerShown ?? this.disclaimerShown,
      results: results ?? this.results,
      resultsSaved: resultsSaved ?? this.resultsSaved,
      headphonesModel: headphonesModel ?? this.headphonesModel,
      searchResult: searchResult ?? this.searchResult,
      selectedReferenceHeadphone:
          selectedReferenceHeadphone ?? this.selectedReferenceHeadphone,
      selectedTargetHeadphone:
          selectedTargetHeadphone ?? this.selectedTargetHeadphone,
    );
  }
}
