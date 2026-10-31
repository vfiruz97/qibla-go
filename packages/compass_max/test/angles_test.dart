import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Angles.normalize', () {
    test('wraps negatives into 0..360', () {
      expect(Angles.normalize(-10), closeTo(350, 0.001));
      expect(Angles.normalize(-370), closeTo(350, 0.001));
    });

    test('wraps values above a full turn', () {
      expect(Angles.normalize(370), closeTo(10, 0.001));
      expect(Angles.normalize(720), closeTo(0, 0.001));
    });
  });

  group('Angles.delta', () {
    test('takes the short way across north', () {
      expect(Angles.delta(350, 10), closeTo(20, 0.001));
      expect(Angles.delta(10, 350), closeTo(-20, 0.001));
    });

    test('stays within -180..180', () {
      expect(Angles.delta(0, 190), closeTo(-170, 0.001));
      expect(Angles.delta(0, 180), closeTo(180, 0.001));
    });
  });

  test('distance is never negative', () {
    expect(Angles.distance(350, 10), closeTo(20, 0.001));
    expect(Angles.distance(10, 350), closeTo(20, 0.001));
  });
}
