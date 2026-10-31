import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/theme/qibla_palette.dart';
import '../../../l10n/app_localizations.dart';

/// The opening moment: a ring of ticks sweeps into place, a gold ray rises
/// to the Kaaba, the wordmark settles, and the veil lifts onto the app.
///
/// Plays once per launch, about 2.4 s, tap to skip. Honors the system
/// reduced-motion setting by not playing at all.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 2400);

  /// Progress at which the fade-out begins; tapping jumps here.
  static const _fadeStart = 0.84;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );
  bool _done = false;

  /// If frames stall (hidden browser tab, throttled device) the veil must
  /// still lift; the app behind it is what matters.
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();
    _watchdog = Timer(_duration * 2, _finish);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finish();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _finish();
      } else {
        _controller.forward();
      }
    });
  }

  void _finish() {
    if (_done) return;
    _done = true;
    widget.onDone();
  }

  void _skip() {
    if (_controller.value < _fadeStart) {
      _controller.forward(from: _fadeStart);
    }
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.night;
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final veil =
            1 -
            Curves.easeInCubic.transform(
              ((t - _fadeStart) / (1 - _fadeStart)).clamp(0.0, 1.0),
            );
        final scale = 1 + (1 - veil) * 0.05;
        return IgnorePointer(
          ignoring: veil == 0,
          child: Opacity(
            opacity: veil,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _skip,
              child: Transform.scale(
                scale: scale,
                child: ColoredBox(
                  color: p.background,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        painter: _IntroPainter(t: t, palette: p),
                      ),
                      _Wordmark(t: t, palette: p, tagline: l10n.introTagline),
                      Positioned(
                        right: 16,
                        top: MediaQuery.paddingOf(context).top + 8,
                        child: Opacity(
                          opacity: Curves.easeIn.transform(
                            (t * 3).clamp(0.0, 1.0),
                          ),
                          child: TextButton(
                            onPressed: _skip,
                            child: Text(
                              l10n.introSkip,
                              style: TextStyle(color: p.inkFaint),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({
    required this.t,
    required this.palette,
    required this.tagline,
  });

  final double t;
  final QiblaPalette palette;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final title = Curves.easeOutCubic.transform(
      ((t - 0.48) / 0.3).clamp(0.0, 1.0),
    );
    final sub = Curves.easeOutCubic.transform(
      ((t - 0.62) / 0.28).clamp(0.0, 1.0),
    );
    return Align(
      alignment: const Alignment(0, 0.62),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: title,
            child: Transform.translate(
              offset: Offset(0, (1 - title) * 14),
              child: Text(
                'Qibla Go',
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 40,
                  color: palette.ink,
                  letterSpacing: 8 - 6 * title,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Opacity(
            opacity: sub,
            child: Transform.translate(
              offset: Offset(0, (1 - sub) * 10),
              child: Text(
                tagline,
                style: TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: palette.gold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroPainter extends CustomPainter {
  const _IntroPainter({required this.t, required this.palette});

  final double t;
  final QiblaPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final radius = math.min(size.width, size.height) * 0.28;

    // Glow swells under the ring.
    final glow = Curves.easeOut.transform((t / 0.6).clamp(0.0, 1.0));
    canvas.drawCircle(
      center,
      radius * (0.6 + 0.6 * glow),
      Paint()
        ..shader = ui.Gradient.radial(center, radius * 1.3, [
          palette.gold.withValues(alpha: 0.16 * glow),
          palette.gold.withValues(alpha: 0),
        ]),
    );

    // Ticks sweep in clockwise from north.
    final sweep = Curves.easeOutQuart.transform((t / 0.55).clamp(0.0, 1.0));
    final visibleDegrees = sweep * 360;
    final minor = Paint()
      ..color = palette.tick
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final major = Paint()
      ..color = palette.tickMajor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var deg = 0; deg < 360; deg += 3) {
      if (deg > visibleDegrees) break;
      final isMajor = deg % 30 == 0;
      final a = (deg - 90) * math.pi / 180;
      final dir = Offset(math.cos(a), math.sin(a));
      final len = isMajor ? radius * 0.1 : radius * 0.045;
      // The newest ticks arrive from slightly outside, settling inward.
      final arrival = ((visibleDegrees - deg) / 40).clamp(0.0, 1.0);
      final outer = radius * (1 + 0.12 * (1 - arrival));
      canvas.drawLine(
        center + dir * outer,
        center + dir * (outer - len),
        (isMajor ? major : minor)
          ..color = (isMajor ? palette.tickMajor : palette.tick).withValues(
            alpha: 0.3 + 0.7 * arrival,
          ),
      );
    }

    // Outer hairline ring closes with the sweep.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.08),
      -math.pi / 2,
      sweep * 2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = palette.gold.withValues(alpha: 0.5),
    );

    // The ray rises to the Kaaba.
    final ray = Curves.easeOutCubic.transform(
      ((t - 0.3) / 0.4).clamp(0.0, 1.0),
    );
    if (ray > 0) {
      final start = center.translate(0, -radius * 0.1);
      final end = center.translate(0, -radius * 0.7 * ray);
      canvas.drawLine(
        start,
        end,
        Paint()
          ..shader = ui.Gradient.linear(start, end, [
            palette.gold.withValues(alpha: 0.1),
            palette.goldBright,
          ])
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    }
    final pop = Curves.elasticOut.transform(
      ((t - 0.58) / 0.3).clamp(0.0, 1.0),
    );
    if (pop > 0) {
      _paintKaaba(
        canvas,
        center.translate(0, -radius * 0.86),
        radius * 0.12 * pop,
      );
    }

    // Center cap.
    canvas.drawCircle(
      center,
      radius * 0.035 * glow,
      Paint()..color = palette.gold,
    );
  }

  void _paintKaaba(Canvas canvas, Offset at, double size) {
    const cloth = Color(0xFF0C0B0A);
    final rect = Rect.fromCenter(center: at, width: size, height: size * 1.08);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size * 0.12));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = palette.gold.withValues(alpha: 0.4)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, size * 0.3),
    );
    canvas.drawRRect(rrect, Paint()..color = cloth);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = palette.gold,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        rect.left,
        rect.top + rect.height * 0.24,
        rect.width,
        rect.height * 0.14,
      ),
      Paint()..color = palette.gold,
    );
  }

  @override
  bool shouldRepaint(_IntroPainter old) => old.t != t;
}
