import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/geo/angles.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';

void main() {
  group('Angles', () {
    test('normalize wraps into [0, 360)', () {
      expect(Angles.normalize(0), 0);
      expect(Angles.normalize(360), 0);
      expect(Angles.normalize(-1), 359);
      expect(Angles.normalize(725), 5);
      expect(Angles.normalize(double.nan), 0);
    });

    test('delta is the shortest signed rotation', () {
      expect(Angles.delta(350, 10), 20);
      expect(Angles.delta(10, 350), -20);
      expect(Angles.delta(0, 180), 180);
      expect(Angles.delta(90, 270), 180);
      expect(Angles.delta(270, 90), 180);
      expect(Angles.delta(45, 45), 0);
    });

    test('distance is symmetric', () {
      expect(Angles.distance(359, 1), 2);
      expect(Angles.distance(1, 359), 2);
    });
  });

  group('HeadingSmoother', () {
    test('first sample passes through', () {
      final s = HeadingSmoother(alpha: 0.25);
      expect(s.add(123), 123);
    });

    test('never takes the long way round across north', () {
      final s = HeadingSmoother(alpha: 0.5);
      s.add(358);
      final next = s.add(2);
      // Halfway between 358 and 2 the short way is 0, not 180.
      expect(Angles.distance(next, 0), lessThan(1e-9));
    });

    test('converges to a held heading', () {
      final s = HeadingSmoother(alpha: 0.25);
      s.add(0);
      double v = 0;
      for (var i = 0; i < 60; i++) {
        v = s.add(90);
      }
      expect(v, closeTo(90, 0.01));
    });

    test('alpha 1 disables smoothing', () {
      final s = HeadingSmoother(alpha: 1);
      s.add(10);
      expect(s.add(200), 200);
    });
  });

  group('UnwrappedAngle', () {
    test('accumulates across the seam', () {
      final u = UnwrappedAngle();
      expect(u.update(350), 350);
      expect(u.update(10), 370);
      expect(u.update(350), 350);
      expect(u.update(200), 200);
      expect(u.update(170), 170);
      expect(u.update(10), 10);
      expect(u.update(350), -10);
    });
  });

  group('GeoPoint', () {
    test('rejects out-of-range coordinates', () {
      expect(() => GeoPoint(latitude: 91, longitude: 0), throwsArgumentError);
      expect(() => GeoPoint(latitude: 0, longitude: -181), throwsArgumentError);
      expect(
        () => GeoPoint(latitude: double.nan, longitude: 0),
        throwsArgumentError,
      );
    });

    test('round-trips through json and rejects garbage', () {
      final p = GeoPoint(latitude: 38.5598, longitude: 68.787);
      expect(GeoPoint.tryFromJson(p.toJson()), p);
      expect(GeoPoint.tryFromJson({'latitude': 'x'}), isNull);
      expect(GeoPoint.tryFromJson({'latitude': 100, 'longitude': 0}), isNull);
      expect(GeoPoint.tryFromJson(null), isNull);
    });

    test('distance is roughly right', () {
      final a = GeoPoint(latitude: 0, longitude: 0);
      final b = GeoPoint(latitude: 0, longitude: 1);
      expect(a.distanceMetersTo(b), closeTo(111195, 50));
    });
  });
}
