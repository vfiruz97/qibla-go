import 'package:flutter/material.dart';

/// The app's colour vocabulary, independent of Material's scheme.
///
/// Two moods: "kiswa night" (default), black cloth and gold thread, and an
/// ivory day mode. Widgets read these through `QiblaPalette.of(context)`,
/// never raw hex values.
@immutable
final class QiblaPalette extends ThemeExtension<QiblaPalette> {
  const QiblaPalette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.ink,
    required this.inkMuted,
    required this.inkFaint,
    required this.gold,
    required this.goldBright,
    required this.goldDim,
    required this.success,
    required this.warning,
    required this.danger,
    required this.dialFace,
    required this.dialRim,
    required this.tick,
    required this.tickMajor,
    required this.lattice,
  });

  static const night = QiblaPalette(
    background: Color(0xFF0B0A09),
    surface: Color(0xFF15130F),
    surfaceRaised: Color(0xFF1E1A14),
    ink: Color(0xFFF2EADB),
    inkMuted: Color(0xFFA89E8C),
    inkFaint: Color(0xFF5E574C),
    gold: Color(0xFFD4AF37),
    goldBright: Color(0xFFF3D985),
    goldDim: Color(0xFF7F6620),
    success: Color(0xFF8FC48B),
    warning: Color(0xFFE2A94F),
    danger: Color(0xFFE0735F),
    dialFace: Color(0xFF110F0C),
    dialRim: Color(0xFF2B251B),
    tick: Color(0xFF4C4538),
    tickMajor: Color(0xFFC9B98A),
    lattice: Color(0x14D4AF37),
  );

  static const day = QiblaPalette(
    background: Color(0xFFF4EEE2),
    surface: Color(0xFFFBF7EE),
    surfaceRaised: Color(0xFFFFFFFF),
    ink: Color(0xFF17130D),
    inkMuted: Color(0xFF6B6354),
    inkFaint: Color(0xFFB2A997),
    gold: Color(0xFFA8862B),
    goldBright: Color(0xFFC8A445),
    goldDim: Color(0xFFE6D8AE),
    success: Color(0xFF3F7D4F),
    warning: Color(0xFFB2702A),
    danger: Color(0xFFB4483B),
    dialFace: Color(0xFFFFFCF5),
    dialRim: Color(0xFFE2D8C1),
    tick: Color(0xFFD2C8B0),
    tickMajor: Color(0xFF6C5A1E),
    lattice: Color(0x12A8862B),
  );

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color ink;
  final Color inkMuted;
  final Color inkFaint;
  final Color gold;
  final Color goldBright;
  final Color goldDim;
  final Color success;
  final Color warning;
  final Color danger;
  final Color dialFace;
  final Color dialRim;
  final Color tick;
  final Color tickMajor;
  final Color lattice;

  static QiblaPalette of(BuildContext context) =>
      Theme.of(context).extension<QiblaPalette>() ?? night;

  @override
  QiblaPalette copyWith() => this;

  @override
  QiblaPalette lerp(ThemeExtension<QiblaPalette>? other, double t) {
    if (other is! QiblaPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return QiblaPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceRaised: l(surfaceRaised, other.surfaceRaised),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      inkFaint: l(inkFaint, other.inkFaint),
      gold: l(gold, other.gold),
      goldBright: l(goldBright, other.goldBright),
      goldDim: l(goldDim, other.goldDim),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      dialFace: l(dialFace, other.dialFace),
      dialRim: l(dialRim, other.dialRim),
      tick: l(tick, other.tick),
      tickMajor: l(tickMajor, other.tickMajor),
      lattice: l(lattice, other.lattice),
    );
  }
}
