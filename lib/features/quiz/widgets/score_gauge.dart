import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ScoreGauge extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ScoreGauge({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    final double percentage = widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0.0;
    _animation = Tween<double>(begin: 0.0, end: percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final percentageValue = (_animation.value * 100).toInt();
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180.r,
              height: 180.r,
              child: CustomPaint(
                painter: _ScoreGaugePainter(
                  progress: _animation.value,
                  colorScheme: Theme.of(context).colorScheme,
                  strokeWidth: 14.r,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percentageValue%',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.score} / ${widget.totalQuestions}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ScoreGaugePainter extends CustomPainter {
  final double progress;
  final ColorScheme colorScheme;
  final double strokeWidth;

  _ScoreGaugePainter({
    required this.progress,
    required this.colorScheme,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    // Draw background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Draw active progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          colorScheme.primary,
          colorScheme.secondary,
          colorScheme.tertiaryContainer,
          colorScheme.primary,
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ScoreGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.strokeWidth != strokeWidth;
  }
}
