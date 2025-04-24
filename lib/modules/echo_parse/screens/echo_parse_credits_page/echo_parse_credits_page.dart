import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EchoParseCreditsPage extends StatelessWidget {
  const EchoParseCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(title: AppLocalizations.of(context)!.echoparse_welcome_creditsButton),
      body: SingleChildScrollView(
        child: Center(
        ),
      ),
    );
  }
}