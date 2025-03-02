part of 'hearing_test_bloc.dart';

@immutable
sealed class HearingTestEvent {}

class HearingTestStartTest extends HearingTestEvent {}

class HearingTestButtonPressed extends HearingTestEvent {}

class HearingTestButtonReleased extends HearingTestEvent {}

class HearingTestEndTestEarly extends HearingTestEvent {}

class HearingTestCompleted extends HearingTestEvent {
  final List<Map<String, dynamic>> testResults;
  HearingTestCompleted(this.testResults);
}
