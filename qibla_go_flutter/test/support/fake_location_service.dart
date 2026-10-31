import 'package:qibla_go_flutter/core/location/location_models.dart';
import 'package:qibla_go_flutter/core/location/location_service.dart';

/// Location seam for tests: answers at once with a fixed fix and grant.
class FakeLocationService implements LocationService {
  FakeLocationService({
    this.fix,
    this.permission = LocationPermissionState.granted,
  });

  final LocationFix? fix;
  final LocationPermissionState permission;

  @override
  Future<bool> isServiceEnabled() async => true;

  @override
  Future<LocationPermissionState> checkPermission() async => permission;

  @override
  Future<LocationPermissionState> requestPermission() async => permission;

  @override
  Future<LocationFix?> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  }) async => fix;

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<bool> openLocationSettings() async => true;
}
