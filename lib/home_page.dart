import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
        top: 0,
        left: 15,
        child: SvgPicture.asset(
          'assets/images/top_left.svg',
          height: 220,
        ),
          ),
          Positioned(
        bottom: 0,
        right: 15,
        child: SvgPicture.asset(
          'assets/images/bottom_right.svg',
          height: 200,
        ),
          ),
          Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
          flex: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
              'assets/images/logo.svg',
              height: 215,
                ),
              ],
            ),
              ),
            ],
          ),
            ),
            Expanded(
          flex: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/hearing_test/welcome');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFFFF3131),
            ),
            child: const Text(
              'Start Module',
              style: TextStyle(fontSize: 16),
            ),
              ),
              const SizedBox(height: 10),
              // Placeholder for future modules
              const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'More Modules Coming Soon...',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
              ),
            ],
          ),
            ),
          ],
        ),
          ),
        ],
      ),
    );
  }
}
