import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class WaveformBar extends StatefulWidget {
  final bool isListening;

  const WaveformBar({
    super.key,
    required this.isListening,
  });

  @override
  State<WaveformBar> createState() => _WaveformBarState();
}

class _WaveformBarState extends State<WaveformBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isListening) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant WaveformBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
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
        final rng = math.Random(42);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(28, (i) {
            final double animVal = widget.isListening ? _controller.value : 0.0;
            final base = 6.0 + rng.nextDouble() * 20;
            final h = base + math.sin((animVal * math.pi * 2) + i * 0.4) * 12;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3,
              height: widget.isListening ? h.clamp(6, 40) : 6.0,
              decoration: BoxDecoration(
                color: Color.lerp(AppColors.purple, AppColors.cyan, i / 28)!
                    .withOpacity(widget.isListening ? 0.7 : 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
