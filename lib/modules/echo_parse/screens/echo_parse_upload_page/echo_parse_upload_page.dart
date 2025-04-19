import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EchoParseUploadScreen extends StatefulWidget {
  const EchoParseUploadScreen({super.key});

  @override
  State<EchoParseUploadScreen> createState() => _EchoParseUploadScreenState();
}

class _EchoParseUploadScreenState extends State<EchoParseUploadScreen> {
  var image;
  var fileName;
  bool imageLoaded = false;

  void sendImage() async {
    if (image != null) {
      var uri = Uri.parse(
        'https://audiogram-reader-1.onrender.com/upload-image',
      );

      var request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes('image', image, filename: fileName),
        );

      var response = await request.send();
      print("Status: ${response.statusCode}");
      print(await response.stream.bytesToString());
    }
  }

  void pickImage() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        image = result.files.single.bytes!;
        imageLoaded = true;
        fileName = result.files.single.name;
      });

      print("file: ${result.files.single.name} (${image.length} bytes)");
    } else {
      print("No file selected or file is empty.");
    }
  }

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
                SizedBox(height: 14),
                Text(
                  MediaQuery.of(context).size.width > 800
                      ? AppLocalizations.of(
                        context,
                      )!.echoparse_upload_headerUpload
                      : AppLocalizations.of(
                        context,
                      )!.echoparse_upload_headerUpload,
                  textAlign: TextAlign.center,
                  style: KConstants.headerStyle.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.width > 500 ? 64.0 : 48.0,
                  ),
                ),

                if (imageLoaded) ...[
                  Column(
                    children: [
                      SizedBox(height: 48),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
                        child: Image.memory(image),
                      ),
                      SizedBox(height: 48),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: Size(252, 48),
                          backgroundColor: KConstants.echoParseRed,
                        ),
                        onPressed: sendImage,

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.echoparse_upload_buttonUpload,
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
                    ],
                  ).animate().fadeIn(duration: 200.ms).scale(),
                ],

                SizedBox(height: 48),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(252, 48),
                    backgroundColor: KConstants.echoParseRed,
                  ),
                  onPressed: pickImage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.echoparse_upload_buttonPick,
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
                Text(
                  AppLocalizations.of(
                    context,
                  )!.echoparse_upload_savedFilesHeader,
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
                        8, // TODO: change it to the number of files - Michael
                        //  imo it can also have a hard limit of 6 most recent for estetics - Stanislał
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
