class HearingTestResult {
  final List<double?> leftEarResults;
  final List<double?> rightEarResults;

  HearingTestResult({
    required this.leftEarResults,
    required this.rightEarResults,
  });

  Map<String, dynamic> toJson() => {
    'leftEarResults': leftEarResults,
    'rightEarResults': rightEarResults,
  };

  HearingTestResult.fromJson(Map<String, dynamic> json)
      : leftEarResults = List<double?>.from(json['leftEarResults']),
        rightEarResults = List<double?>.from(json['rightEarResults']);

  bool hasMissingValues() {
    return leftEarResults.contains(null) ||
           rightEarResults.contains(null);
  }
}