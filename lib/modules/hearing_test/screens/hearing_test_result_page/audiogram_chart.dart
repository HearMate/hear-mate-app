import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/** @TODO
 * This widget needs some changes:
 * - add option to save results
 * - make it so that values are being treated like in audiogram - so revert the flip of sign, and then make it possible to add negative values.
 *  */

class AudiogramChart extends StatelessWidget {
  final List<FlSpot> leftEarSpots;
  final List<FlSpot> rightEarSpots;
  final List<String> frequencyLabels;

  const AudiogramChart({
    super.key,
    required this.leftEarSpots,
    required this.rightEarSpots,
    required this.frequencyLabels,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> frequencyLabels = [
      '1k',
      '2k',
      '4k',
      '8k',
      '500',
      '250',
      '125',
    ];
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 20,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(top: 1.0),
              child: Text('Frequency (Hz)', style: TextStyle(fontSize: 12)),
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
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Text('dB HL', style: TextStyle(fontSize: 12)),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int displayValue = value.toInt();
                return Text(
                  displayValue.toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text('Frequency (Hz)', style: TextStyle(fontSize: 12)),
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
        minY: -20,
        maxY: 120,
        lineBarsData: [
          // Left ear line (blue)
          LineChartBarData(
            spots: leftEarSpots,
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
            spots: rightEarSpots,
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
        // Reference lines for hearing loss severity - do we need that? TODO: check
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: -25,
              color: Colors.orange.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(fontSize: 9, color: Colors.orange),
                labelResolver: (line) => 'Mild loss',
              ),
            ),
            HorizontalLine(
              y: -40,
              color: Colors.deepOrange.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(fontSize: 9, color: Colors.deepOrange),
                labelResolver: (line) => 'Moderate loss',
              ),
            ),
            HorizontalLine(
              y: -70,
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(fontSize: 9, color: Colors.red),
                labelResolver: (line) => 'Severe loss',
              ),
            ),
          ],
        ),
        clipData: FlClipData.all(),
      ),
    );
  }
}
