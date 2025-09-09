part of 'hearing_test_bloc.dart';

@immutable
sealed class HearingTestEvent {}

class HearingTestInitialize extends HearingTestEvent {}

class HearingTestStartTest extends HearingTestEvent {
  final HeadphonesModel headphonesModel;

  HearingTestStartTest({required this.headphonesModel});
}

class HearingTestButtonPressed extends HearingTestEvent {}

class HearingTestButtonReleased extends HearingTestEvent {}

class HearingTestPlayingSound extends HearingTestEvent {}

class HearingTestNextFrequency extends HearingTestEvent {}

class HearingTestChangeEar extends HearingTestEvent {}

class HearingTestCompleted extends HearingTestEvent {}

class HearingTestPlayingMaskedSound extends HearingTestEvent {}

class HearingTestNextMaskedFrequency extends HearingTestEvent {}

class HearingTestStartMaskedTest extends HearingTestEvent {}

// DEBUG

class HearingTestDebugEarLeftPartial extends HearingTestEvent {}

class HearingTestDebugEarRightPartial extends HearingTestEvent {}

class HearingTestDebugBothEarsFull extends HearingTestEvent {}
