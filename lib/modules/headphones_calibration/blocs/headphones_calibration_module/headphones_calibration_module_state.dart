part of 'headphones_calibration_module_bloc.dart';

enum HeadphonesCalibrationStep {
  welcome,
  firstTest,
  informationBetweenTests,
  secondTest,
  end,
}

class HeadphonesCalibrationModuleState {
  final HeadphonesCalibrationStep currentStep;
  final HeadphonesModel? selectedReferenceHeadphone;
  final HeadphonesModel? selectedTargetHeadphone;
  final List<HeadphonesModel> availableReferenceHeadphones;
  final List<HeadphonesModel> availableTargetHeadphones;
  final String searchQuery;
  final HearingTestResult? firstTestResults;
  final HearingTestResult? secondTestResults;

  HeadphonesCalibrationModuleState({
    this.currentStep = HeadphonesCalibrationStep.welcome,
    this.selectedReferenceHeadphone,
    this.selectedTargetHeadphone,
    this.availableReferenceHeadphones = const [],
    this.availableTargetHeadphones = const [],

    this.searchQuery = '',
    this.firstTestResults,
    this.secondTestResults,
  });

  HeadphonesCalibrationModuleState copyWith({
    HeadphonesCalibrationStep? currentStep,
    HeadphonesModel? selectedReferenceHeadphone,
    HeadphonesModel? selectedTargetHeadphone,
    List<HeadphonesModel>? availableReferenceHeadphones,
    List<HeadphonesModel>? availableTargetHeadphones,
    String? searchQuery,
    HearingTestResult? firstTestResults,
    HearingTestResult? secondTestResults,
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
      searchQuery: searchQuery ?? this.searchQuery,
      firstTestResults: firstTestResults ?? this.firstTestResults,
      secondTestResults: secondTestResults ?? this.secondTestResults,
    );
  }

  List<HeadphonesModel> get filteredReferenceHeadphones {
    if (searchQuery.isEmpty) return availableReferenceHeadphones;
    return availableReferenceHeadphones
        .where(
          (headphone) =>
              headphone.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              headphone.manufacturer.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  List<HeadphonesModel> get filteredTargetHeadphones {
    if (searchQuery.isEmpty) return availableTargetHeadphones;
    return availableTargetHeadphones
        .where(
          (headphone) =>
              headphone.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              headphone.manufacturer.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }
}
