import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

class EchoParseUploadDoneScreen extends StatelessWidget {
  const EchoParseUploadDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      "Konwersja zakończona",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Audiogram został przetworzony na CSV.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 64),
                    FilledButton(onPressed: () {}, child: Text("Podgląd")),
                    SizedBox(height: 8),
                    FilledButton(
                      style: attentionFilledButtonStyle(
                        Theme.of(context).colorScheme,
                      ),
                      onPressed: () {
                        context.read<EchoParseBloc>().add(
                          EchoParseChooseAudiogramFileEvent(),
                        );
                      },
                      child: Text("Zapisz plik"),
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
                      child: Text("Następny plik"),
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
