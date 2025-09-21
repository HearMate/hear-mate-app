part of '../hearing_test_welcome_page.dart';

class _SavedTab extends StatelessWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<
          HearingTestHistoryResultsCubit,
          HearingTestHistoryResultsState
        >(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.error_message(state.error ?? ''),
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.results.isEmpty) {
              return EmptyState(theme: theme);
            }

            return Column(
              children: [
                ResultsHeader(theme: theme, resultsCount: state.results.length),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: state.results.length,
                    separatorBuilder:
                        (context, index) =>
                            Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, index) {
                      final result = state.results[index];
                      final isSelected = state.selectedIndex == index;

                      return ResultListItem(
                        result: result,
                        isSelected: isSelected,
                        index: index,
                        theme: theme,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
