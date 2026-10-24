import 'package:flutter/material.dart';

import '../../../../app/theme/qibla_palette.dart';

/// Small Kaaba pin for map markers: black cube, gold band, soft glow.
class KaabaMarker extends StatelessWidget {
  const KaabaMarker({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    return Center(
      child: Container(
        width: size,
        height: size * 1.08,
        decoration: BoxDecoration(
          color: const Color(0xFF0C0B0A),
          borderRadius: BorderRadius.circular(size * 0.12),
          border: Border.all(color: p.gold, width: 1.2),
          boxShadow: [
            BoxShadow(color: p.gold.withValues(alpha: 0.6), blurRadius: 12),
          ],
        ),
        child: Align(
          alignment: const Alignment(0, -0.5),
          child: Container(height: size * 0.15, color: p.gold),
        ),
      ),
    );
  }
}

/// The user's position: a gold dot with a breathing halo.
class UserMarker extends StatefulWidget {
  const UserMarker({super.key});

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeOut.transform(_c.value);
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 12 + 32 * t,
              height: 12 + 32 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.gold.withValues(alpha: 0.35 * (1 - t)),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.goldBright,
                border: Border.all(color: p.background, width: 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
