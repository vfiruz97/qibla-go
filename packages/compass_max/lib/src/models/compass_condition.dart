/// Everything the compass has noticed about the conditions it is reading in.
///
/// An empty list means there is nothing to report. What each entry means for
/// your UI is your call: a navigation app keeps drawing the heading inside a
/// car, a Qibla app dims it. The list is sorted by how much each one distorts
/// the heading, so `conditions.first` is the one worth a sentence.
enum CompassCondition {
  /// The magnetic field here does not match what the Earth's field should be,
  /// so the heading is wrong rather than merely imprecise.
  magneticInterference,

  /// The user is travelling faster than walking pace, which usually means a
  /// vehicle. Whether that matters is the app's call: a navigation app wants
  /// the heading anyway, a Qibla app does not.
  movingFast,

  /// The platform is unsure of its own calibration. A figure of eight usually
  /// fixes it, but not always.
  needsCalibration,

  /// The device is tilted far enough that readings degrade.
  phoneNotFlat,
}

/// The raw field verdict. Lives in diagnostics; the UI reads [CompassCondition].
enum CompassInterference {
  none,
  mild,
  severe,

  /// The device does not report field strength, so no verdict is possible.
  unknown,
}
