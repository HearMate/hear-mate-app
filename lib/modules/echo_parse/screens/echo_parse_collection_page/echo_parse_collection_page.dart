import 'package:flutter/material.dart';

class EchoParseCollectScreen extends StatelessWidget {
  const EchoParseCollectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  // Top yellow audio waves
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

                  // Collect button
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5757),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Collect',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Teal line chart
                  Positioned(
                    top: 220,
                    left: 20,
                    child: CustomPaint(
                      size: const Size(180, 80),
                      painter: TealChartPainter(),
                    ),
                  ),

                  // Blue audio waves
                  Positioned(
                    top: 230,
                    right: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildAudioWaves(
                        count: 5,
                        color: const Color(0xFF4D97FF),
                        heights: [40, 25, 40, 25, 40],
                        width: 8,
                        spacing: 8,
                      ),
                    ),
                  ),

                  // Person with tech devices
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Tech devices around person
                          _buildTechDevice(
                            top: 50,
                            left: 80,
                            icon: Icons.headphones,
                            color: const Color(0xFF20B2AA),
                          ),
                          _buildTechDevice(
                            top: 20,
                            right: 100,
                            icon: Icons.videogame_asset,
                            color: const Color(0xFFFFDC7C),
                            isRectangle: true,
                          ),
                          _buildTechDevice(
                            bottom: 120,
                            right: 60,
                            icon: Icons.camera_alt,
                            color: const Color(0xFF9370DB),
                          ),
                          _buildTechDevice(
                            bottom: 40,
                            right: 100,
                            icon: Icons.sports_esports,
                            color: const Color(0xFFFFDC7C),
                            rotation: -0.2,
                          ),

                          // Connect lines
                          CustomPaint(
                            size: const Size(300, 300),
                            painter: ConnectLinesPainter(),
                          ),

                          // Person illustration
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Placeholder for person illustration
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF5757),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Headphones
                                      Positioned(
                                        top: 15,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          width: 80,
                                          height: 2,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      // Eyes
                                      Positioned(
                                        top: 40,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            Container(
                                              width: 12,
                                              height: 12,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Smile
                                      Positioned(
                                        top: 65,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          width: 40,
                                          height: 20,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                          ),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Devices in hands
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Phone
                                    Container(
                                      width: 40,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 120),
                                    // Laptop
                                    Container(
                                      width: 80,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFDC7C),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom container
          Container(
            width: double.infinity,
            height: 70,
            color: const Color(0xFF20B2AA),
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

  Widget _buildTechDevice({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required IconData icon,
    required Color color,
    bool isRectangle = false,
    double rotation = 0,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 40,
          height: isRectangle ? 25 : 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isRectangle ? 4 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// Custom painter for teal chart
class TealChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF20B2AA)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();

    // Create line chart path
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.7);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.6);

    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint =
        Paint()
          ..color = const Color(0xFF20B2AA)
          ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.6),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for connecting lines
class ConnectLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.lightBlue.withOpacity(0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    // Draw connecting lines
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 80, paint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
