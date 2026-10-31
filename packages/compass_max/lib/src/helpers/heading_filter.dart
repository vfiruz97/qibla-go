import '../models/compass_config.dart';
import 'angles.dart';

/// Low pass filter for a heading.
///
/// The angle is unwrapped before filtering, so crossing north does not send
/// the needle the long way round.
class HeadingFilter {
  HeadingFilter({
    required this.smoothing,
  });

  final CompassSmoothing smoothing;

  double _unwrapped = 0;
  double _filtered = 0;
  bool _hasReading = false;

  /// Last filtered heading in `0..360`.
  double get value {
    return Angles.normalize(_filtered);
  }

  bool get hasReading {
    return _hasReading;
  }

  double add(double heading) {
    if (!_hasReading) {
      _hasReading = true;
      _unwrapped = heading;
      _filtered = heading;

      return value;
    }

    _unwrapped += Angles.delta(_unwrapped, heading);
    _filtered += (_unwrapped - _filtered) * smoothing.alpha;

    return value;
  }

  void reset() {
    _hasReading = false;
    _unwrapped = 0;
    _filtered = 0;
  }
}

/// Tracks how much the heading has been jumping around lately.
///
/// A calibrated compass sitting still barely moves. One being thrown off by
/// a nearby magnet jitters even when the phone does not, which is a signal
/// the platform accuracy value alone does not give you.
class HeadingStability {
  HeadingStability({
    this.window = 10,
  });

  final int window;

  final List<double> _deltas = <double>[];
  double? _previous;

  /// Mean absolute change per sample, in degrees.
  double get jitter {
    if (_deltas.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final double delta in _deltas) {
      total += delta.abs();
    }

    return total / _deltas.length;
  }

  void add(double heading) {
    final double? previous = _previous;
    _previous = heading;

    if (previous == null) {
      return;
    }

    _deltas.add(Angles.delta(previous, heading));

    if (_deltas.length > window) {
      _deltas.removeAt(0);
    }
  }

  void reset() {
    _deltas.clear();
    _previous = null;
  }
}
