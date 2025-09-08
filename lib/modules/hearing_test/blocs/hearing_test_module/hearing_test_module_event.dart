part of 'hearing_test_module_bloc.dart';

@immutable
sealed class HearingTestModuleBlocEvent {}

class HearingTestModuleStart extends HearingTestModuleBlocEvent {}

class HearingTestModuleNavigateToWelcome extends HearingTestModuleBlocEvent {}

class HearingTestModuleNavigateToHistory extends HearingTestModuleBlocEvent {}

class HearingTestModuleNavigateToTest extends HearingTestModuleBlocEvent {}

class HearingTestModuleNavigateToExit extends HearingTestModuleBlocEvent {}

class HearingTestModuleTestCompleted extends HearingTestModuleBlocEvent {
  final HearingTestResult results;

  HearingTestModuleTestCompleted({required this.results});
}

class HearingTestModuleSaveTestResults extends HearingTestModuleBlocEvent {}

class HearingTestModuleSelectHeadphoneFromSearch
    extends HearingTestModuleBlocEvent {
  final HeadphonesModel headphone;

  HearingTestModuleSelectHeadphoneFromSearch(this.headphone);
}
