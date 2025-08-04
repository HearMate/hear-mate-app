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
  final HearingTestResult results;
  final bool resultSaved;
  final List<bool>? frequenciesThatRequireMasking;
  final int? maskedHeardCount;

  final bool isLoadingAudiogramClassificationResults;
  final String audiogramClassification;

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
    this.resultSaved = false,
    this.frequenciesThatRequireMasking,
    this.maskedHeardCount = 0,
    this.isLoadingAudiogramClassificationResults = false,
    this.audiogramClassification = "",
    HearingTestResult? results,
  }) : results = results ?? HearingTestResult.empty;
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
    HearingTestResult? results,
    bool? resultSaved,
    List<bool>? frequenciesThatRequireMasking,
    int? maskedHeardCount,
    bool? isLoadingAudiogramClassificationResults,
    String? audiogramClassification,
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
      resultSaved: resultSaved ?? this.resultSaved,
      frequenciesThatRequireMasking:
          frequenciesThatRequireMasking ?? this.frequenciesThatRequireMasking,
      maskedHeardCount: maskedHeardCount ?? this.maskedHeardCount,
      isLoadingAudiogramClassificationResults:
          isLoadingAudiogramClassificationResults ??
          this.isLoadingAudiogramClassificationResults,
      audiogramClassification:
          audiogramClassification ?? this.audiogramClassification,
    );
  }
}
