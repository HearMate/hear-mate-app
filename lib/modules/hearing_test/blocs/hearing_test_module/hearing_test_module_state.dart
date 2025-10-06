part of 'hearing_test_module_bloc.dart';

enum HearingTestPageStep { welcome, test, result, history }

class HearingTestModuleState {
  final HearingTestPageStep currentStep;
  final bool disclaimerShown;
  final HearingTestResult? results;
  final bool resultsSaved;
  final HeadphonesModel? selectedHeadphone;

  HearingTestModuleState({
    this.currentStep = HearingTestPageStep.welcome,
    this.disclaimerShown = false,
    this.results,
    this.resultsSaved = false,
    this.selectedHeadphone,
  });

  HearingTestModuleState copyWith({
    HearingTestPageStep? currentStep,
    bool? disclaimerShown,
    HearingTestResult? results,
    bool? resultsSaved,
    Object? selectedHeadphone = _notProvided,
  }) {
    return HearingTestModuleState(
      currentStep: currentStep ?? this.currentStep,
      disclaimerShown: disclaimerShown ?? this.disclaimerShown,
      results: results ?? this.results,
      resultsSaved: resultsSaved ?? this.resultsSaved,
      selectedHeadphone:
          selectedHeadphone == _notProvided
              ? this.selectedHeadphone
              : selectedHeadphone as HeadphonesModel?,
    );
  }

  static const Object _notProvided = Object();
}
