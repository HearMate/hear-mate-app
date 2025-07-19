import 'dart:io';

class HearingTestResult {
  final String filePath;
  final String dateLabel;
  final List<double?> leftEarResults;
  final List<double?> rightEarResults;

  HearingTestResult({
    required this.filePath,
    required this.dateLabel,
    required this.leftEarResults,
    required this.rightEarResults,
  });

  Map<String, dynamic> toJson() => {
    'leftEarResults': leftEarResults,
    'rightEarResults': rightEarResults,
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

    final fileName = path.split(Platform.pathSeparator).last;
    final regex = RegExp(r'test_result_(\d{4}-\d{2}-\d{2})');
    final match = regex.firstMatch(fileName);
    final dateLabel = match != null ? match.group(1)! : fileName;

    return HearingTestResult(
      filePath: path,
      dateLabel: dateLabel,
      leftEarResults: left,
      rightEarResults: right,
    );
  }

  bool hasMissingValues() {
    return leftEarResults.contains(null) || rightEarResults.contains(null);
  }
}
