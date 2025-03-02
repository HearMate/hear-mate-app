part of 'hearing_test_bloc.dart';

class HearingTestState {
  final bool isButtonPressed;
  final bool wasSoundHeard;
  final bool currentEar; // false is left, true is right
  final bool isTestCanceled;
  final int currentFrequencyIndex;
  final double currentDBLevel;
  final Map<double, int> dbLevelToHearCountMap;
  final List<double> results;

  HearingTestState({
    this.isButtonPressed = false,
    this.wasSoundHeard = false,
    this.currentEar = false,
    this.isTestCanceled = false,
    this.currentFrequencyIndex = 0,
    this.currentDBLevel = 60,
    this.dbLevelToHearCountMap = const {},
    this.results = const [],
  });

  HearingTestState copyWith({
    bool? isButtonPressed,
    bool? wasSoundHeard,
    bool? currentEar,
    bool? isTestCanceled,
    int? currentFrequencyIndex,
    double? currentDBLevel,
    Map<double, int>? dbLevelToHearCountMap,
    List<double>? results,
  }) {
    return HearingTestState(
      isButtonPressed: isButtonPressed ?? this.isButtonPressed,
      wasSoundHeard: wasSoundHeard ?? this.wasSoundHeard,
      currentEar: currentEar ?? this.currentEar,
      isTestCanceled: isTestCanceled ?? this.isTestCanceled,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
      currentDBLevel: currentDBLevel ?? this.currentDBLevel,
      dbLevelToHearCountMap:
          dbLevelToHearCountMap ?? this.dbLevelToHearCountMap,
      results: results ?? this.results,
    );
  }
}
