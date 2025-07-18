part of 'hearing_test_history_results_cubit.dart';

class HearingTestHistoryResultsState extends Equatable {
  final bool isLoading;
  final List<HearingTestResult> results;
  final int? selectedIndex;
  final String? error;

  const HearingTestHistoryResultsState({
    this.isLoading = false,
    this.results = const [],
    this.selectedIndex,
    this.error,
  });

  HearingTestHistoryResultsState copyWith({
    bool? isLoading,
    List<HearingTestResult>? results,
    int? selectedIndex,
    String? error,
  }) {
    return HearingTestHistoryResultsState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      selectedIndex: selectedIndex,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, results, selectedIndex, error];
}
