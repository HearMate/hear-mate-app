import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.3;

    return Scaffold(
      appBar: HMAppBar(enableBackButton: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to HearMate!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please select a module to continue:',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Audio Test Module button
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/hearing_test/welcome');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Audio Test Module',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Echo Parse button
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/echo_parse/welcome');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Echo Parse', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 15),

            // Placeholder for future modules
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'More Modules Coming Soon...',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
