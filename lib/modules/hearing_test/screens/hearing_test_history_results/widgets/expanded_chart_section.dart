import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpandedChartSection extends StatelessWidget {
  final HearingTestResult result;
  final ThemeData theme;

  const ExpandedChartSection({
    super.key,
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.02),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.hearing_test_result_history_page_audiogram_name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: AudiogramChart(
              hearingLossLeft: result.hearingLossLeft,
              hearingLossRight: result.hearingLossRight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              result.audiogramDescription,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
