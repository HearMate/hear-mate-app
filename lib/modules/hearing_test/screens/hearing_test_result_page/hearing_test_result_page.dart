import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/audiogram_chart.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HearingTestResultPage extends StatelessWidget {
  const HearingTestResultPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
        final leftEarResults = state.results[1];
        final rightEarResults = state.results[0];
            
        return Scaffold(
          appBar: HMAppBar(
            title: AppLocalizations.of(context)!.hearing_test_result_page_title,
            route: ModalRoute.of(context)?.settings.name ?? "",
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      AppLocalizations.of(context)!.hearing_test_result_page_your_results,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      AppLocalizations.of(context)!.hearing_test_result_page_instruction,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 420,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                    child: AudiogramChart(
                      leftEarSpots: leftEarResults,
                      rightEarSpots: rightEarResults,
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
                              AppLocalizations.of(context)!.hearing_test_result_page_note,
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
                              AppLocalizations.of(context)!.hearing_test_result_page_note_description,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
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
                    child: Text(
                      AppLocalizations.of(context)!.hearing_test_result_page_save_results,
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
                    child: Text(
                      AppLocalizations.of(context)!.hearing_test_result_page_home,
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
