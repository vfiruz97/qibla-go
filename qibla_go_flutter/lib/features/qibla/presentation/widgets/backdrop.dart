import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/qibla_palette.dart';

/// Full-screen background: a faint eight-pointed-star lattice, the oldest
/// motif of Islamic geometry, under a warm glow where the dial sits.
class Backdrop extends StatelessWidget {
  const Backdrop({super.key, this.glowAlignment = const Alignment(0, -0.2)});

  final Alignment glowAlignment;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: p.background),
          CustomPaint(painter: _LatticePainter(p.lattice)),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: glowAlignment,
                radius: 0.75,
                colors: [
                  p.gold.withValues(alpha: 0.13),
                  p.gold.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatticePainter extends CustomPainter {
  const _LatticePainter(this.color);

  final Color color;

  static const _tile = 112.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final half = _tile / 2;
    final star = _star(half * 0.62);
    for (var y = -half; y < size.height + _tile; y += _tile) {
      for (var x = -half; x < size.width + _tile; x += _tile) {
        canvas.save();
        canvas.translate(x + half, y + half);
        canvas.drawPath(star, paint);
        canvas.restore();
        // Offset second row of smaller stars for a woven feel.
        canvas.save();
        canvas.translate(x + _tile, y + _tile);
        canvas.scale(0.42);
        canvas.drawPath(star, paint);
        canvas.restore();
      }
    }
  }

  /// Two squares, one turned 45°: the Rub el Hizb.
  static Path _star(double r) {
    final path = Path();
    for (final rotation in [0.0, math.pi / 4]) {
      final square = Path();
      for (var i = 0; i < 4; i++) {
        final a = rotation + i * math.pi / 2 + math.pi / 4;
        final p = Offset(r * math.cos(a), r * math.sin(a));
        if (i == 0) {
          square.moveTo(p.dx, p.dy);
        } else {
          square.lineTo(p.dx, p.dy);
        }
      }
      square.close();
      path.addPath(square, Offset.zero);
    }
    return path;
  }

  @override
  bool shouldRepaint(_LatticePainter old) => old.color != color;
}
