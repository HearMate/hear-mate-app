import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/hearing_test_utils.dart';
import 'package:hear_mate_app/modules/hearing_test/utils/constants.dart'
    as HearingTestConstants;


class AudiogramChart extends StatelessWidget {
  final List<double?> leftEarData;
  final List<double?> rightEarData;

  final List<String> frequencyLabels = const [
    '125',
    '250',
    '500',
    '1k',
    '2k',
    '4k',
    '8k',
  ];

  AudiogramChart({
    super.key,
    required this.leftEarData,
    required this.rightEarData,
  });

  final int maxYValue = 100;
  final int minYValue = HearingTestConstants.MIN_DB_LEVEL;

  List<FlSpot> remapSpots(List<double?> values) {
    if (values.length != frequencyLabels.length + 1) return [];
    final mapping = getFrequencyMapping(values);
    final List<FlSpot> mapped = [];
    for (final entry in mapping) {
      final dbValue = values[entry.key];
      if (dbValue != null) {
        mapped.add(
          FlSpot(entry.value.toDouble(), maxYValue - (dbValue - minYValue)),
        );
      }
    }
    return mapped;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              horizontalInterval: 10,
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                axisNameWidget: Text(
                  AppLocalizations.of(
                    context,
                  )!.hearing_test_audiogram_chart_frequency,
                  style: TextStyle(fontSize: 12),
                ),

                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.round();

                    // Hide labels if value isn't explicitly mapped to a frequency label
                    if (index < 0 || index >= frequencyLabels.length) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        frequencyLabels[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: Text('dB HL', style: TextStyle(fontSize: 12)),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 10,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    int displayValue =
                        (maxYValue - (value - minYValue)).toInt();
                    if (displayValue < minYValue || displayValue > maxYValue) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      displayValue.toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                axisNameWidget: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.hearing_test_audiogram_chart_frequency,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.shade300),
            ),
            minX: -0.5,
            maxX: 6.5,
            minY: minYValue - 5,
            maxY: maxYValue + 5,
            lineBarsData: [
              // Left ear line (blue)
              LineChartBarData(
                spots: remapSpots(leftEarData),
                isCurved: false,
                color: Colors.blue,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCrossPainter(
                      size: 12,
                      color: Colors.blue,
                      width: 2,
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
              ),
              // Right ear line (red)
              LineChartBarData(
                spots: remapSpots(rightEarData),
                isCurved: false,
                color: Colors.red,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                        color: Colors.transparent,
                      strokeWidth: 2,
                      strokeColor: Colors.red,
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(enabled: false),
            // TODO: check
            // Reference lines for hearing loss severity - do we need that?
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 20,
                  color: Colors.red.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    style: const TextStyle(fontSize: 9, color: Colors.red),
                    labelResolver:
                        (line) =>
                            AppLocalizations.of(
                              context,
                            )!.hearing_test_audiogram_chart_severe_loss,
                  ),
                ),
                HorizontalLine(
                  y: 50,
                  color: Colors.deepOrange.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.deepOrange,
                    ),
                    labelResolver:
                        (line) =>
                            AppLocalizations.of(
                              context,
                            )!.hearing_test_audiogram_chart_moderate_loss,
                  ),
                ),
                HorizontalLine(
                  y: 70,
                  color: const Color.fromARGB(255, 138, 124, 0).withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    style: const TextStyle(fontSize: 9, color: Color.fromARGB(255, 138, 124, 0)),
                    labelResolver:
                        (line) =>
                            AppLocalizations.of(
                              context,
                            )!.hearing_test_audiogram_chart_mild_loss,
                  ),
                ),
              ],
            ),
            clipData: FlClipData.all(),
          ),
        ),
        Positioned(
          top: 25,
          right: 5,
          child: Row(
            children: [
              Container(width: 12, height: 12, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(
                  context,
                )!.hearing_test_audiogram_chart_left_ear,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 20),
              Container(width: 12, height: 12, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(
                  context,
                )!.hearing_test_audiogram_chart_right_ear,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
