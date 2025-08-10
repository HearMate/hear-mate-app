import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';

enum AlertType { back, missingValues, saved, alreadySaved }

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;

  const CustomAlertDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    switch (type) {
      case AlertType.back:
        return _buildBackAlert(context, l10n, theme);
      case AlertType.missingValues:
        return _buildMissingValuesAlert(context, l10n, theme);
      case AlertType.saved:
        return _buildSavedAlert(context, l10n);
      case AlertType.alreadySaved:
        return _buildAlreadySavedAlert(context, l10n, theme);
    }
  }

  Widget _buildBackAlert(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      title: Row(
        children: [
          Icon(Icons.save_alt_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.hearing_test_result_page_save_results,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.cancel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8),
        child: Text(l10n.hearing_test_result_page_save_results_on_exit_prompt),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.no, style: const TextStyle(color: Colors.red)),
        ),
        const SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.read<HearingTestBloc>().add(HearingTestSaveResult());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            backgroundColor: theme.colorScheme.primary,
          ),
          child: Text(
            l10n.save,
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildMissingValuesAlert(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24.0,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.hearing_test_result_page_save_results_missing_values_title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        l10n.hearing_test_result_page_save_results_missing_values_prompt,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: Colors.red)),
        ),
        const SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.read<HearingTestBloc>().add(HearingTestSaveResult());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            backgroundColor: theme.colorScheme.primary,
          ),
          child: Text(
            "Zapisz",
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildSavedAlert(BuildContext context, AppLocalizations l10n) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            l10n.success,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4),
        child: Text(l10n.hearing_test_result_page_save_results_success_message),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ok),
        ),
      ],
    );
  }

  Widget _buildAlreadySavedAlert(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: theme.colorScheme.primary,
            size: 24.0,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.hearing_test_result_page_already_saved_title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(l10n.hearing_test_result_page_already_saved_message),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Świetnie!"),
        ),
      ],
    );
  }
}
