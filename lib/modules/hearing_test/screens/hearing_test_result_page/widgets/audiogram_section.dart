import 'package:flutter/material.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';

class AudiogramSection extends StatelessWidget {
  final ThemeData theme;
  final List<double?> leftEarData;
  final List<double?> rightEarData;
  final List<double?>? leftEarMaskedData;
  final List<double?>? rightEarMaskedData;

  const AudiogramSection({
    super.key,
    required this.theme,
    required this.leftEarData,
    required this.rightEarData,
    this.leftEarMaskedData,
    this.rightEarMaskedData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),

        Container(
          margin: EdgeInsets.only(bottom: 32.0, top: 12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 32,
                  ),
                  child: AudiogramChart(
                    leftEarData: leftEarData,
                    rightEarData: rightEarData,
                    leftEarMaskedData: leftEarMaskedData,
                    rightEarMaskedData: rightEarMaskedData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
