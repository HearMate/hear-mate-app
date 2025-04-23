import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/data/constants.dart';
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
                      style: KConstants.headerStyle,
                    ),
                    SizedBox(height: 48),
                    if (state.image != null)
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.memory(state.image!),
                          ),
                          SizedBox(height: 48),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: Size(252, 48),
                              backgroundColor: KConstants.echoParseRed,
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
                              AppLocalizations.of(
                                context,
                              )!.echoparse_upload_buttonUpload,
                              style: KConstants.hugeButtonStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 48),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(252, 48),
                        backgroundColor: KConstants.echoParseRed,
                      ),
                      onPressed: () {
                        context.read<EchoParseBloc>().add(
                          EchoParseChooseAudiogramFileEvent(),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.echoparse_upload_buttonPick,
                        style: KConstants.hugeButtonStyle.copyWith(
                          color: Colors.white,
                        ),
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
