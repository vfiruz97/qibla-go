import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../../app/theme/qibla_palette.dart';
import '../../../../core/astro/sky_position.dart';
import '../../../../core/geo/angles.dart';
import '../../application/sky_providers.dart';

/// Sun and moon drawn around the user at a fixed screen distance along
/// their true azimuths, with dashed guide lines. Must be a child of
/// [FlutterMap] so the camera is in scope.
class SkyOverlay extends StatelessWidget {
  const SkyOverlay({
    super.key,
    required this.sky,
    required this.sunLabel,
    required this.moonLabel,
    this.origin,
  });

  final SkySnapshot sky;

  /// Where to anchor the bodies; defaults to [SkySnapshot.at]. The map passes
  /// the animated marker position so the guides travel with it.
  final LatLng? origin;
  final String sunLabel;
  final String moonLabel;

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final p = QiblaPalette.of(context);
    final user = camera.latLngToScreenOffset(
      origin ?? LatLng(sky.at.latitude, sky.at.longitude),
    );
    final size = camera.nonRotatedSize;
    final radius = math.min(size.width, size.height) * 0.30;

    Offset place(double azimuth) {
      final a = Angles.toRadians(azimuth - camera.rotation - 90);
      return user + Offset(math.cos(a), math.sin(a)) * radius;
    }

    final bodies = <_Body>[
      if (sky.sun.isAboveHorizon)
        _Body(
          at: place(sky.sun.azimuth),
          color: p.warning,
          icon: Icons.wb_sunny_rounded,
          label: '$sunLabel ${sky.sun.azimuth.round()}°',
        ),
      if (sky.showMoon)
        _Body(
          at: place(sky.moon.azimuth),
          color: p.ink,
          icon: Icons.nightlight_round,
          label: '$moonLabel ${sky.moon.azimuth.round()}°',
          moonPhase: sky.moonIllumination.phase,
        ),
    ];
    if (bodies.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _GuidePainter(
              from: user,
              to: bodies.map((b) => (b.at, b.color)).toList(),
            ),
          ),
          for (final b in bodies)
            Positioned(
              left: b.at.dx - 56,
              top: b.at.dy - 22,
              width: 112,
              height: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: p.background.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      border: Border.all(color: b.color, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: b.color.withValues(alpha: 0.45),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: b.moonPhase == null
                        ? Icon(b.icon, color: b.color, size: 20)
                        : CustomPaint(
                            painter: _MoonPainter(
                              phase: b.moonPhase!,
                              lit: b.color,
                              dark: p.background,
                            ),
                          ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: p.background.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      b.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: b.color,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Body {
  const _Body({
    required this.at,
    required this.color,
    required this.icon,
    required this.label,
    this.moonPhase,
  });

  final Offset at;
  final Color color;
  final IconData icon;
  final String label;
  final double? moonPhase;
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter({required this.from, required this.to});

  final Offset from;
  final List<(Offset, Color)> to;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (target, color) in to) {
      final paint = Paint()
        ..color = color.withValues(alpha: 0.7)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      final total = (target - from).distance;
      final dir = (target - from) / total;
      const dash = 6.0;
      const gap = 5.0;
      var d = 18.0;
      while (d + dash < total - 20) {
        canvas.drawLine(from + dir * d, from + dir * (d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_GuidePainter old) => old.from != from || old.to != to;
}

/// A moon disc with the lit part on the correct side for the phase.
class _MoonPainter extends CustomPainter {
  const _MoonPainter({
    required this.phase,
    required this.lit,
    required this.dark,
  });

  final double phase;
  final Color lit;
  final Color dark;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * 0.28;
    canvas.drawCircle(c, r, Paint()..color = lit);
    // Terminator: an ellipse whose width follows the phase.
    final waxing = phase < 0.5;
    final k = math.cos(phase * 2 * math.pi); // 1 new, -1 full
    final shadow = Path();
    final rect = Rect.fromCircle(center: c, radius: r);
    // Half disc on the dark side plus/minus an ellipse of width r*|k|.
    final darkSide = Path()
      ..addArc(rect, waxing ? math.pi / 2 : -math.pi / 2, math.pi)
      ..close();
    final ellipse = Path()
      ..addOval(
        Rect.fromCenter(center: c, width: 2 * r * k.abs(), height: 2 * r),
      );
    if (k > 0) {
      shadow.addPath(darkSide, Offset.zero);
      shadow.addPath(ellipse, Offset.zero);
    } else {
      shadow.addPath(
        Path.combine(PathOperation.difference, darkSide, ellipse),
        Offset.zero,
      );
    }
    canvas.drawPath(shadow, Paint()..color = dark.withValues(alpha: 0.92));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = lit.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(_MoonPainter old) => old.phase != phase;
}

/// Eight-wind name key for an azimuth, for sentences like "about west".
int compassPointIndex(double azimuth) =>
    ((Angles.normalize(azimuth) + 22.5) ~/ 45) % 8;

/// Phase bucket 0..7: new, waxing crescent, first quarter, waxing
/// gibbous, full, waning gibbous, last quarter, waning crescent.
int moonPhaseIndex(MoonIllumination illumination) =>
    ((illumination.phase * 8 + 0.5).floor()) % 8;
