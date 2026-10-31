import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/geo/geo_point.dart';
import '../../../core/location/location_models.dart';
import '../../../core/location/location_service.dart';
import '../../../core/storage/app_preferences.dart';
import '../domain/location_state.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);

final locationControllerProvider =
    NotifierProvider<LocationController, LocationState>(
      LocationController.new,
    );

/// Just the coordinates, so compass and geometry providers rebuild only when
/// the position actually changes.
final locationPointProvider = Provider<GeoPoint?>(
  (ref) => ref.watch(locationControllerProvider.select((s) => s.fix?.point)),
);

/// Owns the user's position.
///
/// Starts from the last persisted fix so the qibla appears instantly and
/// offline, then refreshes from the device. A refresh failure never throws
/// away a usable older fix; it only records the problem.
final class LocationController extends Notifier<LocationState> {
  @override
  LocationState build() {
    final cached = ref.watch(appPreferencesProvider).readLastFix();
    // Defer so the first build stays synchronous and side-effect free.
    Future<void>.microtask(() => refresh());
    return LocationState(
      fix: cached?.copyWith(
        origin: cached.origin == LocationOrigin.manual
            ? LocationOrigin.manual
            : LocationOrigin.cached,
      ),
    );
  }

  /// Asks the device for a fresh position.
  ///
  /// [requestPermission] false only checks the current grant, for silent
  /// refreshes on resume.
  Future<void> refresh({bool requestPermission = true}) async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, problem: LocationProblem.none);
    final service = ref.read(locationServiceProvider);
    try {
      if (!await service.isServiceEnabled()) {
        _fail(LocationProblem.servicesDisabled);
        return;
      }
      var permission = await service.checkPermission();
      if (permission == LocationPermissionState.denied && requestPermission) {
        permission = await service.requestPermission();
      }
      switch (permission) {
        case LocationPermissionState.deniedForever:
          _fail(LocationProblem.permissionDeniedForever);
          return;
        case LocationPermissionState.denied:
        case LocationPermissionState.unknown:
          _fail(LocationProblem.permissionDenied);
          return;
        case LocationPermissionState.granted:
          break;
      }
      final fix = await service.currentPosition();
      if (fix == null) {
        _fail(LocationProblem.unavailable);
        return;
      }
      state = state.copyWith(
        fix: fix,
        isRefreshing: false,
        problem: LocationProblem.none,
      );
      unawaited(ref.read(appPreferencesProvider).writeLastFix(fix));
    } on LocationProblemException catch (e) {
      _fail(e.problem);
    } catch (_) {
      _fail(LocationProblem.unavailable);
    }
  }

  /// Uses a position the user typed in. Kept until a device fix replaces it.
  Future<void> setManual(GeoPoint point) async {
    final fix = LocationFix(
      point: point,
      time: DateTime.now(),
      origin: LocationOrigin.manual,
    );
    state = state.copyWith(
      fix: fix,
      problem: LocationProblem.none,
      isRefreshing: false,
    );
    await ref.read(appPreferencesProvider).writeLastFix(fix);
  }

  Future<void> openSettings() async {
    final service = ref.read(locationServiceProvider);
    if (state.problem == LocationProblem.servicesDisabled) {
      await service.openLocationSettings();
    } else {
      await service.openAppSettings();
    }
  }

  void _fail(LocationProblem problem) {
    state = state.copyWith(isRefreshing: false, problem: problem);
  }
}
