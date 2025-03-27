import 'package:flutter/material.dart';

class EchoParseUploadScreen extends StatelessWidget {
  const EchoParseUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload your data.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Wrap the entire body in a SingleChildScrollView to make it scrollable
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Upload container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF20B2AA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Upload title
                    const Text(
                      'Load your audiogram.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Format information
                    const Text(
                      'Accepted format: png, jpg',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    // Audiogram preview
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomPaint(
                          painter: AudiogramChartPainter(),
                          size: const Size(double.infinity, 180),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Upload button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/echo_parse/collection");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5757),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 2,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Upload.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Previous files section heading
              const Text(
                'Previous files.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              // Previous files grid - now in a fixed height container that's scrollable
              SizedBox(
                height: 200, // Fixed height for the previous files section
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final itemWidth = 150.0;
                    final spacing = 30.0;

                    // Always use horizontal scrolling for consistency
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPreviousFileItem(name: 'lateEvening.png'),
                          SizedBox(width: spacing),
                          _buildPreviousFileItem(name: 'earlyMorning.png'),
                          // Add more items as needed
                          SizedBox(width: spacing),
                          _buildPreviousFileItem(name: 'afternoonCheck.png'),
                          SizedBox(width: spacing),
                          _buildPreviousFileItem(name: 'morningTest.png'),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Add bottom spacing for better visual balance
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousFileItem({required String name, double width = 150}) {
    return Container(
      width: width,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF78CDFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: width - 20,
            height: 120,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(painter: AudiogramChartPainter(isSmall: true)),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Custom painter for the audiogram chart
class AudiogramChartPainter extends CustomPainter {
  final bool isSmall;

  AudiogramChartPainter({this.isSmall = false});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw dotted reference line
    final referencePaint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final referenceY = size.height * 0.6;

    // Draw dotted line
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, referenceY),
        Offset(startX + dashWidth, referenceY),
        referencePaint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw the red line chart
    final redLinePaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final redPath = Path();
    redPath.moveTo(0, size.height * 0.9);
    redPath.lineTo(size.width * 0.1, size.height * 0.8);
    redPath.lineTo(size.width * 0.3, size.height * 0.3);
    redPath.lineTo(size.width * 0.5, size.height * 0.7);
    redPath.lineTo(size.width * 0.7, size.height * 0.4);
    redPath.lineTo(size.width * 0.9, size.height * 0.2);

    canvas.drawPath(redPath, redLinePaint);

    // Draw the green line chart
    final greenLinePaint =
        Paint()
          ..color = const Color(0xFF20B2AA)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final greenPath = Path();
    greenPath.moveTo(0, size.height * 0.7);
    greenPath.lineTo(size.width * 0.2, size.height * 0.4);
    greenPath.lineTo(size.width * 0.4, size.height * 0.5);
    greenPath.lineTo(size.width * 0.6, size.height * 0.4);
    greenPath.lineTo(size.width * 0.8, size.height * 0.6);
    greenPath.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(greenPath, greenLinePaint);

    // Draw data points on red line
    final redPointPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    final redPoints = [
      Offset(0, size.height * 0.9),
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.9, size.height * 0.2),
    ];

    for (final point in redPoints) {
      canvas.drawCircle(point, isSmall ? 3 : 6, redPointPaint);

      // Draw outer circle for red points
      final outerCirclePaint =
          Paint()
            ..color = Colors.red.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawCircle(point, isSmall ? 5 : 10, outerCirclePaint);
    }

    // Draw data points on green line
    final greenPointPaint =
        Paint()
          ..color = const Color(0xFF20B2AA)
          ..style = PaintingStyle.fill;

    final greenPoints = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width, size.height * 0.5),
    ];

    for (final point in greenPoints) {
      canvas.drawCircle(point, isSmall ? 2 : 4, greenPointPaint);

      // Draw diamond shape for green points
      if (!isSmall) {
        final diamondPath = Path();
        diamondPath.moveTo(point.dx, point.dy - 8);
        diamondPath.lineTo(point.dx + 8, point.dy);
        diamondPath.lineTo(point.dx, point.dy + 8);
        diamondPath.lineTo(point.dx - 8, point.dy);
        diamondPath.close();

        final diamondPaint =
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill;

        canvas.drawPath(diamondPath, diamondPaint);

        final diamondBorderPaint =
            Paint()
              ..color = const Color(0xFF20B2AA)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2;

        canvas.drawPath(diamondPath, diamondBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
