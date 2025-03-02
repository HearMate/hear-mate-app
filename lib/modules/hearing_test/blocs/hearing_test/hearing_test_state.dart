part of 'hearing_test_bloc.dart';

class HearingTestState {
  final bool isButtonPressed;
  final bool isSoundPlaying;
  final List<Map<String, dynamic>> results;

  HearingTestState({
    this.isButtonPressed = false,
    this.isSoundPlaying = false,
    this.results = const [],
  });

  HearingTestState copyWith({
    bool? isButtonPressed,
    bool? isSoundPlaying,
    List<Map<String, dynamic>>? results,
  }) {
    return HearingTestState(
      isButtonPressed: isButtonPressed ?? this.isButtonPressed,
      isSoundPlaying: isSoundPlaying ?? this.isSoundPlaying,
      results: results ?? this.results,
    );
  }
}
