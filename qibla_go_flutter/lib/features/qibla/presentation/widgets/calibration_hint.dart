import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/qibla_palette.dart';

/// A dot tracing a figure of eight: the calibration gesture, shown rather
/// than explained.
class CalibrationHint extends StatefulWidget {
  const CalibrationHint({super.key, this.size = 56});

  final double size;

  @override
  State<CalibrationHint> createState() => _CalibrationHintState();
}

class _CalibrationHintState extends State<CalibrationHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size(widget.size * 1.8, widget.size),
        painter: _LemniscatePainter(
          t: _controller.value,
          track: p.inkFaint,
          dot: p.warning,
        ),
      ),
    );
  }
}

class _LemniscatePainter extends CustomPainter {
  const _LemniscatePainter({
    required this.t,
    required this.track,
    required this.dot,
  });

  final double t;
  final Color track;
  final Color dot;

  Offset _point(double u, Size size) {
    // Lemniscate of Gerono, scaled to the box.
    final a = size.width / 2 * 0.9;
    final b = size.height / 2 * 0.85;
    return Offset(
      size.width / 2 + a * math.sin(u),
      size.height / 2 + b * math.sin(u) * math.cos(u),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 0; i <= 120; i++) {
      final p = _point(i / 120 * 2 * math.pi, size);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    final head = _point(t * 2 * math.pi, size);
    canvas.drawCircle(head, 4.5, Paint()..color = dot);
    canvas.drawCircle(
      head,
      9,
      Paint()..color = dot.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(_LemniscatePainter old) => old.t != t;
}
