part of '../hearing_test_welcome_page.dart';

List<String> remapDbValues(List<double?> values, List<double?>? maskedValues) {
  if (values.length != hearing_test_constants.TEST_FREQUENCIES.length) {
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

class _SavedTab extends StatelessWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => HearingTestHistoryResultsCubit(),
      child: Scaffold(
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
                return _EmptyState(theme: theme);
              }

              return Column(
                children: [
                  // Hero Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.primaryColor.withValues(alpha: 0.08),
                          theme.primaryColor.withValues(alpha: 0.02),
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history,
                            size: 32,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Zapisane wyniki",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${state.results.length} ${state.results.length == 1 ? 'wynik' : 'wyników'} w historii",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Results List
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: state.results.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final result = state.results[index];
                        final isSelected = state.selectedIndex == index;

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.assessment,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                result.dateLabel,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
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
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? theme.primaryColor.withValues(
                                                alpha: 0.1,
                                              )
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      isSelected
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color:
                                          isSelected
                                              ? theme.primaryColor
                                              : Colors.grey.shade400,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (_) => const DeleteAlertDialog(),
                                      );
                                      if (confirm == true) {
                                        if (context.mounted) {
                                          context
                                              .read<
                                                HearingTestHistoryResultsCubit
                                              >()
                                              .deleteResult(index);
                                        }
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red.shade600,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                context
                                    .read<HearingTestHistoryResultsCubit>()
                                    .selectIndex(index);
                              },
                            ),

                            // Expanded chart section
                            if (isSelected) ...[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.02,
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: theme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: theme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.show_chart,
                                            color: theme.primaryColor,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Audiogram",
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: theme.primaryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: 12,
                                      ),
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
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 48,
                color: theme.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Brak zapisanych wyników",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Wykonaj pierwszy test słuchu, aby zobaczyć tutaj wyniki",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
