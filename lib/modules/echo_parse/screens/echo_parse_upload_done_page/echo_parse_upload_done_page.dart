import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EchoParseUploadDoneScreen extends StatelessWidget {
  const EchoParseUploadDoneScreen({super.key});

  Widget buildFileGrid(BuildContext context, List<Map<String, String>> files) {
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = screenSize.width - 100; // Padding on both sides
    final screenFontFamily = "Aoboshi One";
    
    // Calculate how many rows we need
    final rowCount = (files.length / 8).ceil();
    // Limit to 3 rows maximum
    final limitedRowCount = rowCount > 3 ? 3 : rowCount;
    // Calculate how many files to show (max 15)
    final filesToShow = files.length > 15 ? 15 : files.length;
    
    return SizedBox(
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(limitedRowCount, (rowIndex) {
          // Calculate starting and ending indices for this row
          final startIndex = rowIndex * 8;
          final endIndex = (startIndex + 8) > filesToShow ? filesToShow : (startIndex + 8);
          
          // Get files for this row
          final rowFiles = files.sublist(startIndex, endIndex);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...rowFiles.asMap().entries.map((entry) {
                  final file = entry.value;
                  // Add a SizedBox for spacing after each item except the last one
                  return Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Image
                          Image.asset(
                            file['path']!,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          // Text overlaid on the image
                          Positioned(
                            bottom: 10, // Position from bottom of the stack
                            child: Text(
                              file['name']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: screenFontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Add gap after each item except the last one
                      entry.key < rowFiles.length - 1 
                          ? SizedBox(width: 30) // Adjust this value to control the gap size
                          : SizedBox.shrink(),
                    ],
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenFontFamily = "Aoboshi One";

    final sampleFiles = [
      {'name': 'File 1', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 2', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 3', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 4', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 5', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 6', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 7', 'path': 'assets/images/saved-file-mock.png'},
      {'name': 'File 8', 'path': 'assets/images/saved-file-mock.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: screenSize.height - 56, // Ensure it fills the screen height including the top nav bar
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height - 56,
                    child: Stack(
                        children: [
                        Positioned(
                          top: 30,
                          left: 0,
                          child: SvgPicture.asset(
                          'assets/images/top_wave_yellow.svg',
                          height: 400,
                          fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 0,
                          child: SvgPicture.asset(
                          'assets/images/top_right_waves.svg',
                          height: 300,
                          fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 230,
                          child: Text(
                            AppLocalizations.of(context)!.echoparse_upload_done_success_title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: screenFontFamily,
                            ),
                          ),
                        ),
                        // SVG positioned independently
                        Positioned(
                          top: 80,
                          left: (screenSize.width - 920) / 2,
                          child: Container(
                            width: 920,
                            height: 400,
                            decoration: BoxDecoration(
                              color: Color(0xFF21A0AA),
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 170,
                          top: 135,
                          child: Image.asset(
                            'assets/images/audiogram_upload_picture.png',
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 210,
                          top: 140,
                          child: Image.asset(
                            'assets/images/audiogram-img.png',
                            height: 270,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 190,
                          child: Text(
                            AppLocalizations.of(context)!.echoparse_upload_done_loaded_title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: "Aoboshi One",
                              fontSize: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 165,
                          left: 190,
                          child: Text(
                            AppLocalizations.of(context)!.echoparse_upload_done_processed_title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: "Aoboshi One",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 330,
                          left: 220,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 25,
                              ),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            onPressed: () {
                              context.read<EchoParseBloc>().add(EchoParseSaveProcessedCsvEvent());
                              Navigator.pushNamed(context, "/echo_parse/collection");
                            },
                            child: Center(child:
                              Text(
                              AppLocalizations.of(context)!.echoparse_upload_done_download_title,
                              style: TextStyle(
                                fontFamily: "Aoboshi One",
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            ) 
                          ),
                        ),
                        Positioned(
                          bottom: 330,
                          left: 490,
                          child: SvgPicture.asset(
                            'assets/images/arrow-load-audio-done.svg',
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          bottom: 140,
                          left: (screenSize.width - 200) / 2, // Center horizontally
                          child: Text(
                          AppLocalizations.of(context)!.echoparse_upload_done_saved_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Aoboshi One",
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          ),
                        ),

                        Positioned(
                          bottom: 20,
                          left: 50, // Add padding from left
                          child: buildFileGrid(context, sampleFiles),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
