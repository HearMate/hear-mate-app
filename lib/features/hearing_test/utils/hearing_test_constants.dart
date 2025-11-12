final List<int> OUTPUT_FREQUENCIES = [125, 250, 500, 1000, 2000, 4000, 8000];

final List<int> TEST_FREQUENCIES = [
  1000,
  2000,
  4000,
  8000,
  1000,
  500,
  250,
  125,
];

final List<int> MASKING_THRESHOLDS = [
  40, // 1000 Hz
  40, // 2000 Hz
  40, // 4000 Hz
  40, // 8000 Hz
  40, // 1000 Hz
  40, // 500 Hz
  40, // 250 Hz
  40, // 125 Hz
];

final int EAR_COUNT = 2;
final int MIN_DB_LEVEL = -10;
final int MAX_DB_LEVEL = 120;
