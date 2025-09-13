class HearingLoss {
  int frequency;
  double value;
  bool isMasked;

  HearingLoss({
    required this.frequency,
    required this.value,
    required this.isMasked,
  });

  @override
  String toString() {
    return value.toString();
  }
}
