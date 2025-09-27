import 'package:flutter/material.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';

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
