import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const AiWaveApp());
}

class AiWaveApp extends StatelessWidget {
  const AiWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Wave',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C5CE7),
          surface: Color(0xFF1A1A24),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ==========================================
// SCREEN 1: DASHBOARD
// ==========================================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white70),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A24),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Icon(Icons.hexagon_outlined, size: 20, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Greeting Text
              const Text(
                'Hi Zack Lee,',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                "Let's see what I can do for you?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Feature Grid / Row Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice Helper Feature Card
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VoiceBotScreen()),
                        );
                      },
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3F37C9), Color(0xFF4CC9F0)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Voice helper',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.mic,
                                      size: 16, color: Colors.white),
                                ),
                              ],
                            ),
                            const Text(
                              "Let's find new things using voice recording",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: RepublicButtons.whiteRound,
                              child: const Center(
                                child: Text('Start Recording',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Secondary Action Stack Cards
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildSmallActionCard(
                            'Start New Chat', Icons.chat_bubble_outline),
                        const SizedBox(height: 16),
                        _buildSmallActionCard(
                            'Search by image', Icons.portrait_outlined),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),

              // Recent Searches Heading
              const Text('Recently Search',
                  style: TextStyle(color: Colors.white50, fontSize: 14)),
              const SizedBox(height: 16),

              // Search List Items
              // FIX: replaced invalid EdgeInsets.bottom with a Column + spacing approach
              Column(
                children: [
                  _buildRecentSearchTile(
                      'Look for 5 potential headlines for websites with fintech themes'),
                  const SizedBox(height: 8),
                  _buildRecentSearchTile(
                      'find the python code to create a 10-fold branch'),
                  const SizedBox(height: 8),
                  _buildRecentSearchTile(
                      '5 copywriting for the benefits and features section on the SaaS website'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallActionCard(String title, IconData icon) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0x0DFFFFFF)), // FIX: Colors.white.withOpacity(0.05) as a literal
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.arrow_forward, size: 14, color: Colors.white50),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRecentSearchTile(String text) {
    return Container(
      // FIX: was `margin: const EdgeInsets.bottom` which is not a valid EdgeInsets
      // Now tiles are spaced using SizedBox in the parent Column above
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0x08FFFFFF)), // FIX: Colors.white.withOpacity(0.03)
      ),
      child: Row(
        children: [
          Icon(Icons.history, size: 18, color: Color(0x66FFFFFF)), // FIX: Colors.white.withOpacity(0.4)
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13), // FIX: Colors.white.withOpacity(0.8)
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.arrow_forward, size: 16, color: Color(0x4DFFFFFF)), // FIX: Colors.white.withOpacity(0.3)
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: VOICE ASSISTANT (ORB ANIMATION)
// ==========================================
class VoiceBotScreen extends StatefulWidget {
  const VoiceBotScreen({super.key});

  @override
  State<VoiceBotScreen> createState() => _VoiceBotScreenState();
}

class _VoiceBotScreenState extends State<VoiceBotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              // Top Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('Speaking to Ai bot',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              const Text("Go ahead, I'm listening",
                  style: TextStyle(color: Colors.white38, fontSize: 14)),

              // Glowing Animated Core Orb Component
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: GlowOrbPainter(_controller.value),
                      child: const SizedBox(width: 260, height: 260),
                    );
                  },
                ),
              ),

              // Interactive Text Recognition Display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        fontSize: 22,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text:
                              'What is digital abstract design and find 3 example of '),
                      TextSpan(
                          text: 'abstract design',
                          style: TextStyle(color: Colors.white38)),
                    ],
                  ),
                ),
              ),

              // Audio Input UI Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircleButton(Icons.keyboard_alt_outlined),
                  Container(
                    height: 72,
                    width: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xFF2E2E3A), Color(0xFF15151C)]),
                    ),
                    child: const Icon(Icons.mic, size: 28, color: Colors.white),
                  ),
                  _buildCircleButton(Icons.close),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
        color: const Color(0xFF1A1A24),
      ),
      child: Icon(icon, size: 20, color: Colors.white70),
    );
  }
}

// Custom Painter implementation for the fine neon fluid wave orb
class GlowOrbPainter extends CustomPainter {
  final double animationValue;
  GlowOrbPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.4;

    // Glowing blur effect background
    final glowPaint = Paint()
      ..color = const Color(0xFF4CC9F0).withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, radius, glowPaint);

    // Primary Animated Ring
    final ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6C5CE7), Color(0xFF4CC9F0), Color(0xFF3F37C9)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
        center,
        radius + (math.sin(animationValue * math.pi * 2) * 3),
        ringPaint);

    // Dynamic inner abstract path lines representing ambient noise waves
    final wavePaint = Paint()
      ..color = const Color(0xFF4CC9F0).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    for (double i = 0; i <= 360; i += 2) {
      double radians = i * math.pi / 180;
      // Trigonometric formula simulation for fluid mechanics visualization
      // f(θ) = sin(4θ + φ)·8·cos(2θ)  where φ = animationValue·2π
      double waveOffset =
          math.sin(radians * 4 + animationValue * math.pi * 2) *
              8 *
              math.cos(radians * 2);
      double currentRadius = radius - 15 + waveOffset;
      double x = center.dx + currentRadius * math.cos(radians);
      double y = center.dy + currentRadius * math.sin(radians);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant GlowOrbPainter oldDelegate) => true;
}

// Global UI Layout Variables helper class
class RepublicButtons {
  static BoxDecoration get whiteRound => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      );
}
