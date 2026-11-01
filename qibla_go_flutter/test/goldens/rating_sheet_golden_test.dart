// Visual regression for the rating sheet, night and day, on a 390 pt phone.
// Same rules as the screen goldens: rendered on macOS only, regenerate with
// `flutter test --update-goldens test/goldens` and look at the PNGs.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/features/rating/presentation/rating_sheet.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:qibla_go_flutter/l10n/locale_resolution.dart';

import '../support/golden_fonts.dart';

void main() {
  final skip = !Platform.isMacOS;

  setUpAll(loadGoldenFonts);

  Future<void> run(
    WidgetTester tester, {
    required String name,
    required Brightness brightness,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    tester.view.devicePixelRatio = 2;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetDevicePixelRatio);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.of(brightness: brightness),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: resolveLocale,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => RatingSheet.show(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('images/$name.png'),
    );
    debugDefaultTargetPlatformOverride = null;
  }

  testWidgets('rating sheet, night', (tester) async {
    await run(tester, name: 'rating_night', brightness: Brightness.dark);
  }, skip: skip);

  testWidgets('rating sheet, day', (tester) async {
    await run(tester, name: 'rating_day', brightness: Brightness.light);
  }, skip: skip);
}
