part of 'headphones_search_bar_supabase_cubit.dart';

class HeadphonesSearchBarSupabaseState extends Equatable {
  final String query;
  final bool isSearching;
  final List<String> results;
  final String result;

  const HeadphonesSearchBarSupabaseState({
    this.query = '',
    this.isSearching = false,
    this.results = const [],
    this.result = '',
  });

  HeadphonesSearchBarSupabaseState copyWith({
    String? query,
    bool? isSearching,
    List<String>? results,
  }) {
    return HeadphonesSearchBarSupabaseState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [query, isSearching, results];
}
