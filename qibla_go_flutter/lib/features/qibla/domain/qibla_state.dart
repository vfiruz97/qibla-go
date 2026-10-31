import '../../../core/compass/compass_reading.dart';
import '../../../core/compass/compass_source.dart';
import '../../../core/geo/qibla_geometry.dart';
import '../../../core/location/location_models.dart';

/// Location as the qibla feature sees it.
final class LocationState {
  const LocationState({
    this.fix,
    this.problem = LocationProblem.none,
    this.isRefreshing = false,
  });

  /// Best known position, possibly cached or manual. Null until the user has
  /// ever granted location or typed one in.
  final LocationFix? fix;

  /// Why the last refresh produced nothing. Soft when [fix] is non-null.
  final LocationProblem problem;

  final bool isRefreshing;

  bool get hasFix => fix != null;

  LocationState copyWith({
    LocationFix? fix,
    bool clearFix = false,
    LocationProblem? problem,
    bool? isRefreshing,
  }) => LocationState(
    fix: clearFix ? null : (fix ?? this.fix),
    problem: problem ?? this.problem,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );
}

enum CompassPhase {
  /// Asking the platform what it can do.
  checking,

  /// No usable sensor, or permission missing. See [CompassState.availability].
  unavailable,

  /// Subscribed but nothing has arrived yet.
  waiting,

  /// Readings flowing.
  active,

  /// Readings stopped arriving.
  stale,

  /// Sensors are released because the app is in the background.
  paused,
}

final class CompassState {
  const CompassState({
    this.availability,
    this.reading,
    this.isStale = false,
    this.isPaused = false,
    this.error,
  });

  final CompassAvailability? availability;
  final CompassReading? reading;
  final bool isStale;
  final bool isPaused;
  final Object? error;

  CompassPhase get phase {
    if (isPaused) return CompassPhase.paused;
    final availability = this.availability;
    if (availability == null) return CompassPhase.checking;
    if (!availability.isAvailable) return CompassPhase.unavailable;
    if (reading == null) return CompassPhase.waiting;
    return isStale ? CompassPhase.stale : CompassPhase.active;
  }

  CompassState copyWith({
    CompassAvailability? availability,
    CompassReading? reading,
    bool clearReading = false,
    bool? isStale,
    bool? isPaused,
    Object? error,
    bool clearError = false,
  }) => CompassState(
    availability: availability ?? this.availability,
    reading: clearReading ? null : (reading ?? this.reading),
    isStale: isStale ?? this.isStale,
    isPaused: isPaused ?? this.isPaused,
    error: clearError ? null : (error ?? this.error),
  );
}

/// How far the needle can be believed right now.
enum NeedleTrust {
  /// Show the needle normally.
  trusted,

  /// Show it, with a visible warning (calibration, tilt, browser source).
  degraded,

  /// Hide the direction: it is wrong, not merely imprecise.
  blocked,
}

/// Decides [NeedleTrust] from a reading. Pure, so it is unit tested.
NeedleTrust needleTrustFor(CompassReading? reading) {
  if (reading == null) return NeedleTrust.blocked;
  if (reading.issues.contains(CompassIssue.magneticInterference) ||
      reading.issues.contains(CompassIssue.movingFast)) {
    return NeedleTrust.blocked;
  }
  if (reading.issues.isNotEmpty) return NeedleTrust.degraded;
  if (reading.sourceKind == CompassSourceKind.web) {
    return NeedleTrust.degraded;
  }
  final accuracy = reading.accuracyDegrees;
  if (accuracy != null && accuracy > 15) return NeedleTrust.degraded;
  if (reading.confidence < 40) return NeedleTrust.degraded;
  return NeedleTrust.trusted;
}

/// Everything the dial draws, derived once per reading.
final class QiblaSnapshot {
  const QiblaSnapshot({
    required this.geometry,
    required this.reading,
    required this.trueHeading,
    required this.needleAngle,
    required this.offset,
    required this.trust,
  });

  final QiblaGeometry geometry;
  final CompassReading? reading;

  /// Device heading from true north after WMM2025 declination, or null when
  /// there is no reading.
  final double? trueHeading;

  /// Where to draw the qibla, clockwise from the top of the device.
  final double? needleAngle;

  /// Signed turn to face the qibla, `(-180, 180]`, positive = clockwise.
  final double? offset;

  final NeedleTrust trust;

  static QiblaSnapshot from(QiblaGeometry geometry, CompassReading? reading) {
    if (reading == null) {
      return QiblaSnapshot(
        geometry: geometry,
        reading: null,
        trueHeading: null,
        needleAngle: null,
        offset: null,
        trust: NeedleTrust.blocked,
      );
    }
    final trueHeading = geometry.trueHeadingFrom(reading.magneticHeading);
    return QiblaSnapshot(
      geometry: geometry,
      reading: reading,
      trueHeading: trueHeading,
      needleAngle: geometry.needleAngleFor(trueHeading),
      offset: geometry.offsetFor(trueHeading),
      trust: needleTrustFor(reading),
    );
  }
}

/// Hysteresis for the "facing the qibla" moment so the celebration does not
/// flicker at the boundary. Enters inside [enterDegrees], leaves only past
/// [exitDegrees].
final class AlignmentTracker {
  AlignmentTracker({this.enterDegrees = 3, this.exitDegrees = 6})
    : assert(exitDegrees >= enterDegrees);

  final double enterDegrees;
  final double exitDegrees;
  bool _aligned = false;

  bool get isAligned => _aligned;

  /// Feeds the latest signed offset (null when the needle is hidden) and
  /// returns whether the user is aligned now.
  bool update(double? offset, {NeedleTrust trust = NeedleTrust.trusted}) {
    if (offset == null || trust == NeedleTrust.blocked) {
      _aligned = false;
      return false;
    }
    final distance = offset.abs();
    if (_aligned) {
      if (distance > exitDegrees) _aligned = false;
    } else {
      if (distance <= enterDegrees) _aligned = true;
    }
    return _aligned;
  }
}
