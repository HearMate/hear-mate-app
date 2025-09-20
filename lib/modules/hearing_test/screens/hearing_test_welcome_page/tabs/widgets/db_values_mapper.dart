import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as hearing_test_constants;
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_utils.dart';

List<String> remapDbValues(List<double?> values, List<double?>? maskedValues) {
  if (values.length != hearing_test_constants.TEST_FREQUENCIES.length) {
    return [];
  }

  final mapping = getFrequencyMapping(values);
  final List<String> mapped = [];

  for (final entry in mapping) {
    final int index = entry.key;
    final double? unmaskedValue = values[index];
    final double? maskedValue =
        maskedValues != null ? maskedValues[index] : null;

    final bool isMasked = maskedValue != null;
    final double? dbValue = isMasked ? maskedValue : unmaskedValue;

    if (dbValue != null) {
      final valueStr = dbValue.toStringAsFixed(1);
      mapped.add(valueStr);
    } else {
      mapped.add('-');
    }
  }

  return mapped;
}
