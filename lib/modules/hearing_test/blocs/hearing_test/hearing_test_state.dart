part of 'hearing_test_bloc.dart';

class HearingTestState {
  final bool isButtonPressed;
  final bool wasSoundHeard;
  final bool isTestCompleted;

  final int currentFrequencyIndex;
  final double currentDBLevel;
  final HearingTestEar currentEar;

  final Map<double, int> dbLevelToHearCountMap;
  final HearingTestResult results;
  final bool resultSaved;

  HearingTestState({
    this.isButtonPressed = false,
    this.wasSoundHeard = false,
    this.currentEar = HearingTestEar.LEFT,
    this.isTestCompleted = false,
    this.currentFrequencyIndex = 0,
    this.currentDBLevel = 60,
    this.dbLevelToHearCountMap = const {},
    this.resultSaved = false,
    HearingTestResult? results,
  }) : results =
           results ??
           HearingTestResult(
             filePath: "",
             dateLabel: "",
             leftEarResults: List<double?>.filled(
               HearingTestConstants.TEST_FREQUENCIES.length,
               null,
             ),
             rightEarResults: List<double?>.filled(
               HearingTestConstants.TEST_FREQUENCIES.length,
               null,
             ),
           );
  HearingTestState copyWith({
    bool? isButtonPressed,
    bool? wasSoundHeard,
    HearingTestEar? currentEar,
    bool? isTestCompleted,
    int? currentFrequencyIndex,
    double? currentDBLevel,
    Map<double, int>? dbLevelToHearCountMap,
    HearingTestResult? results,
    bool? resultSaved,
  }) {
    return HearingTestState(
      isButtonPressed: isButtonPressed ?? this.isButtonPressed,
      wasSoundHeard: wasSoundHeard ?? this.wasSoundHeard,
      currentEar: currentEar ?? this.currentEar,
      isTestCompleted: isTestCompleted ?? this.isTestCompleted,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
      currentDBLevel: currentDBLevel ?? this.currentDBLevel,
      dbLevelToHearCountMap:
          dbLevelToHearCountMap ?? this.dbLevelToHearCountMap,
      results: results ?? this.results,
      resultSaved: resultSaved ?? this.resultSaved,
    );
  }
}
