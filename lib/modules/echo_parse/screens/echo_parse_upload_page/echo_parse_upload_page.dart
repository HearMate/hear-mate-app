import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class EchoParseUploadScreen extends StatefulWidget {
  const EchoParseUploadScreen({super.key});

  

  @override
  State<EchoParseUploadScreen> createState() => _EchoParseUploadScreenState();
}

class _EchoParseUploadScreenState extends State<EchoParseUploadScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(title: ""),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(48.0),
            child: Column(
              children: [
                SizedBox(height: 24),
                Text(
                  MediaQuery.of(context).size.width > 800
                      ? AppLocalizations.of(context)!.echoparse_upload_headerUpload
                      : AppLocalizations.of(context)!.echoparse_upload_headerUpload,
                  textAlign: TextAlign.center,
                  style: KConstants.headerStyle.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.width > 500 ? 64.0 : 48.0,
                  ),
                ),
                SizedBox(height: 48),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(252, 48),
                    backgroundColor: KConstants.echoParseRed,
                  ),
                  onPressed: () {
                    // TODO: Upload file logic
                  },
                  
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.echoparse_upload_buttonUpload,
                      style: KConstants.hugeButtonStyle.copyWith(
                        color: Colors.white,
                        fontSize:
                            MediaQuery.of(context).size.width > 500
                                ? 32.0
                                : 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  AppLocalizations.of(context)!.echoparse_upload_buttonHelper,
                  style: KConstants.helperStyle,
                ),
                SizedBox(height: 32),
                Lottie.asset(
                  "assets/lotties/echoparse_arrow_upload.json",
                  height: 150,
                ),
                SizedBox(height: 32),
                ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, value, child) {
                    return !value
                        ? SvgPicture.asset("assets/images/audio-no-shadow.svg")
                        : SvgPicture.asset(
                          "assets/images/audio-no-shadow-light.svg",
                        );
                  },
                ),
                SizedBox(height: 64),
                Text(
                  AppLocalizations.of(context)!.echoparse_upload_savedFilesHeader,
                  textAlign: TextAlign.center,
                  style: KConstants.headerStyle.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.width > 500 ? 64.0 : 48.0,
                  ),
                ),
                SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double itemWidth =
                        MediaQuery.of(context).size.width > 500 ? 200.0 : 130.0;
                    final double spacing =
                        MediaQuery.of(context).size.width > 500 ? 40.0 : 20.0;
                    final double bottomNum =
                        MediaQuery.of(context).size.width > 500 ? 20.0 : 10.0;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(
                        8, // TODO: change it to the number of files
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
                                child: Text( // TODO: Change the code to dynamic names
                                  "File ${index + 1}.csv".length > 10
                                    ? "${"File ${index + 1}.csv".substring(0, 7)}..."
                                    : "File ${index + 1}.csv",
                                  maxLines: 1,
                                  style: KConstants.paragraphStyle,
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
      ),
    );
  }
}
