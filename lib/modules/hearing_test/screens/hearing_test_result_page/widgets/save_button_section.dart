import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import '../alert_dialogs.dart';

class SaveButtonSection extends StatelessWidget {
  final ThemeData theme;

  const SaveButtonSection({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: BlocBuilder<HearingTestBloc, HearingTestState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed: () => _handleSaveButtonPressed(context, state),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        state.resultSaved
                            ? Colors.green.shade600
                            : theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        state.resultSaved ? Icons.check : Icons.save,
                        size: 24,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        state.resultSaved
                            ? "Wyniki zapisane"
                            : loc.hearing_test_result_page_save_results,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Zapisz wyniki aby móc je później przeglądać",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleSaveButtonPressed(BuildContext context, HearingTestState state) {
    if (state.resultSaved) {
      showDialog(
        context: context,
        builder:
            (dialogContext) => BlocProvider.value(
              value: context.read<HearingTestBloc>(),
              child: CustomAlertDialog(type: AlertType.alreadySaved),
            ),
      );
    } else if (state.results.hasMissingValues()) {
      showDialog(
        context: context,
        builder:
            (dialogContext) => BlocProvider.value(
              value: context.read<HearingTestBloc>(),
              child: CustomAlertDialog(type: AlertType.missingValues),
            ),
      );
    } else {
      context.read<HearingTestBloc>().add(HearingTestSaveResult());
      showDialog(
        context: context,
        builder:
            (dialogContext) => BlocProvider.value(
              value: context.read<HearingTestBloc>(),
              child: CustomAlertDialog(type: AlertType.saved),
            ),
      );
    }
  }
}
