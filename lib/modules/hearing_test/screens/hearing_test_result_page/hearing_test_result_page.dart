import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/data/constants.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/audiogram_chart.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hm_theme/hm_theme.dart';

class HearingTestResultPage extends StatelessWidget {
  HearingTestResultPage({super.key});
  final List<String> frequencyLabels = [
    '1k',
    '2k',
    '4k',
    '8k',
    '500',
    '250',
    '125',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
        final results = state.results;
        final leftEarResults = results.take(frequencyLabels.length).toList();
        final rightEarResults =
            results.length > frequencyLabels.length
                ? results.sublist(frequencyLabels.length)
                : [];

        return Scaffold(
          appBar: HMAppBar(
            title: "HearMate Project",
            route: ModalRoute.of(context)?.settings.name ?? "",
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Your Hearing Test Results',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
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
                      frequencyLabels: frequencyLabels,
                      leftEarSpots: List.generate(
                        leftEarResults.length,
                        (i) => FlSpot(i.toDouble(), leftEarResults[i]),
                      ),
                      rightEarSpots: List.generate(
                        rightEarResults.length,
                        (i) => FlSpot(i.toDouble(), rightEarResults[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<HMThemeBloc, HMThemeState>(
                    builder: (context, themeState) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              themeState.isDarkMode
                                  ? Colors
                                      .grey
                                      .shade800 // Dark theme background
                                  : Colors
                                      .grey
                                      .shade100, // Light theme background
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.color,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'This generated audiogram and hearing test results are not precise and should be interpreted with caution. '
                              'For an accurate diagnosis, please consult a qualified audiologist or healthcare professional.',
                              style: KConstants.helperStyle.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
      },
    );
  }
}
