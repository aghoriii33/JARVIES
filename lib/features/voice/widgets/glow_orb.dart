import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class GlowOrb extends StatefulWidget {
  final bool isListening;
  final double soundLevel; // 0.0 to 1.0

  const GlowOrb({
    super.key,
    required this.isListening,
    required this.soundLevel,
  });

  @override
  State<GlowOrb> createState() => _GlowOrbState();
}

class _GlowOrbState extends State<GlowOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.isListening) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GlowOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isListening && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: GlowOrbPainter(
            animationValue: _controller.value,
            isListening: widget.isListening,
            soundLevel: widget.soundLevel,
          ),
          child: const SizedBox(width: 280, height: 280),
        );
      },
    );
  }
}

class GlowOrbPainter extends CustomPainter {
  final double animationValue;
  final bool isListening;
  final double soundLevel;

  GlowOrbPainter({
    required this.animationValue,
    required this.isListening,
    required this.soundLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2.4;

    // Amplitude factor scales between 1.0 (idle) and 2.5 (loud volume)
    final ampFactor = isListening ? 1.0 + (soundLevel * 1.5) : 1.0;

    // Colour shift based on state: listening -> shifts towards green/cyan; idle -> purple/cyan
    final Color color1 = isListening
        ? Color.lerp(AppColors.purple, AppColors.green, soundLevel)!
        : AppColors.purple;
    final Color color2 = isListening ? AppColors.cyan : AppColors.purpleDark;
    final Color color3 = isListening ? AppColors.green : AppColors.blue;

    // Outer ambient glow
    final glowPaint = Paint()
      ..color = color2.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, baseRadius * 1.2 * ampFactor, glowPaint);

    final glowPaint2 = Paint()
      ..color = color1.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawCircle(center, baseRadius * ampFactor, glowPaint2);

    // Outer rotating ring
    final ringPaint = Paint()
      ..shader = LinearGradient(
        colors: [color1, color2, color3],
        transform: GradientRotation(animationValue * math.pi * 2),
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(
      center,
      baseRadius + math.sin(animationValue * math.pi * 2) * (4 * ampFactor),
      ringPaint,
    );

    // Inner fluid wave: f(θ) = sin(4θ + φ) · 8 · cos(2θ)
    for (int layer = 0; layer < 3; layer++) {
      final opacity = 0.5 - layer * 0.12;
      final wavePaint = Paint()
        ..color = Color.lerp(color1, color2, layer / 2)!.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 - layer * 0.3;

      final path = Path();
      final phaseShift = layer * (math.pi / 3);
      for (double i = 0; i <= 360; i += 1.5) {
        final rad = i * math.pi / 180;
        final wave = math.sin(rad * 4 + animationValue * math.pi * 2 + phaseShift) *
            (8 * ampFactor) *
            math.cos(rad * 2);
        final r = baseRadius - 15 - layer * 8 + wave;
        final x = center.dx + r * math.cos(rad);
        final y = center.dy + r * math.sin(rad);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, wavePaint);
    }

    // Centre dot
    canvas.drawCircle(
      center,
      5,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..color = color1.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  @override
  bool shouldRepaint(covariant GlowOrbPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isListening != isListening ||
        oldDelegate.soundLevel != soundLevel;
  }
}
