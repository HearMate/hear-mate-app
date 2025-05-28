import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

class EchoParseConversionResults extends StatelessWidget {
  const EchoParseConversionResults({super.key});

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HMAppBar(
        title: "",
        route: ModalRoute.of(context)?.settings.name ?? "",
      ),
      body: BlocBuilder<EchoParseBloc, EchoParseState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: Column(
                  children: [
                    Lottie.asset(
                      "assets/lotties/download_success.json",
                      height: 100,
                      repeat: false,
                    ),
                    SizedBox(height: 32),
                    Text(
                      langLoc.echo_parse_conversion_results_title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 12),
                    Text(
                      langLoc.echo_parse_conversion_results_heading,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 64),
                    FilledButton(
                      style: defaultFilledButtonStyle(
                        Theme.of(context).colorScheme,
                      ),
                      onPressed:
                          () {}, // TODO: Implement logic for file preview
                      child: Text(
                        langLoc.echo_parse_conversion_results_preview,
                      ),
                    ),
                    SizedBox(height: 8),
                    FilledButton(
                      style: attentionFilledButtonStyle(
                        Theme.of(context).colorScheme,
                      ),
                      onPressed: () {}, // TODO: Implement logic for file save
                      child: Text(
                        langLoc.echo_parse_conversion_results_save_file,
                      ),
                    ),
                    SizedBox(height: 64),
                    FilledButton(
                      style: attentionFilledButtonStyle(
                        Theme.of(context).colorScheme,
                      ),
                      onPressed: () {
                        context.read<EchoParseBloc>().add(
                          EchoParsePrepareForTheNewFileUpload(),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        langLoc.echo_parse_conversion_results_next_file,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
