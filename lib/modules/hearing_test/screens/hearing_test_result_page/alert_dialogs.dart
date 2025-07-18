import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';

//FIXME:
// - language support

class BackAlertDialog extends StatelessWidget {
  const BackAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
      title: Row(
        children: [
          const Icon(Icons.save_alt_rounded, color: Colors.blue),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Save Results',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 8),
        child: Text(
          'Do you want to save your hearing test results before exiting?',
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('No', style: TextStyle(color: Colors.red)),
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
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class MissingValuesAlertDialog extends StatelessWidget {
  const MissingValuesAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            'Incomplete Test',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: .0),
        child: Text(
          'Some test results are missing. Are you sure you want to save anyway?',
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        SizedBox(width: 4.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<HearingTestBloc>().add(HearingTestSaveResult());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Save Anyway',
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
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.check_circle_rounded, color: Colors.green),
          SizedBox(width: 8),
          Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 4),
        child: Text('Your results have been successfully saved.'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

class AlreadySavedDialog extends StatelessWidget {
  const AlreadySavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.info_outline_rounded, color: Colors.blue),
          SizedBox(width: 8),
          Text('Already Saved', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('You’ve already saved these results.'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
