import 'package:flutter/material.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/alert_dialogs.dart';

// TODO:
// - show trends what has happened with hearing over time / from last test

// FIXME:
// - preserve the open graph on theme change (probably cubit?)
// - language support

class HearingTestHistoryResultsPage extends StatelessWidget {
  HearingTestHistoryResultsPage({super.key});
  final List<String> frequencyLabels = [
    '125',
    '250',
    '500',
    '1k',
    '2k',
    '4k',
    '8k',
  ];
  final List<List<double?>> leftEarData = [];
  final List<List<double?>> rightEarData = [];
  
  @override
  Widget build(BuildContext context) {
    final selectedIndexNotifier = ValueNotifier<int?>(null);
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              FutureBuilder<List<File>>(
                future: () async {
                  final dir = await getApplicationSupportDirectory();
                  final resultsDir = Directory('${dir.path}/HearingTest');
                  if (!await resultsDir.exists()) return <File>[];
                  return resultsDir.listSync().whereType<File>().toList();
                }(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final files = snapshot.data!;
                  return ValueListenableBuilder<int?>(
                    valueListenable: selectedIndexNotifier,
                    builder: (context, selectedIndex, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final fullFileName =
                              files[index].path
                                  .split(Platform.pathSeparator)
                                  .last;
                          String dateLabel = fullFileName;
                          final regex = RegExp(
                            r'test_result_(\d{4}-\d{2}-\d{2})',
                          );
                          final match = regex.firstMatch(fullFileName);
                          if (match != null && match.groupCount >= 1) {
                            dateLabel = match.group(1)!;
                          }
                          final file = files[index];
                          return FutureBuilder<String>(
                            future: file.readAsString(),
                            builder: (context, fileSnapshot) {
                              if (!fileSnapshot.hasData) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(dateLabel),
                                      subtitle: Text('Loading...'),
                                    ),
                                  ],
                                );
                              }
                              final json = jsonDecode(fileSnapshot.data!);
                              final leftEar =
                                  json['leftEarResults'] as List<dynamic>;
                              final rightEar =
                                  json['rightEarResults'] as List<dynamic>;
                              leftEarData.add(
                                leftEar
                                    .map(
                                      (e) =>
                                          e == null
                                              ? null
                                              : (e as num).toDouble(),
                                    )
                                    .toList(),
                              );
                              rightEarData.add(
                                rightEar
                                    .map(
                                      (e) =>
                                          e == null
                                              ? null
                                              : (e as num).toDouble(),
                                    )
                                    .toList(),
                              );
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(dateLabel),
                                    subtitle: Text(
                                      'Left: ${leftEar.map((ele) => ele ?? "-")}\nRight: ${rightEar.map((ele) => ele ?? "-")}',
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => DeleteAlertDialog(),
                                        );
                                        if (confirm == true) {
                                          await file.delete();
                                          (context as Element).markNeedsBuild();
                                        }
                                      },
                                    ),
                                    onTap: () {
                                      selectedIndexNotifier.value =
                                          selectedIndex == index ? null : index;
                                    },
                                  ),
                                  if (selectedIndex == index)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      height: 420,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 20,
                                        right: 20,
                                        bottom: 10,
                                      ),
                                      child: AudiogramChart(
                                        leftEarData: leftEarData[index],
                                        rightEarData: rightEarData[index],
                                        frequencyLabels: frequencyLabels,
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
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
  }
}
