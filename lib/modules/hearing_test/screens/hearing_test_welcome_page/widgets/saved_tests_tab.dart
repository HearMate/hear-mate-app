part of '../hearing_test_welcome_page.dart';

class _SavedTestsTab extends StatelessWidget {
  const _SavedTestsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
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
                      result.leftEarResults.map((e) => e ?? "-"),
                      result.rightEarResults.map((e) => e ?? "-"),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final cubit =
                          context.read<HearingTestHistoryResultsCubit>();
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => const DeleteAlertDialog(),
                      );
                      if (confirm == true) {
                        cubit.deleteResult(index);
                      }
                    },
                  ),
                  onTap: () {
                    context.read<HearingTestHistoryResultsCubit>().selectIndex(
                      index,
                    );
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
    );
  }
}
