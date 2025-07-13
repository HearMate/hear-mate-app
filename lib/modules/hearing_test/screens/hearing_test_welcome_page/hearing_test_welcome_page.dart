import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';

// FIXME:
// - language support

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(
        title: AppLocalizations.of(context)!.hearing_test_welcome_page_title,
        route: ModalRoute.of(context)?.settings.name ?? "",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                AppLocalizations.of(context)!.hearing_test_welcome_page_welcome,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.hearing_test_welcome_page_description,
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                context.read<HearingTestBloc>().add(HearingTestStartTest());
                Navigator.pushNamed(context, '/hearing_test/start');
              },
              child: Text(
                AppLocalizations.of(context)!.hearing_test_welcome_page_start,
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hearing_test/history_results');
              },
              child: Text(
                'Results',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
