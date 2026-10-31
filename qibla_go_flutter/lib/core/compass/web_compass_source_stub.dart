import '../geo/geo_point.dart';
import 'compass_reading.dart';
import 'compass_source.dart';

/// Placeholder for non-web builds; never instantiated there.
final class WebCompassSource implements CompassSource {
  @override
  CompassSourceKind get kind => CompassSourceKind.web;

  @override
  Future<CompassAvailability> availability() async =>
      const CompassAvailability.unavailable(CompassUnavailableReason.noSensor);

  @override
  Future<CompassAvailability> requestPermission() => availability();

  @override
  Future<void> configure(GeoPoint? location) async {}

  @override
  Stream<CompassReading> get readings => const Stream.empty();
}
