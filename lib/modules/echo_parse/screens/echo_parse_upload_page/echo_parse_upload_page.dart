import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Scaffold(
      appBar: HMAppBar(
        title: AppLocalizations.of(context)!.echoparse_upload_appbarTitle,

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
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.echoparse_upload_headerUpload,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: 48),
                    if (state.image != null)
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.memory(state.image!),
                          ),
                          SizedBox(height: 48),

                          FilledButton(
                            style: Theme.of(context).filledButtonTheme.style,
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
                              AppLocalizations.of(
                                context,
                              )!.echoparse_upload_buttonUpload,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                    if (state.image == null)
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
                      style: Theme.of(context).filledButtonTheme.style,
                      onPressed: () {
                        context.read<EchoParseBloc>().add(
                          EchoParseChooseAudiogramFileEvent(),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.echoparse_upload_buttonPick,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
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
                                      "File ${index + 1}.csv".length > 10
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
              ),
            ),
          );
        },
      ),
    );
  }
}
