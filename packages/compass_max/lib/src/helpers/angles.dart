/// Angle helpers that treat 359° and 1° as two degrees apart.
class Angles {
  const Angles._();

  /// Wraps any angle into `0..360`.
  static double normalize(double degrees) {
    final double wrapped = degrees % 360;

    return wrapped < 0 ? wrapped + 360 : wrapped;
  }

  /// Shortest signed rotation from [from] to [to], in `-180..180`.
  static double delta(double from, double to) {
    final double difference = normalize(to) - normalize(from);

    if (difference > 180) {
      return difference - 360;
    }

    if (difference < -180) {
      return difference + 360;
    }

    return difference;
  }

  /// Absolute shortest distance between two angles, in `0..180`.
  static double distance(double from, double to) {
    return delta(from, to).abs();
  }
}
