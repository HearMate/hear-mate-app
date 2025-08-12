import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 10),

        // Instructions Section
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.03),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                "Twój audiogram",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Instruction Text
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            loc.hearing_test_result_page_instruction,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Audiogram Chart Section
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
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Wykres słuchu",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
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
