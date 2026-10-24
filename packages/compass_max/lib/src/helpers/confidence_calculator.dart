import '../models/compass_source.dart';
import '../models/compass_condition.dart';

/// Turns four separate signals into one `0..100` number.
///
/// No single input is enough on its own: Android's accuracy level is coarse
/// and often stale, iOS reports a handful of fixed values, and both can say
/// "high" while a magnet points the needle at the wrong wall. Multiplying the
/// platform estimate by field health and by observed stability catches the
/// cases each one misses.
class ConfidenceCalculator {
  const ConfidenceCalculator();

  int calculate({
    required double? accuracyDegrees,
    required CompassSensorAccuracy sensorAccuracy,
    required CompassInterference interference,
    required double jitter,
    required double pitch,
  }) {
    double score = _fromAccuracy(
      accuracyDegrees: accuracyDegrees,
      sensorAccuracy: sensorAccuracy,
    );

    score *= _fieldFactor(interference);
    score *= _stabilityFactor(jitter);
    score *= _tiltFactor(pitch);

    return score.round().clamp(0, 100);
  }

  /// Degrees of error map linearly onto the score: 5° or better is perfect,
  /// 45° or worse is useless.
  double _fromAccuracy({
    required double? accuracyDegrees,
    required CompassSensorAccuracy sensorAccuracy,
  }) {
    if (accuracyDegrees != null && accuracyDegrees >= 0) {
      final double clamped = accuracyDegrees.clamp(5, 45);

      return 100 - ((clamped - 5) / 40) * 100;
    }

    switch (sensorAccuracy) {
      case CompassSensorAccuracy.high:
        return 90;
      case CompassSensorAccuracy.medium:
        return 65;
      case CompassSensorAccuracy.low:
        return 35;
      case CompassSensorAccuracy.unreliable:
        return 10;
      case CompassSensorAccuracy.unknown:
        return 50;
    }
  }

  double _fieldFactor(CompassInterference interference) {
    switch (interference) {
      case CompassInterference.none:
        return 1;
      case CompassInterference.mild:
        return 0.7;
      case CompassInterference.severe:
        return 0.25;
      case CompassInterference.unknown:
        return 0.9;
    }
  }

  /// Below 1° of movement per sample the needle is steady; past 15° it is
  /// swinging on its own.
  double _stabilityFactor(double jitter) {
    if (jitter <= 1) {
      return 1;
    }

    if (jitter >= 15) {
      return 0.6;
    }

    return 1 - ((jitter - 1) / 14) * 0.4;
  }

  /// A phone held upright is harder to read a heading from, but not by much
  /// on a fused source, so the penalty stays small.
  double _tiltFactor(double pitch) {
    final double tilt = pitch.abs();

    if (tilt <= 25) {
      return 1;
    }

    if (tilt >= 75) {
      return 0.85;
    }

    return 1 - ((tilt - 25) / 50) * 0.15;
  }
}
