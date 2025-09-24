part of 'hearing_test_bloc.dart';

class HearingTestState {
  final bool isButtonPressed;
  final bool wasSoundHeard;
  final bool isTestCompleted;
  final bool isMaskingStarted;

  final int currentFrequencyIndex;
  final double currentDBLevel;
  final double currentMaskingDBLevel;
  final HearingTestEar currentEar;

  final Map<double, int> dbLevelToHearCountMap;
  final List<bool>? frequenciesThatRequireMasking;
  final int? maskedHeardCount;

  final List<double?> leftEarResults;
  final List<double?> rightEarResults;
  final List<double?> leftEarResultsMasked;
  final List<double?> rightEarResultsMasked;

  final HearingTestResult results;

  final double step;
  final bool endEarly;

  HearingTestState({
    this.isButtonPressed = false,
    this.wasSoundHeard = false,
    this.currentEar = HearingTestEar.LEFT,
    this.isTestCompleted = false,
    this.isMaskingStarted = false,
    this.currentFrequencyIndex = 0,
    this.currentMaskingDBLevel = 0,
    this.currentDBLevel = 20,
    this.dbLevelToHearCountMap = const {},
    this.frequenciesThatRequireMasking,
    this.maskedHeardCount = 0,
    List<double?>? leftEarResults,
    List<double?>? rightEarResults,
    List<double?>? leftEarResultsMasked,
    List<double?>? rightEarResultsMasked,
    HearingTestResult? results,
    this.step = 5,
    this.endEarly = false,
  }) : leftEarResults =
           leftEarResults ??
           List<double?>.filled(
             HearingTestConstants.TEST_FREQUENCIES.length,
             null,
             growable: false,
           ),
       rightEarResults =
           rightEarResults ??
           List<double?>.filled(
             HearingTestConstants.TEST_FREQUENCIES.length,
             null,
             growable: false,
           ),
       leftEarResultsMasked =
           leftEarResultsMasked ??
           List<double?>.filled(
             HearingTestConstants.TEST_FREQUENCIES.length,
             null,
             growable: false,
           ),
       rightEarResultsMasked =
           rightEarResultsMasked ??
           List<double?>.filled(
             HearingTestConstants.TEST_FREQUENCIES.length,
             null,
             growable: false,
           ),
       results = results ?? HearingTestResult.empty;

  HearingTestState copyWith({
    bool? isButtonPressed,
    bool? wasSoundHeard,
    HearingTestEar? currentEar,
    bool? isTestCompleted,
    bool? isMaskingStarted,
    int? currentFrequencyIndex,
    double? currentDBLevel,
    double? currentMaskingDBLevel,
    Map<double, int>? dbLevelToHearCountMap,
    List<bool>? frequenciesThatRequireMasking,
    int? maskedHeardCount,
    List<double?>? leftEarResults,
    List<double?>? rightEarResults,
    List<double?>? leftEarResultsMasked,
    List<double?>? rightEarResultsMasked,
    HearingTestResult? results,
    double? step,
    bool? endEarly,
  }) {
    return HearingTestState(
      isButtonPressed: isButtonPressed ?? this.isButtonPressed,
      wasSoundHeard: wasSoundHeard ?? this.wasSoundHeard,
      currentEar: currentEar ?? this.currentEar,
      isTestCompleted: isTestCompleted ?? this.isTestCompleted,
      isMaskingStarted: isMaskingStarted ?? this.isMaskingStarted,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
      currentDBLevel: currentDBLevel ?? this.currentDBLevel,
      currentMaskingDBLevel:
          currentMaskingDBLevel ?? this.currentMaskingDBLevel,
      dbLevelToHearCountMap:
          dbLevelToHearCountMap ?? this.dbLevelToHearCountMap,
      results: results ?? this.results,
      frequenciesThatRequireMasking:
          frequenciesThatRequireMasking ?? this.frequenciesThatRequireMasking,
      maskedHeardCount: maskedHeardCount ?? this.maskedHeardCount,
      leftEarResults: leftEarResults ?? this.leftEarResults,
      rightEarResults: rightEarResults ?? this.rightEarResults,
      leftEarResultsMasked: leftEarResultsMasked ?? this.leftEarResultsMasked,
      rightEarResultsMasked:
          rightEarResultsMasked ?? this.rightEarResultsMasked,
      step: step ?? this.step,
      endEarly: endEarly ?? this.endEarly,
    );
  }
}
