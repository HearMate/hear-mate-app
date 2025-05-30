import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

class EchoParseWelcomeScreen extends StatelessWidget {
  const EchoParseWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(
        title: AppLocalizations.of(context)!.echoparse_welcome_appbar_title,
        route: ModalRoute.of(context)?.settings.name ?? "",
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Lottie.asset(
                    "assets/lotties/echoparse_welcome.json",
                    height: MediaQuery.of(context).size.width > 500 ? 150 : 100,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.echoparse_welcome_header,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.width > 500 ? 64.0 : 48.0,
                  ),
                ),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width > 500
                          ? 500
                          : MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.echoparse_welcome_heading,
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppLocalizations.of(context)!.echoparse_welcome_body,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.width > 500 ? 0 : 50,
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: FilledButton(
                          style: attentionFilledButtonStyle(
                            Theme.of(context).colorScheme,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/echo_parse/home');
                          },
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.echoparse_welcome_mainButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
