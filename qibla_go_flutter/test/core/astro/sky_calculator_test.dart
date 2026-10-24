import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/astro/sky_position.dart';
import 'package:qibla_go_flutter/core/geo/angles.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';

void main() {
  group('SkyCalculator.sun', () {
    // Reference: suncalc test suite, 2013-03-05T00:00:00Z at 50.5N 30.5E:
    // azimuth -2.5003175907 rad from south, altitude -0.7000406839 rad.
    test('matches the suncalc reference point', () {
      final s = SkyCalculator.sun(
        GeoPoint(latitude: 50.5, longitude: 30.5),
        DateTime.utc(2013, 3, 5),
      );
      final expectedAz = Angles.normalize(
        Angles.toDegrees(-2.5003175907168385) + 180,
      );
      expect(s.azimuth, closeTo(expectedAz, 0.01));
      expect(s.altitude, closeTo(Angles.toDegrees(-0.7000406838781611), 0.01));
    });

    // Independent check: at local solar noon on an equinox the sun is due
    // south (northern hemisphere) and its altitude is 90° - latitude.
    // 2026-03-20 14:46 UTC is the equinox; solar noon at 0° longitude is
    // about 12:07 UTC that day (equation of time ≈ -7 min).
    test('is due south at solar noon on the equinox at Greenwich', () {
      final s = SkyCalculator.sun(
        GeoPoint(latitude: 51.4779, longitude: 0),
        DateTime.utc(2026, 3, 20, 12, 7),
      );
      expect(s.azimuth, closeTo(180, 1.0));
      expect(s.altitude, closeTo(90 - 51.4779, 0.6));
    });

    test('rises in the east and sets in the west (Dushanbe, 2026-06-21)', () {
      final here = GeoPoint(latitude: 38.5598, longitude: 68.787);
      // Dushanbe is UTC+5: 06:00 local = 01:00 UTC, 19:00 local = 14:00 UTC.
      final morning = SkyCalculator.sun(here, DateTime.utc(2026, 6, 21, 1));
      final evening = SkyCalculator.sun(here, DateTime.utc(2026, 6, 21, 14));
      expect(morning.azimuth, inInclusiveRange(45, 100));
      expect(morning.isAboveHorizon, isTrue);
      expect(evening.azimuth, inInclusiveRange(260, 315));
      expect(evening.isAboveHorizon, isTrue);
      final night = SkyCalculator.sun(here, DateTime.utc(2026, 6, 21, 20));
      expect(night.isAboveHorizon, isFalse);
    });
  });

  group('SkyCalculator.moon', () {
    // Reference: suncalc test suite, same instant and place:
    // azimuth -0.9783999522 rad, altitude 0.0145514822 rad.
    test('matches the suncalc reference point', () {
      final m = SkyCalculator.moon(
        GeoPoint(latitude: 50.5, longitude: 30.5),
        DateTime.utc(2013, 3, 5),
      );
      final expectedAz = Angles.normalize(
        Angles.toDegrees(-0.9783999522438226) + 180,
      );
      expect(m.azimuth, closeTo(expectedAz, 0.01));
      expect(m.altitude, closeTo(Angles.toDegrees(0.014551482243108753), 0.01));
    });

    test('illumination matches the suncalc reference', () {
      final i = SkyCalculator.moonIllumination(DateTime.utc(2013, 3, 5));
      expect(i.fraction, closeTo(0.4848068202456373, 1e-6));
      expect(i.phase, closeTo(0.7548368838538762, 1e-6));
    });

    test('full moon of 2026-03-03 is nearly fully lit', () {
      // Full moon 2026-03-03 11:38 UTC (published almanac value).
      final i = SkyCalculator.moonIllumination(
        DateTime.utc(2026, 3, 3, 11, 38),
      );
      expect(i.fraction, greaterThan(0.99));
      expect(i.phase, closeTo(0.5, 0.01));
    });
  });
}
