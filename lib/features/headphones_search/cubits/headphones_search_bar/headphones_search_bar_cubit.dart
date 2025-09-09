import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hear_mate_app/features/headphones_search_bar/repositories/headphones_searcher_repository.dart';

part 'headphones_search_bar_state.dart';

class HeadphonesSearchBarCubit extends Cubit<HeadphonesSearchBarState> {
  final HeadphonesSearcherRepository repository =
      HeadphonesSearcherRepository();
  final TextEditingController controller = TextEditingController();

  Timer? _debounce;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  HeadphonesSearchBarCubit() : super(const HeadphonesSearchBarState()) {
    controller.addListener(() {
      final query = controller.text;
      if (query != state.query) {
        updateQuery(query);
      }
    });
  }

  void updateQuery(String query) {
    emit(state.copyWith(query: query, isSearching: true, result: ''));

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      _performSearch(query);
    });
  }

  void clearQuery() {
    controller.clear();
    emit(state.copyWith(query: '', result: '', isSearching: false));
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(result: '', isSearching: false));
      return;
    }

    try {
      final headphones = await repository.searchHeadphones(keyword: query);

      emit(
        state.copyWith(result: headphones.extractedModel, isSearching: false),
      );
    } catch (_) {
      emit(state.copyWith(isSearching: false, result: ''));
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
