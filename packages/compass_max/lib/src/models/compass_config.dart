/// How hard to smooth the heading before it reaches your dial.
///
/// Smoothing lives here rather than in a wrapper package, because a shaky
/// needle is what pushed everyone to wrap the existing compass plugins.
enum CompassSmoothing {
  /// Raw platform heading. Use for tests or your own filter.
  none,

  /// Barely filtered, follows fast turns closely.
  light,

  /// The default. Steady dial, no visible lag.
  medium,

  /// Very steady, noticeably behind fast turns. Good for the geomagnetic
  /// chain on cheap devices.
  heavy;

  /// Low pass coefficient applied to the unwrapped angle.
  double get alpha {
    switch (this) {
      case CompassSmoothing.none:
        return 1;
      case CompassSmoothing.light:
        return 0.5;
      case CompassSmoothing.medium:
        return 0.25;
      case CompassSmoothing.heavy:
        return 0.12;
    }
  }
}

/// The numbers behind the verdicts.
///
/// The interference defaults come from the physics: the Earth's field is
/// 25–65 µT depending on latitude, so a reading far outside that, or far from
/// what the World Magnetic Model predicts for the user's coordinates, means
/// something magnetic is nearby.
class CompassThresholds {
  const CompassThresholds({
    this.mildDeviationMicroTesla = 10,
    this.severeDeviationMicroTesla = 25,
    this.mildAbsoluteRange = const (25.0, 65.0),
    this.severeAbsoluteRange = const (20.0, 70.0),
    this.movingFastSpeedMetersPerSecond = 4.2,
    this.appearAfter = const Duration(milliseconds: 1500),
    this.clearAfter = const Duration(milliseconds: 1000),
    this.calibrationAccuracyDegreesAbove = 25,
    this.tiltDegreesAbove = 25,
  });

  /// Deviation from the predicted field strength that counts as mild.
  final double mildDeviationMicroTesla;

  /// Deviation from the predicted field strength that counts as severe.
  final double severeDeviationMicroTesla;

  /// Fallback band used when the platform cannot predict the local field,
  /// which is the case on iOS.
  final (double, double) mildAbsoluteRange;

  final (double, double) severeAbsoluteRange;

  /// Roughly 15 km/h. Above this the user is travelling, not walking.
  final double movingFastSpeedMetersPerSecond;

  /// How long a condition must hold before it is shown. Stops a single spike
  /// from flashing a warning at the user.
  final Duration appearAfter;

  /// How long a condition must be gone before it stops being shown.
  final Duration clearAfter;

  /// Reported heading error above this asks for calibration.
  final double calibrationAccuracyDegreesAbove;

  /// Tilt away from flat above this asks the user to level the phone.
  final double tiltDegreesAbove;
}
