import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(title: ""),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/lotties/welcome.json", height: 100),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                child: Text(
                  'HearMate',
                  style: KConstants.headerStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.hearmate_homepage_button_helper,
                style: KConstants.helperStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Audio Test Module button
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: Size(252, 48)),
                onPressed: () {
                  Navigator.pushNamed(context, '/hearing_test/welcome');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.hearmate_homepage_button_audioTest,
                    style: KConstants.bigButtonStyle,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Echo Parse button
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: Size(252, 48)),
                onPressed: () {
                  Navigator.pushNamed(context, '/echo_parse/welcome');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Echo Parse', style: KConstants.bigButtonStyle),
                ),
              ),

              const SizedBox(height: 40),

              // Placeholder for future modules
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.hearmate_homepage_button_moreModules,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
