import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EchoParseUploadScreen extends StatelessWidget {
  const EchoParseUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenFontFamily = "Aoboshi One";

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
                            "Upload your data.",
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
                          top: 110,
                          left: 190,
                          child: const Text(
                            "Load your audiogram.",
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
                          child: const Text(
                            "Accepted format: png, jpg, jpeg",
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
                              Navigator.pushNamed(context, "/echo_parse/upload_done");
                            },
                            child: Center(child:
                              Text(
                              "Upload.",
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
                          left: 470,
                          child: SvgPicture.asset(
                            'assets/images/load_arrow.svg',
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          bottom: 140,
                          left: (screenSize.width - 200) / 2, // Center horizontally
                          child: const Text(
                          "Saved files.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Aoboshi One",
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          ),
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
