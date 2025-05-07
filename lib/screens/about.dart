import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(title: loc.menu_about),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assets/lotties/welcome.json", height: 100),
              Text(
                "HearMate",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loc.about_hearmate,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Lottie.asset(
                  "assets/lotties/echoparse_welcome.json",
                  height: MediaQuery.of(context).size.width > 500 ? 150 : 100,
                ),
              ),
              Text(
                "EchoParse",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loc.about_echoparse,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                loc.about_projectTeam,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• prof. dr hab. inż. Andrzej Czyżewski',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• mgr Dominika Zagórska',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• mgr inż. Marina Galanina',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• Michał Tarnowski',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• Wojciech Trapkowski',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• Stanisław Grochowski',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• Dawid Glazik',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, value, child) {
                    return value
                        ? Image.asset(
                          'assets/images/pg_logo_darkmode.png',
                          height: 150,
                        )
                        : Image.asset('assets/images/pg_logo.png', height: 150);
                  },
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, value, child) {
                    return value
                        ? Image.asset(
                          'assets/images/ifips_logo_darkmode.png',
                          height: 150,
                        )
                        : Image.asset(
                          'assets/images/ifips_logo.png',
                          height: 150,
                        );
                  },
                ),
              ),
              const SizedBox(height: 48),

              Text(
                '© ${DateTime.now().year} HearMate – Politechnika Gdańska',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
