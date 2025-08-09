import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_loss_classification.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_utils.dart';

List<double> _mapEarResults(List<double?> values) {
  var mapping = getFrequencyMapping(values);

  List<double> mapped = List.filled(mapping.length, 0.0);
  for (final entry in mapping) {
    final sourceIndex = entry.key;
    final targetIndex = entry.value;
    if (sourceIndex >= 0 && sourceIndex < values.length) {
      mapped[targetIndex] = values[sourceIndex] ?? 0.0;
    }
  }
  return mapped;
}

class HearingTestAudiogramClassificationRepository {
  bool _isHearingSymmetrical({
    required List<double> leftEarResults,
    required List<double> rightEarResults,
  }) {
    if (leftEarResults.length != 7 || rightEarResults.length != 7) {
      throw ArgumentError(
        "Input data must contain 7 values for each ear corresponding to hearing loss at frequencies 125, 250, 500, 1000, 2000, 4000, 8000 Hz.",
      );
    }

    // Calculate the absolute difference at each frequency
    final diff = List<double>.generate(
      7,
      (i) => (leftEarResults[i] - rightEarResults[i]).abs(),
    );

    // 1. Check for ≥20 dB HL at two contiguous frequencies
    int count20dBContiguous = 0;
    for (int i = 0; i < diff.length - 1; i++) {
      if (diff[i] >= 20 && diff[i + 1] >= 20) {
        count20dBContiguous++;
      }
    }
    if (count20dBContiguous > 0) {
      return false;
    }

    // 2. Check for ≥15 dB HL at any two frequencies between 2000 Hz and 8000 Hz (indices 4, 5, 6)
    final highFreqDiffs = [diff[4], diff[5], diff[6]];
    final count15dBHigh = highFreqDiffs.where((d) => d >= 15).length;
    if (count15dBHigh >= 2) {
      return false;
    }

    return true;
  }

  HearingLossClassification _getHearingLossClassification({
    required List<double> earResults,
  }) {
    if (earResults.length != 7) {
      throw ArgumentError("Input data must have exactly 7 features.");
    }
    final avg = (earResults[2] + earResults[3] + earResults[4]) / 3.0;

    if (avg <= 20) {
      return HearingLossClassification.None;
    } else if (avg <= 40) {
      return HearingLossClassification.Mild;
    } else if (avg <= 70) {
      return HearingLossClassification.Moderate;
    } else if (avg <= 90) {
      return HearingLossClassification.Severe;
    } else {
      return HearingLossClassification.Profound;
    }
  }

  bool _isHearingLossOnHighFrequencies({required List<double> earResults}) {
    return false;
  }

  bool _isHearingLossOnLowFrequencies({required List<double> earResults}) {
    return false;
  }

  Future<String> getAudiogramDescription({
    required List<double?> leftEarResults,
    required List<double?> rightEarResults,
  }) async {
    if (leftEarResults.length != HearingTestConstants.TEST_FREQUENCIES.length ||
        rightEarResults.length !=
            HearingTestConstants.TEST_FREQUENCIES.length) {
      return "Your audiogram is incomplete - we can't provide you with the classification.";
    }

    if (leftEarResults.contains(null) || rightEarResults.contains(null)) {
      return "Your audiogram is incomplete - we can't provide you with the classification.";
    }

    final left = _mapEarResults(leftEarResults.cast<double>());
    final right = _mapEarResults(rightEarResults.cast<double>());

    final leftClass = _getHearingLossClassification(earResults: left);
    final rightClass = _getHearingLossClassification(earResults: right);

    final symmetrical = _isHearingSymmetrical(
      leftEarResults: left,
      rightEarResults: right,
    );

    final hasHighFreqLossLeft = _isHearingLossOnHighFrequencies(
      earResults: left,
    );
    final hasHighFreqLossRight = _isHearingLossOnHighFrequencies(
      earResults: right,
    );

    final hasLowFreqLossLeft = _isHearingLossOnLowFrequencies(earResults: left);
    final hasLowFreqLossRight = _isHearingLossOnLowFrequencies(
      earResults: right,
    );

    String classifyText(HearingLossClassification c) {
      switch (c) {
        case HearingLossClassification.None:
          return "normal hearing";
        case HearingLossClassification.Mild:
          return "mild hearing loss";
        case HearingLossClassification.Moderate:
          return "moderate hearing loss";
        case HearingLossClassification.Severe:
          return "severe hearing loss";
        case HearingLossClassification.Profound:
          return "profound hearing loss";
      }
    }

    StringBuffer buffer = StringBuffer();

    buffer.write('Left ear: ${classifyText(leftClass)}. ');
    buffer.write('Right ear: ${classifyText(rightClass)}. ');

    if (symmetrical) {
      buffer.write("Hearing loss is symmetrical. ");
    } else {
      buffer.write("Hearing loss is asymmetrical. ");
    }

    if (hasHighFreqLossLeft || hasHighFreqLossRight) {
      if (hasHighFreqLossLeft && hasHighFreqLossRight) {
        buffer.write("High-frequency hearing loss is present in both ears. ");
      } else if (hasHighFreqLossLeft) {
        buffer.write(
          "High-frequency hearing loss is present in the left ear. ",
        );
      } else {
        buffer.write(
          "High-frequency hearing loss is present in the right ear. ",
        );
      }
    }

    if (hasLowFreqLossLeft || hasLowFreqLossRight) {
      if (hasLowFreqLossLeft && hasLowFreqLossRight) {
        buffer.write("Low-frequency hearing loss is present in both ears. ");
      } else if (hasLowFreqLossLeft) {
        buffer.write("Low-frequency hearing loss is present in the left ear. ");
      } else {
        buffer.write(
          "Low-frequency hearing loss is present in the right ear. ",
        );
      }
    }

    return buffer.toString().trim();
  }
}
