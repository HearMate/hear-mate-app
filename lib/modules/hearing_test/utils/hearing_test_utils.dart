// mapping: MapEntry<sourceIndex, targetIndex>
List<MapEntry<int, int>> getFrequencyMapping(List<double?> values) {
  return [
    MapEntry(7, 0),
    MapEntry(6, 1),
    MapEntry(5, 2),
    // For 1000 Hz we always want to use the second value if available
    values[4] != null ? MapEntry(4, 3) : MapEntry(0, 3),
    MapEntry(1, 4),
    MapEntry(2, 5),
    MapEntry(3, 6),
  ];
}
