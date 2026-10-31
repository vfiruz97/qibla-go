import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../geo/geo_point.dart';
import 'location_models.dart';

/// Thin seam over the platform location plugin so the controller and its
/// tests never import `geolocator` directly.
abstract interface class LocationService {
  Future<bool> isServiceEnabled();
  Future<LocationPermissionState> checkPermission();
  Future<LocationPermissionState> requestPermission();

  /// A single position, or null when none could be obtained in [timeout].
  /// Throws [LocationProblemException] for service/permission problems.
  Future<LocationFix?> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  });

  /// Opens the OS location settings. Returns whether it could.
  Future<bool> openLocationSettings();

  /// Opens the app's own settings page (for "denied forever").
  Future<bool> openAppSettings();
}

final class LocationProblemException implements Exception {
  const LocationProblemException(this.problem);

  final LocationProblem problem;

  @override
  String toString() => 'LocationProblemException($problem)';
}

/// `geolocator`-backed implementation used on every platform.
final class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermissionState> checkPermission() async =>
      _map(await Geolocator.checkPermission());

  @override
  Future<LocationPermissionState> requestPermission() async =>
      _map(await Geolocator.requestPermission());

  @override
  Future<LocationFix?> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    try {
      // Medium accuracy is plenty: 1 km of position error moves the qibla
      // bearing by about 0.01° anywhere outside Makkah, and it is far kinder
      // to the battery and quicker indoors.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: timeout,
        ),
      );
      return LocationFix(
        point: GeoPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        time: position.timestamp,
        origin: LocationOrigin.device,
        accuracyMeters: position.accuracy,
      );
    } on TimeoutException {
      final last = await _lastKnown();
      if (last != null) return last;
      throw const LocationProblemException(LocationProblem.timeout);
    } on LocationServiceDisabledException {
      throw const LocationProblemException(LocationProblem.servicesDisabled);
    } on PermissionDeniedException {
      throw const LocationProblemException(LocationProblem.permissionDenied);
    } on ArgumentError {
      // A plugin handed back an out-of-range coordinate; treat as no fix.
      throw const LocationProblemException(LocationProblem.unavailable);
    } catch (_) {
      final last = await _lastKnown();
      if (last != null) return last;
      throw const LocationProblemException(LocationProblem.unavailable);
    }
  }

  Future<LocationFix?> _lastKnown() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;
      return LocationFix(
        point: GeoPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        time: position.timestamp,
        origin: LocationOrigin.device,
        accuracyMeters: position.accuracy,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  static LocationPermissionState _map(LocationPermission permission) =>
      switch (permission) {
        LocationPermission.always ||
        LocationPermission.whileInUse => LocationPermissionState.granted,
        LocationPermission.denied => LocationPermissionState.denied,
        LocationPermission.deniedForever =>
          LocationPermissionState.deniedForever,
        LocationPermission.unableToDetermine => LocationPermissionState.unknown,
      };
}
