import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/features/rating/presentation/rating_sheet.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:qibla_go_flutter/l10n/locale_resolution.dart';

void main() {
  late bool? answer;
  late bool opened;

  Widget host({Locale locale = const Locale('en')}) => MaterialApp(
    theme: AppTheme.dark(locale: locale),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    localeListResolutionCallback: resolveLocale,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: FilledButton(
            onPressed: () async {
              opened = true;
              answer = await RatingSheet.show(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );

  setUp(() {
    answer = null;
    opened = false;
  });

  Future<AppLocalizations> open(WidgetTester tester, {Locale? locale}) async {
    await tester.pumpWidget(host(locale: locale ?? const Locale('en')));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
    return AppLocalizations.of(tester.element(find.byType(RatingSheet)));
  }

  testWidgets('explains why, names the store for the platform, offers two '
      'answers', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final l10n = await open(tester);
    expect(find.text(l10n.ratingTitle), findsOneWidget);
    expect(find.text(l10n.ratingBodyGooglePlay), findsOneWidget);
    expect(find.text(l10n.ratingBodyAppStore), findsNothing);
    expect(find.text(l10n.ratingRate), findsOneWidget);
    expect(find.text(l10n.ratingNotNow), findsOneWidget);
    expect(find.text(l10n.ratingFootnote), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('names the App Store on iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final l10n = await open(tester);
    expect(find.text(l10n.ratingBodyAppStore), findsOneWidget);
    expect(find.text(l10n.ratingBodyGooglePlay), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('"Rate" answers true', (tester) async {
    final l10n = await open(tester);
    await tester.tap(find.text(l10n.ratingRate));
    await tester.pumpAndSettle();
    expect(answer, isTrue);
    expect(find.byType(RatingSheet), findsNothing);
  });

  testWidgets('"Not now" answers false', (tester) async {
    final l10n = await open(tester);
    await tester.tap(find.text(l10n.ratingNotNow));
    await tester.pumpAndSettle();
    expect(answer, isFalse);
  });

  testWidgets('tapping outside answers null, which the caller treats as no', (
    tester,
  ) async {
    await open(tester);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(answer, isNull);
    expect(find.byType(RatingSheet), findsNothing);
  });

  testWidgets('lays out in a right-to-left language at 320 px without '
      'overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await open(tester, locale: const Locale('ar'));
    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(tester.element(find.byType(RatingSheet))),
      TextDirection.rtl,
    );
  });
}
