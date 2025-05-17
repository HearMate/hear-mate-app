import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:lottie/lottie.dart';

class EchoParseUploadScreen extends StatelessWidget {
  const EchoParseUploadScreen({super.key});

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
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
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
                  padding: EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      if (state.navigationDestinationSelected == 0)
                        Column(
                          children: [
                            Text(
                              langLoc.echoparse_upload_headerUpload,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(height: 48),
                            if (!state.nextFile)
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Image.memory(state.image!),
                                  ),
                                  SizedBox(height: 48),

                                  FilledButton(
                                    style: attentionFilledButtonStyle(
                                      Theme.of(context).colorScheme,
                                    ),
                                    onPressed: () {
                                      context.read<EchoParseBloc>().add(
                                        EchoParseUploadAudiogramFileToServerEvent(),
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        '/echo_parse/upload_done',
                                      );
                                    },
                                    child: Text(
                                      langLoc.echoparse_upload_buttonUpload,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),

                            if (state.nextFile)
                              Column(
                                children: [
                                  Lottie.asset(
                                    "assets/lotties/echoparse_arrow_upload.json",
                                    height: 150,
                                  ),
                                  SizedBox(height: 48),
                                ],
                              ),

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
                            Text(
                              "Zapisane pliki",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(height: 48),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final double itemWidth =
                                    MediaQuery.of(context).size.width > 500
                                        ? 200.0
                                        : 130.0;
                                final double spacing =
                                    MediaQuery.of(context).size.width > 500
                                        ? 40.0
                                        : 20.0;
                                final double bottomNum =
                                    MediaQuery.of(context).size.width > 500
                                        ? 20.0
                                        : 10.0;

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: List.generate(
                                    6,
                                    (index) => SizedBox(
                                      width: itemWidth,
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            "assets/images/saved-file-mock.png",
                                            width: itemWidth,
                                          ),
                                          Positioned(
                                            bottom: bottomNum,
                                            left: 30,
                                            child: Text(
                                              // TODO: Change the code to dynamic names
                                              "File ${index + 1}.csv".length >
                                                      10
                                                  ? "${"File ${index + 1}.csv".substring(0, 7)}..."
                                                  : "File ${index + 1}.csv",
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
