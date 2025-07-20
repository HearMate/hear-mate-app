import 'dart:io';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;

class HearingTestResult {
  final String filePath;
  final String dateLabel;
  final List<double?> leftEarResults;
  final List<double?> rightEarResults;
  final List<double?> leftEarResultsMasked;
  final List<double?> rightEarResultsMasked;

  HearingTestResult({
    required this.filePath,
    required this.dateLabel,
    required this.leftEarResults,
    required this.rightEarResults,
    required this.leftEarResultsMasked,
    required this.rightEarResultsMasked,
  });

  Map<String, dynamic> toJson() => {
    'leftEarResults': leftEarResults,
    'rightEarResults': rightEarResults,
    'leftEarResultsMasked': leftEarResultsMasked,
    'rightEarResultsMasked': rightEarResultsMasked,
  };

  static HearingTestResult fromJson(String path, Map<String, dynamic> json) {
    final left =
        (json['leftEarResults'] as List)
            .map((e) => e == null ? null : (e as num).toDouble())
            .toList();
    final right =
        (json['rightEarResults'] as List)
            .map((e) => e == null ? null : (e as num).toDouble())
            .toList();
    final leftMasked =
        (json['leftEarResultsMasked'] as List)
            .map((e) => e == null ? null : (e as num).toDouble())
            .toList();
    final rightMasked =
        (json['rightEarResultsMasked'] as List)
            .map((e) => e == null ? null : (e as num).toDouble())
            .toList();

    final fileName = path.split(Platform.pathSeparator).last;
    final regex = RegExp(r'test_result_(\d{4}-\d{2}-\d{2})');
    final match = regex.firstMatch(fileName);
    final dateLabel = match != null ? match.group(1)! : fileName;

    return HearingTestResult(
      filePath: path,
      dateLabel: dateLabel,
      leftEarResults: left,
      rightEarResults: right,
      leftEarResultsMasked: leftMasked,
      rightEarResultsMasked: rightMasked,
    );
  }

  bool hasMissingValues() {
    return leftEarResults.contains(null) || rightEarResults.contains(null);
  }

  bool needMasking() {
    for (int i = 0; i < leftEarResults.length; i++) {
      if (leftEarResults[i] != null && rightEarResults[i] != null) {
        final leftValue = leftEarResults[i]!;
        final rightValue = rightEarResults[i]!;
        if ((leftValue - rightValue).abs() >=
            HearingTestConstants.MASKING_THRESHOLDS[i]) {
          return true;
        }
      }
    }
    return false;
  }

  List<bool> getFrequenciesThatRequireMasking() {
    List<bool> resultsThatNeedMasking = List<bool>.filled(
      HearingTestConstants.TEST_FREQUENCIES.length,
      false,
    );
    for (int i = 0; i < HearingTestConstants.TEST_FREQUENCIES.length; i++) {
      if (leftEarResults[i] != null && rightEarResults[i] != null) {
        final leftValue = leftEarResults[i]!;
        final rightValue = rightEarResults[i]!;
        final threshold = HearingTestConstants.MASKING_THRESHOLDS[i];
        resultsThatNeedMasking[i] =
            (leftValue - rightValue).abs() >= threshold;
      }
    }
    return resultsThatNeedMasking;
  }
}
