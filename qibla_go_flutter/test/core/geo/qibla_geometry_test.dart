import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/geo/qibla_geometry.dart';

/// Published qibla bearings from sources independent of the package we
/// delegate to (which itself is tested against al-habib.info and Shaukat).
///
/// Wikipedia "Qibla" (retrieved 2026-10-24) gives:
/// - Yogyakarta (7.801389°S, 110.364444°E): "approximately 295°".
/// - Washington, D.C.: great-circle "56°33′" = 56.55°.
/// - San Francisco: great-circle "18°51′05″" = 18.851°.
/// - Cairo: modern qibla "135°" (rounded).
/// - Marrakesh: "91°"; Tangier: "97°".
/// City coordinates below are city centres; the article gives none for most,
/// so those tolerances allow for the city's extent (about ±0.5°).
final _published =
    <({String name, double lat, double lon, double bearing, double tol})>[
      (
        name: 'Yogyakarta',
        lat: -7.801389,
        lon: 110.364444,
        bearing: 295.0,
        tol: 0.6,
      ),
      (
        name: 'Washington, D.C.',
        lat: 38.8977,
        lon: -77.0365,
        bearing: 56.55,
        tol: 0.5,
      ),
      (
        name: 'San Francisco',
        lat: 37.7749,
        lon: -122.4194,
        bearing: 18.851,
        tol: 0.5,
      ),
      // The article rounds Cairo to a whole number of degrees; the great-circle
      // value for the city centre is about 136.2°.
      (name: 'Cairo', lat: 30.0444, lon: 31.2357, bearing: 135.0, tol: 1.5),
      (name: 'Marrakesh', lat: 31.6295, lon: -7.9811, bearing: 91.0, tol: 0.8),
      (name: 'Tangier', lat: 35.7595, lon: -5.8340, bearing: 97.0, tol: 0.8),
    ];

/// Official NOAA WMM2025 test values (2025.0, height 0 km), from
/// `WMM2025_TEST_VALUES.txt`: declination D in degrees.
final _noaa = <({double lat, double lon, double declination})>[
  (lat: 80, lon: 0, declination: 1.28),
  (lat: 0, lon: 120, declination: -0.16),
  (lat: -80, lon: -120, declination: 68.78), // 240°E
];

void main() {
  final when = DateTime.utc(2026, 10, 24);

  group('QiblaGeometry bearing', () {
    for (final city in _published) {
      test('${city.name} matches the published value', () {
        final g = QiblaGeometry.compute(
          GeoPoint(latitude: city.lat, longitude: city.lon),
          when,
        );
        expect(g.bearingFromTrueNorth, closeTo(city.bearing, city.tol));
      });
    }

    test('is in [0, 360)', () {
      for (final lat in [-89.0, -45.0, 0.0, 45.0, 89.0]) {
        for (final lon in [-179.0, -90.0, 0.0, 90.0, 179.0]) {
          final g = QiblaGeometry.compute(
            GeoPoint(latitude: lat, longitude: lon),
            when,
          );
          expect(g.bearingFromTrueNorth, inInclusiveRange(0, 359.9999999));
        }
      }
    });

    test(
      'due east/west of the Kaaba on its latitude points nearly east/west',
      () {
        // Same latitude, slightly west: initial bearing a little north of east.
        final west = QiblaGeometry.compute(
          GeoPoint(latitude: kaaba.latitude, longitude: kaaba.longitude - 1),
          when,
        );
        expect(west.bearingFromTrueNorth, closeTo(90, 0.5));
        expect(west.bearingFromTrueNorth, lessThan(90));
        final east = QiblaGeometry.compute(
          GeoPoint(latitude: kaaba.latitude, longitude: kaaba.longitude + 1),
          when,
        );
        expect(east.bearingFromTrueNorth, closeTo(270, 0.5));
        expect(east.bearingFromTrueNorth, greaterThan(270));
      },
    );

    test('directly north of the Kaaba is 180, directly south is 0', () {
      final north = QiblaGeometry.compute(
        GeoPoint(latitude: 40, longitude: kaaba.longitude),
        when,
      );
      expect(north.bearingFromTrueNorth, closeTo(180, 1e-6));
      final south = QiblaGeometry.compute(
        GeoPoint(latitude: 0, longitude: kaaba.longitude),
        when,
      );
      expect(south.bearingFromTrueNorth, closeTo(0, 1e-6));
    });
  });

  group('QiblaGeometry distance', () {
    test('London is about 4 790 km from the Kaaba', () {
      final g = QiblaGeometry.compute(
        GeoPoint(latitude: 51.5085, longitude: -0.1257),
        when,
      );
      expect(g.distanceKm, closeTo(4794, 15));
    });

    test('isAtKaaba inside 100 m only', () {
      expect(QiblaGeometry.compute(kaaba, when).isAtKaaba, isTrue);
      final nearby = QiblaGeometry.compute(
        GeoPoint(latitude: kaaba.latitude + 0.0005, longitude: kaaba.longitude),
        when,
      );
      expect(nearby.isAtKaaba, isTrue);
      final city = QiblaGeometry.compute(
        GeoPoint(latitude: 21.4266, longitude: 39.8256),
        when,
      );
      expect(city.isAtKaaba, isFalse);
    });
  });

  group('QiblaGeometry declination (WMM2025)', () {
    for (final point in _noaa) {
      test('NOAA test value at ${point.lat}, ${point.lon}', () {
        final g = QiblaGeometry.compute(
          GeoPoint(latitude: point.lat, longitude: point.lon),
          DateTime.utc(2025, 1, 1),
        );
        expect(g.declination, closeTo(point.declination, 0.01));
        expect(g.declinationIsExtrapolated, isFalse);
      });
    }

    test('flags extrapolation after the validity period, never throws', () {
      final g = QiblaGeometry.compute(
        GeoPoint(latitude: 38.56, longitude: 68.79),
        DateTime.utc(2031, 6, 1),
      );
      expect(g.declinationIsExtrapolated, isTrue);
      expect(g.declination.isFinite, isTrue);
    });

    test('true heading = magnetic + declination, wrapped', () {
      final g = QiblaGeometry(
        origin: GeoPoint(latitude: 40, longitude: -74),
        bearingFromTrueNorth: 100,
        distanceKm: 1000,
        declination: -12.5,
        declinationIsExtrapolated: false,
        computedAt: when,
      );
      expect(g.trueHeadingFrom(5), closeTo(352.5, 1e-9));
      expect(g.trueHeadingFrom(200), closeTo(187.5, 1e-9));
      expect(g.bearingFromMagneticNorth, closeTo(112.5, 1e-9));
    });
  });

  group('needle math', () {
    final g = QiblaGeometry(
      origin: GeoPoint(latitude: 38.56, longitude: 68.79),
      bearingFromTrueNorth: 243,
      distanceKm: 3000,
      declination: 0,
      declinationIsExtrapolated: false,
      computedAt: when,
    );

    test('needle angle is bearing relative to the device top', () {
      expect(g.needleAngleFor(243), closeTo(0, 1e-9));
      expect(g.needleAngleFor(233), closeTo(10, 1e-9));
      expect(g.needleAngleFor(253), closeTo(350, 1e-9));
    });

    test('offset is the shortest signed turn', () {
      expect(g.offsetFor(243), closeTo(0, 1e-9));
      expect(g.offsetFor(220), closeTo(23, 1e-9)); // turn right
      expect(g.offsetFor(260), closeTo(-17, 1e-9)); // turn left
      expect(g.offsetFor(63), closeTo(180, 1e-9));
      expect(g.offsetFor(70), closeTo(173, 1e-9));
      expect(g.offsetFor(56), closeTo(-173, 1e-9));
    });
  });

  group('freshness', () {
    test('stale after moving 250 m or after a week', () {
      final origin = GeoPoint(latitude: 38.56, longitude: 68.79);
      final g = QiblaGeometry.compute(origin, when);
      expect(g.isFreshFor(origin, when.add(const Duration(days: 1))), isTrue);
      expect(
        g.isFreshFor(
          GeoPoint(latitude: 38.56 + 0.01, longitude: 68.79),
          when,
        ),
        isFalse,
      );
      expect(g.isFreshFor(origin, when.add(const Duration(days: 8))), isFalse);
    });
  });
}
