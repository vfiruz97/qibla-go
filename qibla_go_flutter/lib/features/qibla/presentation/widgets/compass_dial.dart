import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/theme/qibla_palette.dart';
import '../../../../core/geo/angles.dart';
import '../../domain/qibla_state.dart';

/// The compass face.
///
/// The ring of ticks turns so that its N always points at real north, while
/// a fixed index at the top marks where the phone points. The qibla is a
/// gold ray on the ring, so the user simply turns until the ray stands under
/// the index. Rotation is smoothed here, per frame, along the unwrapped
/// angle so crossing north never spins the dial the long way round.
class CompassDial extends StatefulWidget {
  const CompassDial({
    super.key,
    required this.size,
    required this.trust,
    required this.isAligned,
    this.trueHeading,
    this.qiblaBearing,
    this.cardinals = const ['N', 'E', 'S', 'W'],
  });

  final double size;

  /// Device heading from true north. Null draws the ring north-up.
  final double? trueHeading;

  /// Qibla bearing from true north. Null hides the ray.
  final double? qiblaBearing;

  final NeedleTrust trust;
  final bool isAligned;
  final List<String> cardinals;

  @override
  State<CompassDial> createState() => _CompassDialState();
}

class _CompassDialState extends State<CompassDial>
    with SingleTickerProviderStateMixin {
  /// Larger is snappier. 14 settles a 90° turn in about a third of a second
  /// without visible lag behind the hand.
  static const _stiffness = 14.0;

  late final Ticker _ticker;
  final _target = UnwrappedAngle();
  double _display = 0;
  bool _hasDisplay = false;
  Duration? _lastTick;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _retarget();
  }

  @override
  void didUpdateWidget(CompassDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trueHeading != widget.trueHeading) _retarget();
  }

  void _retarget() {
    final heading = widget.trueHeading;
    // The ring rotates opposite to the heading.
    final rotation = heading == null ? 0.0 : -heading;
    _target.update(rotation);
    if (!_hasDisplay) {
      _hasDisplay = true;
      _display = _target.value;
      return;
    }
    if (!_ticker.isActive) {
      _lastTick = null;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final last = _lastTick;
    _lastTick = elapsed;
    if (last == null) return;
    final dt = (elapsed - last).inMicroseconds / 1e6;
    final diff = _target.value - _display;
    if (diff.abs() < 0.02) {
      setState(() => _display = _target.value);
      _ticker.stop();
      return;
    }
    setState(() {
      _display += diff * (1 - math.exp(-dt * _stiffness));
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _DialPainter(
          rotationDegrees: _display,
          qiblaBearing: widget.qiblaBearing,
          trust: widget.trust,
          isAligned: widget.isAligned,
          palette: palette,
          cardinalStyle: text.headlineSmall!.copyWith(
            fontFamily: AppFonts.display,
            fontSize: widget.size * 0.075,
          ),
          numeralStyle: text.labelSmall!.copyWith(
            fontSize: widget.size * 0.03,
            color: palette.inkFaint,
            letterSpacing: 0,
          ),
          cardinals: widget.cardinals,
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.rotationDegrees,
    required this.qiblaBearing,
    required this.trust,
    required this.isAligned,
    required this.palette,
    required this.cardinalStyle,
    required this.numeralStyle,
    required this.cardinals,
  });

  final double rotationDegrees;
  final double? qiblaBearing;
  final NeedleTrust trust;
  final bool isAligned;
  final QiblaPalette palette;
  final TextStyle cardinalStyle;
  final TextStyle numeralStyle;
  final List<String> cardinals;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final blocked = trust == NeedleTrust.blocked;

    _paintHalo(canvas, center, radius);
    _paintFace(canvas, center, radius);

    // Everything that turns with the Earth.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (blocked) {
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        Paint()..color = const Color(0x40FFFFFF),
      );
    }
    canvas.rotate(Angles.toRadians(rotationDegrees));
    _paintTicks(canvas, radius);
    _paintLabels(canvas, radius);
    final bearing = qiblaBearing;
    if (bearing != null && !blocked) _paintQibla(canvas, radius, bearing);
    if (blocked) canvas.restore();
    canvas.restore();

    _paintIndex(canvas, center, radius);
    _paintCap(canvas, center, radius);
  }

  void _paintHalo(Canvas canvas, Offset center, double radius) {
    if (!isAligned) return;
    final glow = trust == NeedleTrust.trusted ? palette.gold : palette.warning;
    canvas.drawCircle(
      center,
      radius * 0.985,
      Paint()
        ..color = glow.withValues(alpha: 0.38)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, radius * 0.08),
    );
  }

  void _paintFace(Canvas canvas, Offset center, double radius) {
    final face = radius * 0.955;
    canvas.drawCircle(
      center,
      face,
      Paint()
        ..shader = ui.Gradient.radial(
          center.translate(0, -face * 0.25),
          face * 1.25,
          [palette.surfaceRaised, palette.dialFace],
          const [0.0, 1.0],
        ),
    );
    // Soft inner shadow at the rim, for depth.
    canvas.drawCircle(
      center,
      face,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = face * 0.08
        ..color = palette.background.withValues(alpha: 0.35)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, face * 0.05),
    );
    canvas.drawCircle(
      center,
      face,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = palette.dialRim,
    );
    // Hairline outer ring in gold.
    canvas.drawCircle(
      center,
      radius * 0.995,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = palette.gold.withValues(alpha: isAligned ? 0.9 : 0.35),
    );
  }

  void _paintTicks(Canvas canvas, double radius) {
    final outer = radius * 0.90;
    final minor = Paint()
      ..color = palette.tick
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final mid = Paint()
      ..color = palette.tick
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final major = Paint()
      ..color = palette.tickMajor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var deg = 0; deg < 360; deg += 2) {
      final isMajor = deg % 30 == 0;
      final isMid = deg % 10 == 0;
      final length = isMajor
          ? radius * 0.085
          : isMid
          ? radius * 0.055
          : radius * 0.03;
      final a = Angles.toRadians(deg.toDouble() - 90);
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        dir * outer,
        dir * (outer - length),
        isMajor
            ? major
            : isMid
            ? mid
            : minor,
      );
    }
  }

  void _paintLabels(Canvas canvas, double radius) {
    final labelRadius = radius * 0.735;
    for (var i = 0; i < 12; i++) {
      final deg = i * 30;
      final isCardinal = deg % 90 == 0;
      final text = isCardinal ? cardinals[deg ~/ 90] : '$deg';
      final style = isCardinal
          ? cardinalStyle.copyWith(
              color: deg == 0 ? palette.gold : palette.ink,
            )
          : numeralStyle;
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.rotate(Angles.toRadians(deg.toDouble()));
      canvas.translate(0, -labelRadius);
      painter.paint(
        canvas,
        Offset(-painter.width / 2, -painter.height / 2),
      );
      canvas.restore();
    }
  }

  void _paintQibla(Canvas canvas, double radius, double bearing) {
    final color = trust == NeedleTrust.trusted ? palette.gold : palette.warning;
    final bright = trust == NeedleTrust.trusted
        ? palette.goldBright
        : palette.warning;
    canvas.save();
    canvas.rotate(Angles.toRadians(bearing));

    final rayStart = Offset(0, -radius * 0.10);
    final rayEnd = Offset(0, -radius * 0.62);
    if (isAligned) {
      canvas.drawLine(
        rayStart,
        rayEnd,
        Paint()
          ..color = bright.withValues(alpha: 0.55)
          ..strokeWidth = radius * 0.06
          ..strokeCap = StrokeCap.round
          ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, radius * 0.04),
      );
    }
    canvas.drawLine(
      rayStart,
      rayEnd,
      Paint()
        ..shader = ui.Gradient.linear(rayStart, rayEnd, [
          color.withValues(alpha: 0.15),
          bright,
        ])
        ..strokeWidth = isAligned ? 3.2 : 2.2
        ..strokeCap = StrokeCap.round,
    );
    // Arrow tip.
    final tip = Offset(0, -radius * 0.675);
    final tipPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - radius * 0.035, tip.dy + radius * 0.07)
      ..lineTo(tip.dx + radius * 0.035, tip.dy + radius * 0.07)
      ..close();
    canvas.drawPath(tipPath, Paint()..color = bright);

    // Sits over the tick ring, clear of the numerals at 0.735R.
    _paintKaaba(
      canvas,
      Offset(0, -radius * 0.84),
      radius * (isAligned ? 0.115 : 0.10),
      color,
    );
    canvas.restore();
  }

  /// A small Kaaba: black cube, gold band (the hizam), a gold door.
  void _paintKaaba(Canvas canvas, Offset at, double size, Color gold) {
    const cloth = Color(0xFF0C0B0A);
    final rect = Rect.fromCenter(center: at, width: size, height: size * 1.08);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size * 0.12));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = gold.withValues(alpha: 0.35)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, size * 0.25),
    );
    canvas.drawRRect(rrect, Paint()..color = cloth);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = gold,
    );
    final band = Rect.fromLTWH(
      rect.left,
      rect.top + rect.height * 0.24,
      rect.width,
      rect.height * 0.14,
    );
    canvas.drawRect(band, Paint()..color = gold);
    final door = Rect.fromLTWH(
      rect.left + rect.width * 0.62,
      rect.top + rect.height * 0.52,
      rect.width * 0.18,
      rect.height * 0.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(door, Radius.circular(size * 0.05)),
      Paint()..color = gold.withValues(alpha: 0.9),
    );
  }

  void _paintIndex(Canvas canvas, Offset center, double radius) {
    // Lubber line: where the phone points.
    final top = center.translate(0, -radius * 0.955);
    final path = Path()
      ..moveTo(top.dx, top.dy + radius * 0.015)
      ..lineTo(top.dx - radius * 0.04, top.dy - radius * 0.045)
      ..lineTo(top.dx + radius * 0.04, top.dy - radius * 0.045)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = isAligned ? palette.goldBright : palette.ink,
    );
    canvas.drawLine(
      center.translate(0, -radius * 0.90),
      center.translate(0, -radius * 0.66),
      Paint()
        ..color = (isAligned ? palette.goldBright : palette.ink).withValues(
          alpha: 0.5,
        )
        ..strokeWidth = 1,
    );
  }

  void _paintCap(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius * 0.045,
      Paint()..color = palette.dialRim,
    );
    canvas.drawCircle(
      center,
      radius * 0.028,
      Paint()..color = isAligned ? palette.goldBright : palette.gold,
    );
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.rotationDegrees != rotationDegrees ||
      old.qiblaBearing != qiblaBearing ||
      old.trust != trust ||
      old.isAligned != isAligned ||
      old.palette != palette ||
      old.cardinalStyle != cardinalStyle;
}
