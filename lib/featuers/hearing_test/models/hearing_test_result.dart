import 'dart:io';
import 'package:hear_mate_app/featuers/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_loss.dart';

class HearingTestResult {
  final String filePath;
  final String dateLabel;
  final List<HearingLoss?> hearingLossLeft;
  final List<HearingLoss?> hearingLossRight;
  final String audiogramDescription;

  HearingTestResult({
    required this.filePath,
    required this.dateLabel,
    required this.hearingLossLeft,
    required this.hearingLossRight,
    required this.audiogramDescription,
  });

  HearingTestResult copyWith({
    String? filePath,
    String? dateLabel,
    List<HearingLoss?>? hearingLossLeft,
    List<HearingLoss?>? hearingLossRight,
    String? audiogramDescription,
  }) {
    return HearingTestResult(
      filePath: filePath ?? this.filePath,
      dateLabel: dateLabel ?? this.dateLabel,
      hearingLossLeft: hearingLossLeft ?? this.hearingLossLeft,
      hearingLossRight: hearingLossRight ?? this.hearingLossRight,
      audiogramDescription: audiogramDescription ?? this.audiogramDescription,
    );
  }

  Map<String, dynamic> toJson() => {
    'hearingLossLeft':
        hearingLossLeft
            .map(
              (e) =>
                  e == null
                      ? null
                      : {
                        'frequency': e.frequency,
                        'value': e.value,
                        'isMasked': e.isMasked,
                      },
            )
            .toList(),
    'hearingLossRight':
        hearingLossRight
            .map(
              (e) =>
                  e == null
                      ? null
                      : {
                        'frequency': e.frequency,
                        'value': e.value,
                        'isMasked': e.isMasked,
                      },
            )
            .toList(),
    'audiogramDescription': audiogramDescription,
  };

  static HearingTestResult fromJson(String path, Map<String, dynamic> json) {
    final fileName = path.split(Platform.pathSeparator).last;
    final regex = RegExp(r'test_result_(\d{4}-\d{2}-\d{2})');
    final match = regex.firstMatch(fileName);
    final dateLabel = match != null ? match.group(1)! : fileName;

    List<HearingLoss?> parseList(List<dynamic> list) {
      return list
          .map(
            (e) =>
                e == null
                    ? null
                    : HearingLoss(
                      frequency: e['frequency'] as int,
                      value: (e['value'] as num).toDouble(),
                      isMasked: e['isMasked'] as bool,
                    ),
          )
          .toList();
    }

    return HearingTestResult(
      filePath: path,
      dateLabel: dateLabel,
      hearingLossLeft: parseList(json['hearingLossLeft'] as List),
      hearingLossRight: parseList(json['hearingLossRight'] as List),
      audiogramDescription: json['audiogramDescription'] as String,
    );
  }

  static HearingTestResult get empty => HearingTestResult(
    filePath: "",
    dateLabel: "",
    hearingLossLeft: List<HearingLoss?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    ),
    hearingLossRight: List<HearingLoss?>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      null,
    ),
    audiogramDescription: "",
  );

  bool hasMissingValues() {
    return hearingLossLeft.contains(null) ||
        hearingLossRight.contains(null) ||
        hearingLossLeft.isEmpty ||
        hearingLossRight.isEmpty;
  }
}
