import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';

class BackAlertDialog extends StatelessWidget {
  const BackAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      title: Row(
        children: [
          const Icon(Icons.save_alt_rounded, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.hearing_test_result_page_save_results,
              style: TextStyle(fontWeight: FontWeight.bold),
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
          child: Text(l10n.no, style: TextStyle(color: Colors.red)),
        ),
        SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.read<HearingTestBloc>().add(HearingTestSaveResult());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
            backgroundColor: Colors.blue,
          ),
          child: Text(l10n.save, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class MissingValuesAlertDialog extends StatelessWidget {
  const MissingValuesAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            l10n.hearing_test_result_page_save_results_missing_values_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: .0),
        child: Text(
          l10n.hearing_test_result_page_save_results_missing_values_prompt,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(color: Colors.red)),
        ),
        SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.read<HearingTestBloc>().add(HearingTestSaveResult());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            backgroundColor: Colors.blue,
          ),
          child: Text(
            l10n.hearing_test_result_page_save_results_missing_values_save_anyway,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class SavedDialog extends StatelessWidget {
  const SavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green),
          const SizedBox(width: 8),
          Text(l10n.success, style: TextStyle(fontWeight: FontWeight.bold)),
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
}

class AlreadySavedDialog extends StatelessWidget {
  const AlreadySavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            l10n.hearing_test_result_page_already_saved_title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(l10n.hearing_test_result_page_already_saved_message),
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
}
