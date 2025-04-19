import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';



class EchoParseUploadScreen extends StatefulWidget {
  const EchoParseUploadScreen({super.key});

  

  @override
  State<EchoParseUploadScreen> createState() => _EchoParseUploadScreenState();
}

class _EchoParseUploadScreenState extends State<EchoParseUploadScreen> {
  var image;

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

                // TODO: Here should appear previev of selected file

                SizedBox(height: 48),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(252, 48),
                    backgroundColor: KConstants.echoParseRed,
                  ),
                  // TODO: Should be abstracted to seperate function
                  onPressed: () async {
                    image = await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  withData: true,
                                  );
                    if (image != null && image.files.single.bytes != null) {
                      final file = image.files.single;
                      Uint8List imageBytes = file.bytes!;
                      String fileName = file.name;

                      print("file: $fileName (${imageBytes.length} bytes)");
                    }
                    else {
                      print("No file selected or file is empty.");
                    }
                  },                  
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
                        6, // TODO: change it to the number of files - Michael
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
                
                // TODO: button should appear only after selecting a file (preferably next to the preview)
                SizedBox(height: 48),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(252, 48),
                    backgroundColor: KConstants.echoParseRed,
                  ),
                  onPressed: () async {
                    await sendImage(image);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> sendImage(image) async {
  if (image != null && image.files.single.bytes != null) {
    final file = image.files.single;
    Uint8List imageBytes = file.bytes!;
    String fileName = file.name;
    
    // Debug print
    print("File to be send: $fileName (${imageBytes.length} bytes)");

    var uri = Uri.parse('https://audiogram-reader-1.onrender.com/upload-image');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: fileName,
      ));

    var response = await request.send();
    print("Status: ${response.statusCode}");
    print(await response.stream.bytesToString());
  }
}
