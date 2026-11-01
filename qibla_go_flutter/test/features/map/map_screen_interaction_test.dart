import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/location/location_models.dart';
import 'package:qibla_go_flutter/core/storage/app_preferences.dart';
import 'package:qibla_go_flutter/features/map/application/sky_providers.dart';
import 'package:qibla_go_flutter/features/map/presentation/map_screen.dart';
import 'package:qibla_go_flutter/features/map/presentation/widgets/kaaba_marker.dart';
import 'package:qibla_go_flutter/features/map/presentation/widgets/map_tiles.dart';
import 'package:qibla_go_flutter/features/qibla/application/location_controller.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:qibla_go_flutter/l10n/locale_resolution.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_location_service.dart';

/// The map must react to a new position by moving, not by rebuilding from
/// scratch: the user marker keeps its State and the location is set without
/// any message competing with the map.
void main() {
  final dushanbe = GeoPoint(latitude: 38.5598, longitude: 68.7870);

  /// Several real frames: the fix arrives over a few microtask turns and
  /// the camera and marker animations need ticks to finish.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  setUpAll(() => tileCachingEnabled = false);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<ProviderContainer> pumpMap(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(
          FakeLocationService(
            fix: LocationFix(
              point: dushanbe,
              time: DateTime.now(),
              origin: LocationOrigin.device,
            ),
          ),
        ),
        minuteClockProvider.overrideWith(
          (ref) => Stream.value(DateTime.utc(2026, 3, 20, 12, 30)),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // As in the app: English unless the test platform asks otherwise.
          localeListResolutionCallback: resolveLocale,
          home: const MapScreen(),
        ),
      ),
    );
    await settle(tester); // first fix arrives, fly-in completes
    return container;
  }

  testWidgets('long-press moves the marker without recreating it', (
    tester,
  ) async {
    final container = await pumpMap(tester);
    final markerBefore = tester.state(find.byType(UserMarker));

    final mapCenter = tester.getCenter(find.byType(MapScreen));
    await tester.longPressAt(Offset(mapCenter.dx + 60, 120));
    await tester.pump();

    // Mid-animation: still the same marker, position already changed.
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.state(find.byType(UserMarker)), same(markerBefore));
    final fix = container.read(locationControllerProvider).fix!;
    expect(fix.origin, LocationOrigin.manual);
    expect(fix.point, isNot(equals(dushanbe)));
    expect(find.byType(SnackBar), findsNothing);

    await settle(tester);
    expect(tester.state(find.byType(UserMarker)), same(markerBefore));
    expect(tester.takeException(), isNull);
  });

  testWidgets('"my location" button replaces a long-pressed point', (
    tester,
  ) async {
    final container = await pumpMap(tester);
    final mapCenter = tester.getCenter(find.byType(MapScreen));
    await tester.longPressAt(Offset(mapCenter.dx + 50, 120));
    await settle(tester);
    expect(
      container.read(locationControllerProvider).fix!.origin,
      LocationOrigin.manual,
    );

    await tester.tap(find.byIcon(Icons.my_location));
    await settle(tester);

    final fix = container.read(locationControllerProvider).fix!;
    expect(fix.origin, LocationOrigin.device);
    expect(fix.point.latitude, closeTo(dushanbe.latitude, 1e-9));
    expect(fix.point.longitude, closeTo(dushanbe.longitude, 1e-9));
    expect(tester.takeException(), isNull);
  });
}
