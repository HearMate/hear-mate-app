import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EchoParseWelcomeScreen extends StatelessWidget {
  const EchoParseWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                          top: 20,
                          left: 220,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/EchoParse_logo.png',
                                height: 70,
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'by ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/hearmate_logo.png',
                                      height: 75,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: SvgPicture.asset(
                            'assets/images/chart_visual.svg',
                            height: 330,
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
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/images/sammy_and_table.png',
                            height: 450,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Updated text block
                        Positioned(
                          bottom: 330,
                          left: 450,
                          child: const Text(
                            "Your audiogram\nnow in CSV.",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: "Aoboshi One",
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // SVG positioned independently
                        Positioned(
                          bottom: 230,
                          left: 270,
                          child: SvgPicture.asset(
                            'assets/images/welcome_page_arrow.svg',
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          bottom: 150,
                          left: 140,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/echo_parse/upload");
                            },
                            child: const Text(
                              "Let's go.",
                              style: TextStyle(
                                fontFamily: "Aoboshi One",
                                color: Colors.white,
                                fontSize: 24,
                              ),
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
