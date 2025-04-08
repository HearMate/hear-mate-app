import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EchoParseCollectScreen extends StatelessWidget {
  const EchoParseCollectScreen({super.key});

  

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
                          top: -50,
                          left: 0,
                          child: SvgPicture.asset(
                          'assets/images/top_wave_yellow.svg',
                          height: 400,
                          fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 100,
                          child: SvgPicture.asset(
                          'assets/images/audio-waves-blue-right.svg',
                          height: 250,
                          fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 300,
                          child: Text(
                            "Thank you for using",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: screenFontFamily,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 90,
                          right: 300,
                          child: Text(
                            "EchoParse!",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: screenFontFamily,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 220,
                          left: 350,
                          child: Text(
                            "Choose your way.",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: screenFontFamily,
                            ),
                          ),
                        ),
                        
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/images/sammy-and-table-collect.png',
                            height: 450,
                            fit: BoxFit.contain,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: SvgPicture.asset(
                            'assets/images/audio-chart-collect.svg',
                            height: 400,
                            fit: BoxFit.contain,
                          ),
                        ),

                        
                        Positioned(
                          bottom: 250,
                          left: 120,
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
                              Navigator.pushNamed(context, "/echo_parse/upload");
                            },
                            child: Center(child:
                              Text(
                              "Parse new doc.",
                              style: TextStyle(
                                fontFamily: "Aoboshi One",
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            ) 
                          ),
                        ),

                        Positioned(
                          bottom: 160,
                          left: 120,
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
                              Navigator.pushNamed(context, "/");
                            },
                            child: Center(child:
                              Text(
                              "Go back to modules.",
                              style: TextStyle(
                                fontFamily: "Aoboshi One",
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            ) 
                          ),
                        ),

                        

                        Positioned(
                          bottom: 250,
                          left: 430,
                          child: SvgPicture.asset(
                            'assets/images/arrow-collect.svg',
                            height: 170,
                            fit: BoxFit.contain,
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
