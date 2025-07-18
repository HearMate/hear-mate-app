import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_result.dart';
import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

part 'hearing_test_history_results_state.dart';

class HearingTestHistoryResultsCubit
    extends Cubit<HearingTestHistoryResultsState> {
  HearingTestHistoryResultsCubit()
    : super(const HearingTestHistoryResultsState()) {
    loadResults();
  }

  Future<void> loadResults() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final dir = await getApplicationSupportDirectory();
      final resultsDir = Directory('${dir.path}/HearingTest');
      if (!await resultsDir.exists()) {
        emit(state.copyWith(isLoading: false, results: []));
        return;
      }

      final files = resultsDir.listSync().whereType<File>().toList();
      final results = <HearingTestResult>[];

      for (final file in files) {
        final content = await file.readAsString();
        final json = jsonDecode(content);
        results.add(HearingTestResult.fromJson(file.path, json));
      }

      emit(state.copyWith(isLoading: false, results: results));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void selectIndex(int index) {
    emit(
      state.copyWith(
        selectedIndex: state.selectedIndex == index ? null : index,
      ),
    );
  }

  Future<void> deleteResult(int index) async {
    final result = state.results[index];
    final file = File(result.filePath);
    await file.delete();

    final updatedResults = List<HearingTestResult>.from(state.results)
      ..removeAt(index);
    emit(state.copyWith(results: updatedResults, selectedIndex: null));
  }
}
