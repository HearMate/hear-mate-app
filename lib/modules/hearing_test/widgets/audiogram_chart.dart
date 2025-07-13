import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/constants.dart';

// TODO
// - replace circle markers with appropriate icons for left and right ear

class AudiogramChart extends StatelessWidget {
  final List<double?> leftEarData;
  final List<double?> rightEarData;
  final List<String> frequencyLabels;

  AudiogramChart({
    super.key,
    required this.leftEarData,
    required this.rightEarData,
    required this.frequencyLabels,
  });

  final int maxYValue = 100;
  final int minYValue = MIN_DB_LEVEL;

  List<FlSpot> remapSpots(List<double?> values) {
    if (values.length != frequencyLabels.length + 1) return [];
    final List<MapEntry<int, int>> mapping = [
      MapEntry(7, 0),
      MapEntry(6, 1),
      MapEntry(5, 2),
      // For 1000 Hz we always want to use the second value if available
      values[4] != null ? MapEntry(4, 3) : MapEntry(0, 3),
      MapEntry(1, 4),
      MapEntry(2, 5),
      MapEntry(3, 6),
    ];
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
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.blue,
                      strokeWidth: 1,
                      strokeColor: Colors.blue,
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
                      color: Colors.red,
                      strokeWidth: 1,
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
                  y: 25,
                  color: Colors.orange.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    style: const TextStyle(fontSize: 9, color: Colors.orange),
                    labelResolver:
                        (line) =>
                            AppLocalizations.of(
                              context,
                            )!.hearing_test_audiogram_chart_mild_loss,
                  ),
                ),
                HorizontalLine(
                  y: 40,
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
