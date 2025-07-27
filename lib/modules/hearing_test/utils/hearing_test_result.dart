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

  List<bool> getFrequenciesThatRequireMasking() {
    final frequencies = HearingTestConstants.TEST_FREQUENCIES;
    final thresholds = HearingTestConstants.MASKING_THRESHOLDS;

    return List<bool>.generate(frequencies.length, (i) {
      final left = leftEarResults[i];
      final right = rightEarResults[i];

      if (left != null && right != null) {
        return (left - right).abs() >= thresholds[i];
      }
      return false;
    });
  }
}
