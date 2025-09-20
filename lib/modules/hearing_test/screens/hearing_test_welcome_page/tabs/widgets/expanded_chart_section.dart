import 'package:flutter/material.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';

class ExpandedChartSection extends StatelessWidget {
  final dynamic result; // Używamy dynamic ponieważ nie znamy dokładnego typu
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
                  "Audiogram",
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
              leftEarData: result.leftEarResults,
              rightEarData: result.rightEarResults,
              leftEarMaskedData:
                  result.leftEarResultsMasked.every((elem) => elem == null)
                      ? null
                      : result.leftEarResultsMasked,
              rightEarMaskedData:
                  result.rightEarResultsMasked.every((elem) => elem == null)
                      ? null
                      : result.rightEarResultsMasked,
            ),
          ),
        ],
      ),
    );
  }
}
