part of 'headphones_calibration_module_bloc.dart';

enum HeadphonesCalibrationStep {
  welcome,
  informationBeforeTests,
  firstTest,
  informationBetweenTests,
  abortCalibration,
  secondTest,
  end,
  exit,
}

class HeadphonesCalibrationModuleState {
  final HeadphonesCalibrationStep currentStep;
  final HeadphonesModel? selectedReferenceHeadphone;
  final HeadphonesModel? selectedTargetHeadphone;
  final String? searchResult;
  final HearingTestResult? firstTestResults;
  final HearingTestResult? secondTestResults;
  final bool isCooldownActive;
  final bool headphonesDifferent;

  HeadphonesCalibrationModuleState({
    this.currentStep = HeadphonesCalibrationStep.welcome,
    this.selectedReferenceHeadphone,
    this.selectedTargetHeadphone,
    this.searchResult,
    this.firstTestResults,
    this.secondTestResults,
    this.isCooldownActive = false,
    this.headphonesDifferent = false,
  });

  HeadphonesCalibrationModuleState copyWith({
    HeadphonesCalibrationStep? currentStep,
    Object? selectedReferenceHeadphone = _notProvided,
    Object? selectedTargetHeadphone = _notProvided,
    String? searchResult,
    HearingTestResult? firstTestResults,
    HearingTestResult? secondTestResults,
    bool? isCooldownActive,
    bool? headphonesDifferent,
  }) {
    return HeadphonesCalibrationModuleState(
      currentStep: currentStep ?? this.currentStep,
      selectedReferenceHeadphone:
          selectedReferenceHeadphone == _notProvided
              ? this.selectedReferenceHeadphone
              : selectedReferenceHeadphone as HeadphonesModel?,
      selectedTargetHeadphone:
          selectedTargetHeadphone == _notProvided
              ? this.selectedTargetHeadphone
              : selectedTargetHeadphone as HeadphonesModel?,
      searchResult: searchResult ?? this.searchResult,
      firstTestResults: firstTestResults ?? this.firstTestResults,
      secondTestResults: secondTestResults ?? this.secondTestResults,
      isCooldownActive: isCooldownActive ?? this.isCooldownActive,
      headphonesDifferent: headphonesDifferent ?? this.headphonesDifferent,
    );
  }

  static const Object _notProvided = Object();
}
