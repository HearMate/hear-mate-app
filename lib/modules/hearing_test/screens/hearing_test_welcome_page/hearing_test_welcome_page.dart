import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(
        title: "HearMate Project",
        route: ModalRoute.of(context)?.settings.name ?? "",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to Hearing Test',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'This module will test your hearing ability across different frequencies.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hearing_test/start');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Start Test',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
