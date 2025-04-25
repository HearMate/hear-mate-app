import 'package:flutter/material.dart';
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
                  'HearMate to aplikacja wspierająca wstępną analizę słuchu, umożliwiająca uzyskanie pierwszych wyników i ocenę, '
                  'czy istnieje potrzeba konsultacji ze specjalistą. Jej celem jest zapobieganie sytuacjom, w których niedosłuch zostaje wykryty zbyt późno, '
                  'uniemożliwiając skuteczne leczenie lub pogarszając komfort życia. '
                  'Aplikacja wykorzystuje mechanizmy sztucznej inteligencji do analizy audiogramów oraz wspomagania procesu wstępnej diagnostyki.',
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
                  'EchoParse to dedykowany moduł odpowiedzialny za konwersję tradycyjnych audiogramów – zarówno w formie papierowej, jak i graficznej – '
                  'do postaci plików CSV, przystosowanych do dalszej analizy danych. '
                  'Moduł ten wykorzystuje rozwiązania oparte na sztucznej inteligencji, umożliwiające automatyczne rozpoznawanie i przetwarzanie wyników badań audiometrycznych. '
                  'EchoParse powstał we współpracy z Instytutem Fizjologii i Patologii Słuchu, stanowiąc istotne wsparcie w cyfryzacji i analizie wyników diagnostycznych.',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Zespół projektowy:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Prof. Andrzej Czyżewski',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• dr Dominika Zagórska',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '• mgr Marina Galanina',
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
                child: Image.asset('assets/images/pg_logo.png', height: 150),
              ),
              const SizedBox(height: 32),
              Center(
                child: Image.asset('assets/images/ifips_logo.png', height: 150),
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
