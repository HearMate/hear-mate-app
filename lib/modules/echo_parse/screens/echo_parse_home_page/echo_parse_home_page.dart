import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/widgets/saved_file_item.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

class EchoParseHomePage extends StatelessWidget {
  const EchoParseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final langLoc = AppLocalizations.of(context)!;
    return BlocBuilder<EchoParseBloc, EchoParseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HMAppBar(
            title: langLoc.echoparse_upload_appbarTitle,

            route: ModalRoute.of(context)?.settings.name ?? "",
          ),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home, semanticLabel: 'Home icon'),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.save),
                label: 'Saved files',
              ),
            ],
            selectedIndex: state.navigationDestinationSelected,
            onDestinationSelected: (destination) {
              context.read<EchoParseBloc>().add(
                EchoParseNavigationDestinationSelected(
                  destination: destination,
                ),
              );
            },
          ),
          body: SizedBox(
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      if (state.navigationDestinationSelected == 0)
                        Column(
                          children: [
                            if (!state.nextFile)
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: state.image != null
                                        ? Image.memory(state.image!)
                                        : SizedBox(), // Or a placeholder
                                  ),
                                  SizedBox(height: 48),

                                  FilledButton(
                                    onPressed: () {
                                      context.read<EchoParseBloc>().add(
                                        EchoParseUploadAudiogramFileToServerEvent(),
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        '/echo_parse/conversion_results',
                                      );
                                    },
                                    child: Text(
                                      langLoc.echoparse_upload_buttonUpload,
                                    ),
                                  ),
                                ],
                              ),

                            if (state.nextFile)
                              Column(
                                children: [
                                  Text(
                                    langLoc.echoparse_upload_headerUpload,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayMedium,
                                  ),
                                  SizedBox(height: 40),
                                  Lottie.asset(
                                    "assets/lotties/echoparse_arrow_upload.json",
                                    height: 150,
                                  ),
                                  SizedBox(height: 32),
                                ],
                              ),
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
                              child: Text(langLoc.echoparse_upload_buttonPick),
                            ),
                          ],
                        ),
                      if (state.navigationDestinationSelected == 1)
                        Column(
                          children: [
                            Lottie.asset(
                              "assets/lotties/saved.json",
                              width: 200,
                            ),
                            Text(
                              langLoc.echoparse_upload_savedFilesHeader,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(height: 48),
                            SavedFileItem(
                              name:
                                  "Krystyna Pawłowicz", // TODO: Implement state management for saved files.
                              savedDate:
                                  "10:30, 18 maja 2025", // TODO: As above.
                            ),
                            SizedBox(height: 16),
                            SavedFileItem(
                              name:
                                  "Jarosław Jakimowicz", // TODO: Implement state management for saved files.
                              savedDate:
                                  "12:48, 12 grudnia 2025", // TODO: As above.
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
