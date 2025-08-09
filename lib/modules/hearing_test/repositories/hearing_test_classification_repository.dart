import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_loss_classification.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_utils.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:http/http.dart' as http;

class HearingTestAudiogramClassificationRepository {
  http.Client httpClient = http.Client();
  final String baseUrl =
      "http://127.0.0.1:8000 "; // TODO: Change, when deploying to production.
  final String highFrequencyEndpoint = "/hearing/high-frequency-loss";
  final String lowFrequencyEndpoint = "/hearing/low-frequency-loss";

  void dispose() {
    httpClient.close();
  }

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

  Future<bool> _postBool({
    required String endpoint,
    required List<double> earResults,
  }) async {
    const Duration requestTimeout = Duration(seconds: 8);

    if (earResults.length != 7) {
      throw ArgumentError(
        "earResults must have exactly 7 values (125..8000 Hz mapped).",
      );
    }

    String _joinUrl(String base, String path) {
      if (base.endsWith('/') && path.startsWith('/')) {
        return base.substring(0, base.length - 1) + path;
      } else if (!base.endsWith('/') && !path.startsWith('/')) {
        return '$base/$path';
      }
      return '$base$path';
    }

    final uri = Uri.parse(_joinUrl(baseUrl, endpoint));

    try {
      final resp = await httpClient
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'earResults': earResults}),
          )
          .timeout(requestTimeout);

      if (resp.statusCode != 200) {
        throw HttpException(
          '[$endpoint] Server responded with ${resp.statusCode}: ${resp.body}',
          uri: uri,
        );
      }

      final decoded = jsonDecode(resp.body);
      if (decoded is! Map<String, dynamic> || decoded['result'] is! bool) {
        throw const FormatException(
          'Invalid response schema (expected {result: bool}).',
        );
      }
      return decoded['result'] as bool;
    } on TimeoutException catch (e) {
      HMLogger.print("[ERROR] [$endpoint] Request timed out: $e");
      return false;
    } on SocketException catch (e) {
      HMLogger.print("[ERROR] [$endpoint] Network error: $e");
      return false;
    } on FormatException catch (e) {
      HMLogger.print(
        "[ERROR][1] Couldn't send data to server responsible for audiogram description. $e",
      );
      return false;
    } catch (e) {
      HMLogger.print(
        "[ERROR][2] Couldn't send data to server responsible for audiogram description. $e",
      );

      return false;
    }
  }

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

  Future<bool> _isHearingLossOnHighFrequencies({
    required List<double> earResults,
  }) {
    return _postBool(endpoint: highFrequencyEndpoint, earResults: earResults);
  }

  Future<bool> _isHearingLossOnLowFrequencies({
    required List<double> earResults,
  }) {
    return _postBool(endpoint: lowFrequencyEndpoint, earResults: earResults);
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

    final futures = await Future.wait<bool>([
      _isHearingLossOnHighFrequencies(earResults: left),
      _isHearingLossOnHighFrequencies(earResults: right),
      _isHearingLossOnLowFrequencies(earResults: left),
      _isHearingLossOnLowFrequencies(earResults: right),
    ]);

    final hasHighFreqLossLeft = futures[0];
    final hasHighFreqLossRight = futures[1];
    final hasLowFreqLossLeft = futures[2];
    final hasLowFreqLossRight = futures[3];

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
