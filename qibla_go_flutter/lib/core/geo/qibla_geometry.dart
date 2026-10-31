import 'package:qibla_math/qibla_math.dart' as qm;

import 'angles.dart';
import 'geo_point.dart';

/// The Kaaba, 21°25′21″N 39°49′34.2″E (Wikidata Q29466). Re-exported so the
/// app has a single named constant for it.
final GeoPoint kaaba = GeoPoint(
  latitude: qm.kaabaLatitude,
  longitude: qm.kaabaLongitude,
);

/// Everything the needle needs about one location at one moment.
///
/// Pure data, computed once per location change by [QiblaGeometry.compute]
/// and never on the sensor hot path. The numbers in here are what believers
/// will face when they pray, so the computation is delegated to
/// `qibla_math`, whose bearings and WMM2025 declination are verified against
/// published values and NOAA's official test points, and cross-checked
/// again by this project's own tests in `test/core/geo`.
final class QiblaGeometry {
  const QiblaGeometry({
    required this.origin,
    required this.bearingFromTrueNorth,
    required this.distanceKm,
    required this.declination,
    required this.declinationIsExtrapolated,
    required this.computedAt,
  });

  /// Computes the geometry for [origin] at [when].
  ///
  /// Throws nothing: outside the WMM2025 validity period (2025.0–2030.0) the
  /// declination is extrapolated and flagged, so a user with an old build in
  /// 2031 still gets a direction, plus a nudge to update.
  factory QiblaGeometry.compute(GeoPoint origin, DateTime when) {
    final year = qm.decimalYear(when);
    final model = qm.WorldMagneticModel.wmm2025;
    final field = model.calculate(
      latitude: origin.latitude,
      longitude: origin.longitude,
      decimalYear: year,
      allowOutsideValidityPeriod: true,
    );
    return QiblaGeometry(
      origin: origin,
      bearingFromTrueNorth: Angles.normalize(
        qm.qiblaBearing(origin.latitude, origin.longitude),
      ),
      distanceKm: qm.qiblaDistanceKm(origin.latitude, origin.longitude),
      declination: field.declination,
      declinationIsExtrapolated: field.isOutsideValidityPeriod,
      computedAt: when,
    );
  }

  final GeoPoint origin;

  /// Initial great-circle bearing to the Kaaba, degrees clockwise from
  /// **true** north, `[0, 360)`.
  final double bearingFromTrueNorth;

  /// Great-circle distance to the Kaaba in kilometres.
  final double distanceKm;

  /// Magnetic declination at [origin] and [computedAt], degrees, positive
  /// east. `true = magnetic + declination`.
  final double declination;

  /// True when [computedAt] is outside the model's validity period.
  final bool declinationIsExtrapolated;

  final DateTime computedAt;

  /// Bearing to the Kaaba from **magnetic** north, for people reading a
  /// physical compass.
  double get bearingFromMagneticNorth =>
      Angles.normalize(bearingFromTrueNorth - declination);

  /// Converts a magnetic heading to a true heading at this location.
  double trueHeadingFrom(double magneticHeading) =>
      Angles.normalize(magneticHeading + declination);

  /// Angle to draw the qibla marker at, clockwise from the top of the
  /// device, given where the device points (true heading).
  double needleAngleFor(double trueHeading) =>
      Angles.normalize(bearingFromTrueNorth - trueHeading);

  /// Signed turn from the device heading to the qibla, `(-180, 180]`.
  /// Positive means turn clockwise (right).
  double offsetFor(double trueHeading) =>
      Angles.delta(trueHeading, bearingFromTrueNorth);

  /// Inside roughly 100 m of the Kaaba a bearing is meaningless; the app
  /// shows "you are here" instead of a needle.
  bool get isAtKaaba => distanceKm < 0.1;

  /// Whether a stored geometry is still good for [point] at [when].
  ///
  /// Bearings change by about 0.01° per kilometre far from Makkah, and
  /// declination drifts by well under a tenth of a degree per month, so
  /// recomputation is only needed after real movement or a long time.
  bool isFreshFor(GeoPoint point, DateTime when) {
    final movedMeters = origin.distanceMetersTo(point);
    final age = when.difference(computedAt);
    return movedMeters < 250 && age < const Duration(days: 7);
  }
}
