import 'package:flutter/material.dart';

class EchoParseWelcomeScreen extends StatelessWidget {
  const EchoParseWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for better responsive layout
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

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
      ),
      // Use Stack as the main layout to position bottom container
      body: Stack(
        children: [
          // Scrollable content area
          SingleChildScrollView(
            // Add bottom padding to prevent content from being hidden behind the bottom container
            padding: const EdgeInsets.only(bottom: 280),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  // Content container with fixed height to prevent movement
                  Container(
                    height:
                        screenHeight *
                        0.65, // Fixed height based on screen height
                    color: Colors.white,
                    child: Stack(
                      children: [
                        // Top audio waves (yellow)
                        Positioned(
                          top: 60,
                          left: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _buildAudioWaves(
                              count: 7,
                              color: const Color(0xFFFFDC7C),
                              heights: [40, 25, 40, 25, 40, 25, 15],
                              width: 8,
                              spacing: 8,
                            ),
                          ),
                        ),

                        // Title with enhanced styling
                        Positioned(
                          top: 140,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                'EchoParse®',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.5,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'by ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  const Text(
                                    'HEAR MATE',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                      color: Color(0xFF1A2533),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Line chart visual - moved down to avoid overlapping with title
                        Positioned(
                          top:
                              270, // Increased top position to avoid overlapping
                          left: 20,
                          right: 20,
                          child: Container(
                            height: 100, // Fixed height container
                            child: CustomPaint(
                              size: const Size(double.infinity, 100),
                              painter: LineChartPainter(),
                            ),
                          ),
                        ),

                        // Bottom right audio waves (red)
                        Positioned(
                          right: 20,
                          top: 350, // Adjusted position
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _buildAudioWaves(
                              count: 4,
                              color: const Color(0xFFFF5757),
                              heights: [25, 35, 25, 40],
                              width: 8,
                              spacing: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom container fixed at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF20B2AA),
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Let's go button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/echo_parse/upload");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5757),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 2,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Let\'s go.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Info text
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: const Text(
                      'Your audiogram now in CSV!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAudioWaves({
    required int count,
    required Color color,
    required List<double> heights,
    required double width,
    required double spacing,
  }) {
    return List.generate(
      count,
      (index) => Container(
        width: width,
        height: heights[index % heights.length],
        margin: EdgeInsets.only(right: spacing),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(width / 2),
        ),
      ),
    );
  }
}

// Custom painter for the line chart
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();

    // Starting point
    path.moveTo(0, size.height * 0.5);

    // Create line chart points
    path.lineTo(size.width * 0.1, size.height * 0.2);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.1);
    path.lineTo(size.width * 0.6, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width * 0.9, size.height * 0.4);

    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.1),
      Offset(size.width * 0.6, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.4),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the pie chart
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw pie segments
    final paint = Paint()..style = PaintingStyle.fill;

    // Red segment (45%)
    paint.color = const Color(0xFFFF5757);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * 3.14159 * 0.45,
      true,
      paint,
    );

    // Yellow segment (35%)
    paint.color = const Color(0xFFFFDC7C);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2 * 3.14159 * 0.45,
      2 * 3.14159 * 0.35,
      true,
      paint,
    );

    // Blue segment (20%)
    paint.color = const Color(0xFF4D97FF);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2 * 3.14159 * 0.8,
      2 * 3.14159 * 0.2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
