import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

// TODO:
// - visualize a single test result
// - compare two test results
// - show trends 
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
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final fullFileName = files[index].path.split(Platform.pathSeparator).last;
                          String dateLabel = fullFileName;
                          final regex = RegExp(r'audiogram_result_(\d{4}-\d{2}-\d{2})');
                          final match = regex.firstMatch(fullFileName);
                          if (match != null && match.groupCount >= 1) {
                            dateLabel = match.group(1)!;
                          }
                          final file = files[index];
                          return FutureBuilder<String>(
                            future: file.readAsString(),
                            builder: (context, fileSnapshot) {
                              if (!fileSnapshot.hasData) {
                                return ListTile(
                                  title: Text(dateLabel),
                                  subtitle: Text('Loading...'),
                                );
                              }
                              final json = jsonDecode(fileSnapshot.data!);
                              final leftEar = json['leftEarResults'];
                              final rightEar = json['rightEarResults'];
                              return ListTile(
                                title: Text(dateLabel),
                                subtitle: Text('Left: $leftEar\nRight: $rightEar'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Result'),
                                        content: Text('Are you sure you want to delete this result?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await file.delete();
                                      (context as Element).markNeedsBuild();
                                    }
                                  },
                                ),
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
      },
    );
  }
}
