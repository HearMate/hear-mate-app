import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/hearing_test/models/hearing_loss.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';

class AudiogramSection extends StatelessWidget {
  final ThemeData theme;
  final List<HearingLoss?> leftEarData;
  final List<HearingLoss?> rightEarData;

  const AudiogramSection({
    super.key,
    required this.theme,
    required this.leftEarData,
    required this.rightEarData,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Masking info for explanation
    final bool isLeftMasking = leftEarData.any((e) => e?.isMasked ?? false);
    final bool isRightMasking = rightEarData.any((e) => e?.isMasked ?? false);

    return Column(
      children: [
        // Audiogram Chart Section
        Container(
          margin: const EdgeInsets.only(bottom: 32.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
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
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 32),
                  child: AudiogramChart(
                    hearingLossLeft: leftEarData,
                    hearingLossRight: rightEarData,
                  ),
                ),
              ),
              if (isLeftMasking || isRightMasking)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                  child: Text(
                    loc.hearing_test_audiogram_chart_masking_explanation,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
