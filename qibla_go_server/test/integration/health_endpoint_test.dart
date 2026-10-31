import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Health endpoint', (sessionBuilder, endpoints) {
    test('when calling ping then a recent UTC time is returned', () async {
      final before = DateTime.now().toUtc();
      final time = await endpoints.health.ping(sessionBuilder);
      final after = DateTime.now().toUtc();

      expect(time.isUtc, isTrue);
      expect(
        time.isBefore(before.subtract(const Duration(seconds: 1))),
        isFalse,
      );
      expect(time.isAfter(after.add(const Duration(seconds: 1))), isFalse);
    });
  });
}
