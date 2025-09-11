part of 'headphones_calibration_module_bloc.dart';

enum HeadphonesCalibrationStep {
  welcome,
  firstTest,
  informationBetweenTests,
  secondTest,
  end,
  exit,
}

class HeadphonesCalibrationModuleState {
  final HeadphonesCalibrationStep currentStep;
  final HeadphonesModel? selectedReferenceHeadphone;
  final HeadphonesModel? selectedTargetHeadphone;
  final List<HeadphonesModel> availableReferenceHeadphones;
  final List<HeadphonesModel> availableTargetHeadphones;
  final String? searchResult;
  final HearingTestResult? firstTestResults;
  final HearingTestResult? secondTestResults;
  final bool isCooldownActive;

  HeadphonesCalibrationModuleState({
    this.currentStep = HeadphonesCalibrationStep.welcome,
    this.selectedReferenceHeadphone,
    this.selectedTargetHeadphone,
    this.availableReferenceHeadphones = const [],
    this.availableTargetHeadphones = const [],
    this.searchResult,
    this.firstTestResults,
    this.secondTestResults,
    this.isCooldownActive = false,
  });

  HeadphonesCalibrationModuleState copyWith({
    HeadphonesCalibrationStep? currentStep,
    HeadphonesModel? selectedReferenceHeadphone,
    HeadphonesModel? selectedTargetHeadphone,
    List<HeadphonesModel>? availableReferenceHeadphones,
    List<HeadphonesModel>? availableTargetHeadphones,
    String? searchResult,
    HearingTestResult? firstTestResults,
    HearingTestResult? secondTestResults,
    bool? isCooldownActive,
  }) {
    return HeadphonesCalibrationModuleState(
      currentStep: currentStep ?? this.currentStep,
      selectedReferenceHeadphone:
          selectedReferenceHeadphone ?? this.selectedReferenceHeadphone,
      selectedTargetHeadphone:
          selectedTargetHeadphone ?? this.selectedTargetHeadphone,
      availableReferenceHeadphones:
          availableReferenceHeadphones ?? this.availableReferenceHeadphones,
      availableTargetHeadphones:
          availableTargetHeadphones ?? this.availableTargetHeadphones,
      searchResult: searchResult ?? this.searchResult,
      firstTestResults: firstTestResults ?? this.firstTestResults,
      secondTestResults: secondTestResults ?? this.secondTestResults,
      isCooldownActive: isCooldownActive ?? this.isCooldownActive,
    );
  }
}
