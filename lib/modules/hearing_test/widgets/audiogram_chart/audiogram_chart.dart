import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_loss.dart';
import 'package:hear_mate_app/featuers/hearing_test/utils/constants.dart'
    as HearingTestConstants;
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_point.dart';
import 'package:hear_mate_app/utils/fl_dot_triangle_painter.dart';

class AudiogramChart extends StatelessWidget {
  final List<HearingLoss?> hearingLossLeft;
  final List<HearingLoss?> hearingLossRight;

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
    required this.hearingLossLeft,
    required this.hearingLossRight,
  });

  final int maxYValue = HearingTestConstants.MAX_DB_LEVEL;
  final int minYValue = HearingTestConstants.MIN_DB_LEVEL;

  List<AudiogramPoint> buildAudiogramPoints(List<HearingLoss?> values) {
    return values.asMap().entries.where((e) => e.value != null).map((entry) {
      final i = entry.key.toDouble(); // index 0..6
      final value = entry.value!;
      return AudiogramPoint(FlSpot(i, value.value), value.isMasked);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final leftEarPoints = buildAudiogramPoints(hearingLossLeft);
    final leftEarSpots = leftEarPoints.map((p) => p.spot).toList();

    final rightEarPoints = buildAudiogramPoints(hearingLossRight);
    final rightEarSpots = rightEarPoints.map((p) => p.spot).toList();

    final bool isLeftMasking = hearingLossLeft.any(
      (element) => element?.isMasked ?? false,
    );

    final bool isRightMasking = hearingLossRight.any(
      (element) => element?.isMasked ?? false,
    );

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150, maxHeight: 500),
          child: LineChart(
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
                      if (displayValue < minYValue ||
                          displayValue > maxYValue) {
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
                LineChartBarData(
                  spots: leftEarSpots,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final isMasked = leftEarPoints[index].masked;
                      if (isMasked) {
                        return FlDotSquarePainter(
                          color: Colors.transparent,
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                          size: 12.0,
                        );
                      } else {
                        return FlDotCrossPainter(
                          size: 12,
                          color: Colors.blue,
                          width: 2,
                        );
                      }
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: rightEarSpots,
                  isCurved: false,
                  color: Colors.red,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final isMasked = rightEarPoints[index].masked;
                      if (isMasked) {
                        return FlDotTrianglePainter(
                          color: Colors.transparent,
                          strokeWidth: 2.0,
                          strokeColor: Colors.red,
                          size: 12.0,
                        );
                      } else {
                        return FlDotCirclePainter(
                          radius: 6.0,
                          color: Colors.transparent,
                          strokeColor: Colors.red,
                          strokeWidth: 2.0,
                        );
                      }
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(enabled: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 20,
                    color: Colors.red.withAlpha(80),
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
                    color: Colors.deepOrange.withAlpha(80),
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
                    color: const Color.fromARGB(255, 138, 124, 0).withAlpha(80),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color.fromARGB(255, 138, 124, 0),
                      ),
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
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            _legendItem(
              FlDotCrossPainter(size: 12, color: Colors.blue, width: 2),
              AppLocalizations.of(
                context,
              )!.hearing_test_audiogram_chart_left_ear,
            ),
            _legendItem(
              FlDotCirclePainter(
                radius: 6,
                color: Colors.transparent,
                strokeWidth: 2,
                strokeColor: Colors.red,
              ),
              AppLocalizations.of(
                context,
              )!.hearing_test_audiogram_chart_right_ear,
            ),
            if (isLeftMasking)
              _legendItem(
                FlDotSquarePainter(
                  color: Colors.transparent,
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                  size: 12.0,
                ),
                AppLocalizations.of(
                  context,
                )!.hearing_test_audiogram_chart_left_ear_masked,
              ),
            if (isRightMasking)
              _legendItem(
                FlDotTrianglePainter(
                  color: Colors.transparent,
                  strokeWidth: 2,
                  strokeColor: Colors.red,
                  size: 12.0,
                ),
                AppLocalizations.of(
                  context,
                )!.hearing_test_audiogram_chart_right_ear_masked,
              ),
          ],
        ),
        if (isLeftMasking || isRightMasking)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              AppLocalizations.of(
                context,
              )!.hearing_test_audiogram_chart_masking_explanation,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _LegendShapePainter extends CustomPainter {
  final FlDotPainter painter;

  _LegendShapePainter(this.painter);

  @override
  void paint(Canvas canvas, Size size) {
    // Center the shape in the canvas
    final Offset center = Offset(size.width / 2, size.height / 2);
    painter.draw(canvas, FlSpot(0, 0), center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget _legendItem(FlDotPainter painter, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomPaint(
        size: const Size(16, 16),
        painter: _LegendShapePainter(painter),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}
