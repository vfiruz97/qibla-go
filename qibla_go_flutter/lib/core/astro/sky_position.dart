import 'dart:math' as math;

import '../geo/angles.dart';
import '../geo/geo_point.dart';

/// Where a body is in the sky as seen from a point on Earth.
final class SkyPosition {
  const SkyPosition({required this.azimuth, required this.altitude});

  /// Degrees clockwise from true north, `[0, 360)`.
  final double azimuth;

  /// Degrees above the horizon; negative means below it.
  final double altitude;

  bool get isAboveHorizon => altitude > 0;

  @override
  String toString() =>
      'SkyPosition(az ${azimuth.toStringAsFixed(2)}°, '
      'alt ${altitude.toStringAsFixed(2)}°)';
}

/// Moon phase, `0` new → `0.5` full → `1` new, with the lit fraction.
final class MoonIllumination {
  const MoonIllumination({required this.fraction, required this.phase});

  /// Illuminated fraction of the disc, `0..1`.
  final double fraction;

  /// `0..1`: 0 new moon, 0.25 first quarter, 0.5 full, 0.75 last quarter.
  final double phase;

  bool get isWaxing => phase < 0.5;
}

/// Sun and Moon positions, after the algorithms in Astronomy Answers
/// (Jean Meeus-derived) as popularised by the `suncalc` library.
///
/// Accuracy is about 0.5° for the Sun and 1–2° for the Moon, which is
/// plenty for "the qibla is a little to the right of the sun". Pure Dart,
/// no dependencies, unit tested against published reference values.
abstract final class SkyCalculator {
  static const _dayMs = 86400000;
  static const _j1970 = 2440588.0;
  static const _j2000 = 2451545.0;
  static final _obliquity = Angles.toRadians(23.4397);

  static double _toDays(DateTime date) =>
      date.toUtc().millisecondsSinceEpoch / _dayMs - 0.5 + _j1970 - _j2000;

  static double _rightAscension(double l, double b) => math.atan2(
    math.sin(l) * math.cos(_obliquity) - math.tan(b) * math.sin(_obliquity),
    math.cos(l),
  );

  static double _declination(double l, double b) => math.asin(
    math.sin(b) * math.cos(_obliquity) +
        math.cos(b) * math.sin(_obliquity) * math.sin(l),
  );

  /// Azimuth measured from south, westward positive (suncalc convention).
  static double _azimuthFromSouth(double h, double phi, double dec) =>
      math.atan2(
        math.sin(h),
        math.cos(h) * math.sin(phi) - math.tan(dec) * math.cos(phi),
      );

  static double _altitude(double h, double phi, double dec) => math.asin(
    math.sin(phi) * math.sin(dec) + math.cos(phi) * math.cos(dec) * math.cos(h),
  );

  static double _siderealTime(double d, double lw) =>
      Angles.toRadians(280.16 + 360.9856235 * d) - lw;

  static ({double ra, double dec}) _sunCoords(double d) {
    final m = Angles.toRadians(357.5291 + 0.98560028 * d);
    final c = Angles.toRadians(
      1.9148 * math.sin(m) + 0.02 * math.sin(2 * m) + 0.0003 * math.sin(3 * m),
    );
    final p = Angles.toRadians(102.9372);
    final l = m + c + p + math.pi;
    return (ra: _rightAscension(l, 0), dec: _declination(l, 0));
  }

  static ({double ra, double dec, double dist}) _moonCoords(double d) {
    final bigL = Angles.toRadians(218.316 + 13.176396 * d);
    final m = Angles.toRadians(134.963 + 13.064993 * d);
    final f = Angles.toRadians(93.272 + 13.229350 * d);
    final l = bigL + Angles.toRadians(6.289 * math.sin(m));
    final b = Angles.toRadians(5.128 * math.sin(f));
    final dt = 385001 - 20905 * math.cos(m);
    return (ra: _rightAscension(l, b), dec: _declination(l, b), dist: dt);
  }

  /// Atmospheric refraction correction for an apparent altitude [h] in
  /// radians, after Sæmundsson.
  static double _refraction(double h) {
    final clamped = h < 0 ? 0.0 : h;
    return 0.0002967 / math.tan(clamped + 0.00312536 / (clamped + 0.08901179));
  }

  static SkyPosition _toCompass(double azFromSouth, double altRad) =>
      SkyPosition(
        azimuth: Angles.normalize(Angles.toDegrees(azFromSouth) + 180),
        altitude: Angles.toDegrees(altRad),
      );

  static SkyPosition sun(GeoPoint at, DateTime when) {
    final lw = Angles.toRadians(-at.longitude);
    final phi = Angles.toRadians(at.latitude);
    final d = _toDays(when);
    final c = _sunCoords(d);
    final h = _siderealTime(d, lw) - c.ra;
    return _toCompass(
      _azimuthFromSouth(h, phi, c.dec),
      _altitude(h, phi, c.dec),
    );
  }

  static SkyPosition moon(GeoPoint at, DateTime when) {
    final lw = Angles.toRadians(-at.longitude);
    final phi = Angles.toRadians(at.latitude);
    final d = _toDays(when);
    final c = _moonCoords(d);
    final h = _siderealTime(d, lw) - c.ra;
    var alt = _altitude(h, phi, c.dec);
    alt += _refraction(alt);
    return _toCompass(_azimuthFromSouth(h, phi, c.dec), alt);
  }

  static MoonIllumination moonIllumination(DateTime when) {
    final d = _toDays(when);
    final s = _sunCoords(d);
    final m = _moonCoords(d);
    const sdist = 149598000.0;
    final phi = math.acos(
      math.sin(s.dec) * math.sin(m.dec) +
          math.cos(s.dec) * math.cos(m.dec) * math.cos(s.ra - m.ra),
    );
    final inc = math.atan2(
      sdist * math.sin(phi),
      m.dist - sdist * math.cos(phi),
    );
    final angle = math.atan2(
      math.cos(s.dec) * math.sin(s.ra - m.ra),
      math.sin(s.dec) * math.cos(m.dec) -
          math.cos(s.dec) * math.sin(m.dec) * math.cos(s.ra - m.ra),
    );
    return MoonIllumination(
      fraction: (1 + math.cos(inc)) / 2,
      phase: 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / math.pi,
    );
  }
}
