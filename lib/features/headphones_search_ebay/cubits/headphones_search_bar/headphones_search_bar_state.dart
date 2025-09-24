part of 'headphones_search_bar_cubit.dart';

class HeadphonesSearchBarState extends Equatable {
  final bool isSearching;
  final String query;
  final String result;

  const HeadphonesSearchBarState({
    this.isSearching = false,
    this.query = '',
    this.result = '',
  });

  HeadphonesSearchBarState copyWith({
    bool? isSearching,
    String? query,
    String? result,
  }) {
    return HeadphonesSearchBarState(
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [query, result, isSearching];
}
