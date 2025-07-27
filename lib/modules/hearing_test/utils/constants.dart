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
final int EAR_COUNT = 2;
final int MIN_DB_LEVEL = -10;

final List<int> MASKING_THRESHOLDS = [
  40, // 1000 Hz
  45, // 2000 Hz
  50, // 4000 Hz
  200,// 8000 Hz - no threshold
  40, // 1000 Hz
  40, // 500 Hz
  40, // 250 Hz
  35 // 125 Hz
];