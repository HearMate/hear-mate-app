import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/audiogram_chart.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class HearingTestResultPage extends StatelessWidget {
  const HearingTestResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for audiogram
    final List<FlSpot> leftEarSpots = [
      FlSpot(0, -10), // 125 Hz
      FlSpot(1, -15), // 250 Hz
      FlSpot(2, -20), // 500 Hz
      FlSpot(3, -25), // 1000 Hz
      FlSpot(4, -35), // 2000 Hz
      FlSpot(5, -45), // 4000 Hz
      FlSpot(6, -50), // 8000 Hz
    ];

    final List<FlSpot> rightEarSpots = [
      FlSpot(0, -5), // 125 Hz
      FlSpot(1, -10), // 250 Hz
      FlSpot(2, -15), // 500 Hz
      FlSpot(3, -30), // 1000 Hz
      FlSpot(4, -40), // 2000 Hz
      FlSpot(5, -35), // 4000 Hz
      FlSpot(6, -45), // 8000 Hz
    ];

    final List<String> frequencyLabels = [
      '125',
      '250',
      '500',
      '1k',
      '2k',
      '4k',
      '8k',
    ];

    return Scaffold(
      appBar: HMAppBar(enableBackButton: false),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Your Hearing Test Results',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Below is your audiogram showing hearing thresholds across different frequencies.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                child: AudiogramChart(
                  leftEarSpots: leftEarSpots,
                  rightEarSpots: rightEarSpots,
                  frequencyLabels: frequencyLabels,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'This generated audiogram and hearing test results are not precise and should be interpreted with caution. '
                      'For an accurate diagnosis, please consult a qualified audiologist or healthcare professional.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Save Results',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                child: const Text(
                  'Back to home',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
