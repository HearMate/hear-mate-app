import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_loss.dart';
import 'package:hear_mate_app/featuers/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_loss_classification.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:http/http.dart' as http;

class HearingTestAudiogramClassificationRepository {
  final http.Client _httpClient = http.Client();
  final String _baseUrl =
      "http://127.0.0.1:8000 "; // TODO: Change, when deploying to production.
  final String _highFrequencyEndpoint = "/hearing/high-frequency-loss";
  final String _lowFrequencyEndpoint = "/hearing/low-frequency-loss";

  void dispose() {
    _httpClient.close();
  }

  Future<bool> _postEarResultsBool({
    required String endpoint,
    required List<double> earResults,
  }) async {
    const Duration requestTimeout = Duration(seconds: 8);

    if (earResults.length != 7) {
      throw ArgumentError(
        "earResults must have exactly 7 values (125..8000 Hz mapped).",
      );
    }

    final Uri baseUri = Uri.parse(_baseUrl);
    final uri = baseUri.resolve(endpoint);

    try {
      final resp = await _httpClient
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
    return _postEarResultsBool(
      endpoint: _highFrequencyEndpoint,
      earResults: earResults,
    );
  }

  Future<bool> _isHearingLossOnLowFrequencies({
    required List<double> earResults,
  }) {
    return _postEarResultsBool(
      endpoint: _lowFrequencyEndpoint,
      earResults: earResults,
    );
  }

  Future<String> getAudiogramDescription({
    required AppLocalizations l10n,
    required List<HearingLoss?> leftEarResults,
    required List<HearingLoss?> rightEarResults,
  }) async {
    if (leftEarResults.length !=
            HearingTestConstants.OUTPUT_FREQUENCIES.length ||
        rightEarResults.length !=
            HearingTestConstants.OUTPUT_FREQUENCIES.length) {
      return l10n.hearing_test_incomplete;
    }

    if (leftEarResults.contains(null) || rightEarResults.contains(null)) {
      return l10n.hearing_test_incomplete;
    }

    final List<double> left = leftEarResults.map((e) => e!.value).toList();
    final List<double> right = rightEarResults.map((e) => e!.value).toList();

    final leftClass = _getHearingLossClassification(earResults: left);
    final rightClass = _getHearingLossClassification(earResults: right);

    final symmetrical = _isHearingSymmetrical(
      leftEarResults: left,
      rightEarResults: right,
    );

    String classifyText(HearingLossClassification c) {
      switch (c) {
        case HearingLossClassification.None:
          return l10n.hearing_test_classification_normal_hearing;
        case HearingLossClassification.Mild:
          return l10n.hearing_test_classification_mild;
        case HearingLossClassification.Moderate:
          return l10n.hearing_test_classification_moderate;
        case HearingLossClassification.Severe:
          return l10n.hearing_test_classification_severe;
        case HearingLossClassification.Profound:
          return l10n.hearing_test_classification_profound;
      }
    }

    final buffer = StringBuffer();

    // Friendly intro
    buffer.write('${l10n.hearing_test_summary_intro} ');

    // Per-ear lines
    buffer.write(
      '${l10n.hearing_test_ear_line(l10n.hearing_test_ear_left, classifyText(leftClass))} ',
    );
    buffer.write(
      '${l10n.hearing_test_ear_line(l10n.hearing_test_ear_right, classifyText(rightClass))} ',
    );

    // Symmetry
    buffer.write(
      symmetrical
          ? '${l10n.hearing_test_symmetry_symmetrical} '
          : '${l10n.hearing_test_symmetry_asymmetrical} ',
    );

    // Frequency-specific notes
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

    if (hasHighFreqLossLeft || hasHighFreqLossRight) {
      if (hasHighFreqLossLeft && hasHighFreqLossRight) {
        buffer.write('${l10n.hearing_test_high_freq_both} ');
      } else if (hasHighFreqLossLeft) {
        buffer.write('${l10n.hearing_test_high_freq_left} ');
      } else {
        buffer.write('${l10n.hearing_test_high_freq_right} ');
      }
    }

    if (hasLowFreqLossLeft || hasLowFreqLossRight) {
      if (hasLowFreqLossLeft && hasLowFreqLossRight) {
        buffer.write('${l10n.hearing_test_low_freq_both} ');
      } else if (hasLowFreqLossLeft) {
        buffer.write('${l10n.hearing_test_low_freq_left} ');
      } else {
        buffer.write('${l10n.hearing_test_low_freq_right} ');
      }
    }

    return buffer.toString().trim();
  }
}
