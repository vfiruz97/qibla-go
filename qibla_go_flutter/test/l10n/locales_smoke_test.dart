import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/app/theme/script_theme.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/location/location_models.dart';
import 'package:qibla_go_flutter/core/storage/app_preferences.dart';
import 'package:qibla_go_flutter/features/map/application/sky_providers.dart';
import 'package:qibla_go_flutter/features/map/presentation/map_screen.dart';
import 'package:qibla_go_flutter/features/map/presentation/widgets/map_tiles.dart';
import 'package:qibla_go_flutter/features/qibla/application/location_controller.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:qibla_go_flutter/l10n/locale_resolution.dart';
import 'package:qibla_go_flutter/l10n/tajik_material_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_location_service.dart';

/// The map screen, the one every platform has, under each shipped language:
/// it must build without errors, show that language, lay out right-to-left
/// where the language does, and get the script-aware type.
void main() {
  final dushanbe = GeoPoint(latitude: 38.5598, longitude: 68.7870);

  setUpAll(() => tileCachingEnabled = false);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpMap(WidgetTester tester, Locale locale) async {
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
          localizationsDelegates: const [
            ...tajikLocalizationsDelegates,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: resolveLocale,
          locale: locale,
          builder: (context, child) => ScriptTheme(child: child!),
          home: const MapScreen(),
        ),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('$locale builds, is translated and laid out for its script', (
      tester,
    ) async {
      await pumpMap(tester, locale);
      expect(tester.takeException(), isNull);

      final l10n = lookupAppLocalizations(locale);
      expect(find.text(l10n.mapHowTitle), findsOneWidget);

      final context = tester.element(find.byType(MapScreen));
      expect(Localizations.localeOf(context), locale);
      final rtl = const {'ar', 'fa', 'ur'}.contains(locale.languageCode);
      expect(
        Directionality.of(context),
        rtl ? TextDirection.rtl : TextDirection.ltr,
      );

      final text = Theme.of(context).textTheme;
      if (rtl) {
        expect(text.labelMedium!.letterSpacing, 0, reason: 'no tracking');
      }
      final latin = const {
        'en',
        'de',
        'fr',
        'it',
        'sv',
        'tr',
        'az',
        'uz',
        'id',
      }.contains(locale.languageCode);
      expect(
        text.displayLarge!.fontFamily,
        latin ? AppFonts.display : AppFonts.body,
      );
    });
  }

  testWidgets('Tajik gets Tajik widget chrome, not English', (tester) async {
    await pumpMap(tester, const Locale('tg'));
    final context = tester.element(find.byType(MapScreen));
    expect(
      MaterialLocalizations.of(context),
      isA<TajikMaterialLocalizations>(),
    );
    expect(MaterialLocalizations.of(context).backButtonTooltip, 'Бозгашт');
    expect(WidgetsLocalizations.of(context).copyButtonLabel, 'Нусха бардоштан');
  });

  testWidgets('an unsupported device language falls back to English', (
    tester,
  ) async {
    await pumpMap(tester, const Locale('xx'));
    // MaterialApp.locale bypasses the callback, so check the callback itself
    // with what a device would send.
    expect(
      resolveLocale([
        const Locale('xx'),
        const Locale('yy', 'ZZ'),
      ], AppLocalizations.supportedLocales),
      const Locale('en'),
    );
    expect(tester.takeException(), isNull);
  });
}
