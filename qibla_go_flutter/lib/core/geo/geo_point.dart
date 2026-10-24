import 'dart:math' as math;

/// A latitude/longitude pair in degrees on WGS-84.
///
/// Immutable value type shared by location, geometry and persistence code.
/// Construction validates the ranges so a bad coordinate fails loudly at the
/// boundary instead of silently pointing the needle somewhere wrong.
final class GeoPoint {
  GeoPoint({required this.latitude, required this.longitude}) {
    if (latitude.isNaN || latitude < -90 || latitude > 90) {
      throw ArgumentError.value(latitude, 'latitude', 'must be in -90..90');
    }
    if (longitude.isNaN || longitude < -180 || longitude > 180) {
      throw ArgumentError.value(
        longitude,
        'longitude',
        'must be in -180..180',
      );
    }
  }

  /// Parses `latitude` and `longitude` from a map, or returns null when the
  /// map does not hold a valid pair. Used for persisted locations.
  static GeoPoint? tryFromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    final lat = json['latitude'];
    final lon = json['longitude'];
    if (lat is! num || lon is! num) return null;
    try {
      return GeoPoint(latitude: lat.toDouble(), longitude: lon.toDouble());
    } on ArgumentError {
      return null;
    }
  }

  final double latitude;
  final double longitude;

  Map<String, Object?> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  /// Approximate ground distance to [other] in metres (haversine, sphere).
  ///
  /// Only used to decide whether the user has moved enough to matter, so a
  /// spherical approximation is more than enough here.
  double distanceMetersTo(GeoPoint other) {
    const earthRadius = 6371008.8;
    final dLat = _rad(other.latitude - latitude);
    final dLon = _rad(other.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(latitude)) *
            math.cos(_rad(other.latitude)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadius * math.asin(math.min(1, math.sqrt(a)));
  }

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() =>
      'GeoPoint(${latitude.toStringAsFixed(5)}, '
      '${longitude.toStringAsFixed(5)})';
}
