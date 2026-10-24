/// What the compass has noticed about the conditions it is reading in.
///
/// Ordered by how much each one distorts the heading, so `issues.first` is
/// the one worth a sentence of UI.
enum CompassIssue {
  /// The magnetic field here is not the Earth's: metal or a magnet nearby.
  /// The heading is wrong rather than imprecise, so the dial is dimmed.
  magneticInterference,

  /// Travelling faster than walking pace, usually a vehicle.
  movingFast,

  /// The platform is unsure of its own calibration. A figure of eight
  /// usually fixes it.
  needsCalibration,

  /// The device is tilted far enough that readings degrade.
  deviceNotFlat,
}

/// Where a reading came from. Diagnostics only; the heading is normalised
/// regardless of source.
enum CompassSourceKind {
  /// Android/iOS sensors through the vendored `compass_max` plugin.
  native,

  /// Browser `deviceorientation` events. Lower accuracy, no interference
  /// detection.
  web,

  /// A fake heading for development. Never available in release builds.
  simulated,
}

/// One compass sample, platform-agnostic.
///
/// [magneticHeading] is the only heading the app trusts from the platform.
/// True north is always derived in the app from WMM2025 declination so every
/// platform and OS version agrees on it. [platformTrueHeading] is kept for
/// diagnostics so disagreements can be seen in the details sheet.
final class CompassReading {
  const CompassReading({
    required this.magneticHeading,
    required this.timestamp,
    required this.sourceKind,
    required this.sourceLabel,
    this.platformTrueHeading,
    this.accuracyDegrees,
    this.confidence = 50,
    this.issues = const [],
    this.pitchDegrees = 0,
    this.rollDegrees = 0,
    this.fieldStrengthMicroTesla,
    this.expectedFieldStrengthMicroTesla,
  });

  /// Degrees clockwise from magnetic north, `[0, 360)`, already smoothed.
  final double magneticHeading;

  /// Degrees clockwise from true north as the platform reports it, when it
  /// does. Diagnostics only.
  final double? platformTrueHeading;

  /// Platform estimate of heading error in degrees, when it reports one.
  final double? accuracyDegrees;

  /// `0..100`, combining platform accuracy, field health, stability and tilt.
  final int confidence;

  /// Most distorting first. Empty means nothing to report.
  final List<CompassIssue> issues;

  /// Degrees away from lying flat.
  final double pitchDegrees;
  final double rollDegrees;

  /// Measured and predicted field magnitude, when available.
  final double? fieldStrengthMicroTesla;
  final double? expectedFieldStrengthMicroTesla;

  final DateTime timestamp;
  final CompassSourceKind sourceKind;

  /// Human readable sensor chain, e.g. `rotationVector`.
  final String sourceLabel;

  CompassIssue? get topIssue => issues.isEmpty ? null : issues.first;

  bool get hasSevereInterference =>
      issues.contains(CompassIssue.magneticInterference);

  @override
  String toString() =>
      'CompassReading(magnetic: ${magneticHeading.toStringAsFixed(1)}, '
      'accuracy: $accuracyDegrees, confidence: $confidence, issues: $issues, '
      'source: $sourceLabel)';
}
