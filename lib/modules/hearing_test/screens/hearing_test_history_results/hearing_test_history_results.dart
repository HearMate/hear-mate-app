// TODO:
// - show trends what has happened with hearing over time / from last test

// FIXME:
// - preserve the open graph on theme change (probably cubit?)
// - language support
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/alert_dialogs.dart';

class HearingTestHistoryResultsPage extends StatelessWidget {
  const HearingTestHistoryResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              return Center(child: Text('Error: ${state.error}'));
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
                        'Left: ${result.leftEarResults.map((e) => e ?? "-")}\n'
                        'Right: ${result.rightEarResults.map((e) => e ?? "-")}',
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
                        height: 420,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: AudiogramChart(
                          leftEarData: result.leftEarResults,
                          rightEarData: result.rightEarResults,
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
