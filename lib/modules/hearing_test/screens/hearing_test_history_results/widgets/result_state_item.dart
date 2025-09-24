import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/widgets/delete_alert_dialog.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/widgets/expanded_chart_section.dart';

class ResultListItem extends StatelessWidget {
  final HearingTestResult result;
  final bool isSelected;
  final int index;
  final ThemeData theme;

  const ResultListItem({
    super.key,
    required this.result,
    required this.isSelected,
    required this.index,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.assessment,
              color: theme.colorScheme.primary,
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
                result.hearingLossLeft
                    .map((e) => e == null ? '-' : e.toString())
                    .toList(),
                result.hearingLossRight
                    .map((e) => e == null ? '-' : e.toString())
                    .toList(),
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
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isSelected ? Icons.expand_less : Icons.expand_more,
                  color:
                      isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _deleteResult(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
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
            context.read<HearingTestHistoryResultsCubit>().selectIndex(index);
          },
        ),

        // Expanded chart section
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child:
              isSelected
                  ? ExpandedChartSection(result: result, theme: theme)
                  : const SizedBox.shrink(),
        ),
        //if (isSelected) ExpandedChartSection(result: result, theme: theme),
      ],
    );
  }

  Future<void> _deleteResult(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteAlertDialog(),
    );
    if (confirm == true && context.mounted) {
      context.read<HearingTestHistoryResultsCubit>().deleteResult(index);
    }
  }
}
