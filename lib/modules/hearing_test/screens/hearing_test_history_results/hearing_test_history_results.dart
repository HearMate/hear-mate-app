import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/alert_dialogs.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_utils.dart';

// TODO:
// - show trends what has happened with hearing over time / from last test

List<String> remapDbValues(List<double?> values, List<double?>? maskedValues) {
  if (values.length != HearingTestConstants.TEST_FREQUENCIES.length) {
    return [];
  }

  final mapping = getFrequencyMapping(values);
  final List<String> mapped = [];

  for (final entry in mapping) {
    final int index = entry.key;
    final double? unmaskedValue = values[index];
    final double? maskedValue =
        maskedValues != null ? maskedValues[index] : null;

    final bool isMasked = maskedValue != null;
    final double? dbValue = isMasked ? maskedValue : unmaskedValue;

    if (dbValue != null) {
      final valueStr = dbValue.toStringAsFixed(1);
      mapped.add(valueStr);
    } else {
      mapped.add('-');
    }
  }

  return mapped;
}

class HearingTestHistoryResultsPage extends StatelessWidget {
  const HearingTestHistoryResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => HearingTestHistoryResultsCubit(),
      child: Scaffold(
        appBar: HMAppBar(
          title: AppLocalizations.of(context)!.hearing_test_result_page_title,
          route: ModalRoute.of(context)?.settings.name ?? "",
        ),
        body: BlocBuilder<
          HearingTestHistoryResultsCubit,
          HearingTestHistoryResultsState
        >(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text(l10n.error_message(state.error ?? '')));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                final isSelected = state.selectedIndex == index;

                return Column(
                  children: [
                    ListTile(
                      title: Text(result.dateLabel),
                      subtitle: Text(
                        l10n.hearing_test_history_page_result_info(
                          remapDbValues(
                            result.leftEarResults,
                            result.leftEarResultsMasked,
                          ),
                          remapDbValues(
                            result.rightEarResults,
                            result.rightEarResultsMasked,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => const DeleteAlertDialog(),
                          );
                          if (confirm == true) {
                            context
                                .read<HearingTestHistoryResultsCubit>()
                                .deleteResult(index);
                          }
                        },
                      ),
                      onTap: () {
                        context
                            .read<HearingTestHistoryResultsCubit>()
                            .selectIndex(index);
                      },
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: AudiogramChart(
                          leftEarData: result.leftEarResults,
                          rightEarData: result.rightEarResults,
                          leftEarMaskedData:
                              result.leftEarResultsMasked.every(
                                    (elem) => elem == null,
                                  )
                                  ? null
                                  : result.leftEarResultsMasked,
                          rightEarMaskedData:
                              result.rightEarResultsMasked.every(
                                    (elem) => elem == null,
                                  )
                                  ? null
                                  : result.rightEarResultsMasked,
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
