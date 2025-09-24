import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'headphones_search_bar_supabase_state.dart';

class HeadphonesSearchBarSupabaseCubit
    extends Cubit<HeadphonesSearchBarSupabaseState> {
  late final SupabaseClient _client;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Timer? _debounce;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  HeadphonesSearchBarSupabaseCubit()
    : super(const HeadphonesSearchBarSupabaseState()) {
    _client = SupabaseClient(
      dotenv.get('SUPABASE_URL'),
      dotenv.get('SUPABASE_ANON_KEY'),
    );

    controller.addListener(() {
      final query = controller.text;
      if (query != state.query) {
        updateQuery(query);
      }
    });

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(state.copyWith(results: []));
        });
      }
    });
  }

  void updateQuery(String query) {
    emit(state.copyWith(query: query, isSearching: true, results: const []));

    if (query.isNotEmpty) {
      _debounce?.cancel();
      _debounce = Timer(_debounceDuration, () {
        _performSearch(query);
      });
    } else {
      emit(state.copyWith(isSearching: false));
    }
  }

  void clearQuery() {
    controller.clear();
    emit(state.copyWith(query: '', results: const [], isSearching: false));
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(results: const [], isSearching: false));
      return;
    }

    try {
      final response = await _client
          .from('headphones')
          .select()
          .ilike('name', '%$query%')
          .limit(50);

      final names =
          (response as List)
              .map((item) => item['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList();

      emit(state.copyWith(results: names, isSearching: false));
    } catch (_) {
      emit(state.copyWith(isSearching: false, results: const []));
    }
  }

  Future<void> fetchAllRecords() async {
    emit(state.copyWith(isSearching: true, results: const []));
    try {
      final response = await _client
          .from('headphones')
          .select()
          .limit(50); // or any reasonable limit

      final names =
          (response as List)
              .map((item) => item['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList();

      emit(state.copyWith(results: names, isSearching: false));
    } catch (_) {
      emit(state.copyWith(isSearching: false, results: const []));
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    focusNode.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
