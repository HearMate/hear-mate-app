import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/modules/hearing_test_result.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

// TODO:
// - delete a result with a prompt
// - visualize a single test result
// - compare two test results
// - show trends 

Future<List<HearingTestResult>> loadResultsFromFiles() async {
  final dir = await getApplicationSupportDirectory();
  final resultsDir = Directory('${dir.path}/HearingTest');
  if (!await resultsDir.exists()) return [];
  final files = resultsDir.listSync().whereType<File>().toList();
  List<HearingTestResult> results = [];
  for (final file in files) {
    final content = await file.readAsString();
    final json = jsonDecode(content);
    results.add(HearingTestResult.fromJson(json));
  }
  return results;
}

class HearingTestHistoryResultsPage extends StatelessWidget {
  const HearingTestHistoryResultsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
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
                      AppLocalizations.of(
                        context,
                      )!.hearing_test_result_page_your_results,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  FutureBuilder<List<HearingTestResult>>(
                    future: loadResultsFromFiles(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final results = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: false,
                            onChanged: (val) {},
                            title: Text('Result ${index + 1}'),
                            subtitle: Text(
                              'Left: ${results[index].leftEarResults}\nRight: ${results[index].rightEarResults}',
                            ),
                          );
                        },
                      );
                    },
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
