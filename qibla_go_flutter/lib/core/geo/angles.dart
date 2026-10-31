import 'dart:math' as math;

/// Angle helpers that treat 359° and 1° as two degrees apart.
///
/// Kept in the app (rather than reaching into a package's internals) because
/// the dial animation, alignment hysteresis and tests all depend on them.
abstract final class Angles {
  /// Wraps any angle into `[0, 360)`.
  static double normalize(double degrees) {
    if (degrees.isNaN || degrees.isInfinite) return 0;
    final wrapped = degrees % 360;
    return wrapped < 0 ? wrapped + 360 : wrapped;
  }

  /// Shortest signed rotation from [from] to [to], in `(-180, 180]`.
  /// Positive means clockwise.
  static double delta(double from, double to) {
    var difference = normalize(to) - normalize(from);
    if (difference > 180) difference -= 360;
    if (difference <= -180) difference += 360;
    return difference;
  }

  /// Absolute shortest distance between two angles, in `[0, 180]`.
  static double distance(double a, double b) => delta(a, b).abs();

  static double toRadians(double degrees) => degrees * math.pi / 180;

  static double toDegrees(double radians) => radians * 180 / math.pi;
}

/// Exponential low-pass filter for a heading that never takes the long way
/// round when crossing north.
///
/// The angle is unwrapped (359° followed by 1° becomes 359° followed by
/// 361°) before filtering, then wrapped again on the way out.
final class HeadingSmoother {
  HeadingSmoother({this.alpha = 0.25})
    : assert(alpha > 0 && alpha <= 1, 'alpha must be in (0, 1]');

  /// Fraction of the remaining error removed per sample. 1 disables
  /// smoothing.
  final double alpha;

  double _unwrapped = 0;
  double _filtered = 0;
  bool _hasReading = false;

  bool get hasReading => _hasReading;

  /// Current smoothed heading in `[0, 360)`.
  double get value => Angles.normalize(_filtered);

  double add(double heading) {
    if (!_hasReading) {
      _hasReading = true;
      _unwrapped = heading;
      _filtered = heading;
      return value;
    }
    _unwrapped += Angles.delta(_unwrapped, heading);
    _filtered += (_unwrapped - _filtered) * alpha;
    return value;
  }

  void reset() {
    _hasReading = false;
    _unwrapped = 0;
    _filtered = 0;
  }
}

/// Tracks an unwrapped target for an animated rotation.
///
/// Feeding wrapped headings (0..360) in, this hands out a continuous angle so
/// that a tween from 359° to 1° moves two degrees instead of spinning the
/// dial almost a full turn.
final class UnwrappedAngle {
  double _value = 0;
  bool _hasValue = false;

  double get value => _value;

  double update(double wrappedDegrees) {
    if (!_hasValue) {
      _hasValue = true;
      _value = Angles.normalize(wrappedDegrees);
      return _value;
    }
    _value += Angles.delta(_value, wrappedDegrees);
    return _value;
  }
}
