import 'package:flutter/material.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:lottie/lottie.dart';

class EchoParseWelcomeScreen extends StatelessWidget {
  const EchoParseWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(title: "EchoParse"),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Lottie.asset(
                    "assets/lotties/echoparse_welcome.json",
                    height: MediaQuery.of(context).size.width > 500 ? 150 : 100,
                  ),
                ),
                Text(
                  "EchoParse",
                  style: KConstants.headerStyle.copyWith(
                  fontSize: MediaQuery.of(context).size.width > 500 ? 64.0 : 48.0,
                ),
                ),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width > 500
                          ? 500
                          : MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Text(
                        "Your audiogram now in CSV!",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Convert your audiogram photos and files into easy to use, modern CSV documents.",
                          style: KConstants.paragraphStyle,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500 ? 0 : 50,
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFFF94F46),
                            minimumSize: Size(252, 48)
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/echo_parse/upload');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Let's go!",
                              style: KConstants.bigButtonStyle.copyWith(
                                color: Colors.white
                              ),
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
      ),
    );
  }
}
