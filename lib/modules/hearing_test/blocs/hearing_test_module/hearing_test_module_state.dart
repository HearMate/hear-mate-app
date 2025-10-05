part of 'hearing_test_module_bloc.dart';

enum HearingTestPageStep { welcome, test, result, history }

class HearingTestModuleState {
  final HearingTestPageStep currentStep;
  final bool disclaimerShown;
  final HearingTestResult? results;
  final bool resultsSaved;
  final HeadphonesModel? headphonesModel;
  final HeadphonesModel? selectedHeadphone;

  HearingTestModuleState({
    this.currentStep = HearingTestPageStep.welcome,
    this.disclaimerShown = false,
    this.results,
    this.resultsSaved = false,
    this.headphonesModel,
    this.selectedHeadphone,
  });

  HearingTestModuleState copyWith({
    HearingTestPageStep? currentStep,
    bool? disclaimerShown,
    HearingTestResult? results,
    bool? resultsSaved,
    HeadphonesModel? headphonesModel,
    HeadphonesModel? selectedHeadphone,
    bool clearSelectedHeadphone = false,
  }) {
    return HearingTestModuleState(
      currentStep: currentStep ?? this.currentStep,
      disclaimerShown: disclaimerShown ?? this.disclaimerShown,
      results: results ?? this.results,
      resultsSaved: resultsSaved ?? this.resultsSaved,
      headphonesModel: headphonesModel ?? this.headphonesModel,
      selectedHeadphone:
          clearSelectedHeadphone
              ? null
              : (selectedHeadphone ?? this.selectedHeadphone),
    );
  }
}
