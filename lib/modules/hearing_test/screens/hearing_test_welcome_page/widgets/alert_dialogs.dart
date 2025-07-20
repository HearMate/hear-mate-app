import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      title: Row(
        children: [
          const Icon(Icons.delete_forever_rounded, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.hearing_test_delete_alert_title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4),
        child: Text(
          l10n.hearing_test_delete_alert_message,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        const SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
