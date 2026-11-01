import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:qibla_go_flutter/l10n/locale_resolution.dart';

void main() {
  final supported = AppLocalizations.supportedLocales;

  test('English is the fallback when nothing matches', () {
    expect(resolveLocale([const Locale('xx')], supported), const Locale('en'));
    expect(resolveLocale([], supported), const Locale('en'));
    expect(resolveLocale(null, supported), const Locale('en'));
  });

  test(
    'the generator sorts locales, so the first supported is not English',
    () {
      // This is why resolveLocale exists: Flutter's default fallback is
      // supportedLocales.first.
      expect(supported.first, isNot(const Locale('en')));
    },
  );

  test('exact match wins', () {
    expect(resolveLocale([const Locale('de')], supported), const Locale('de'));
  });

  test('a regional variant resolves to its language', () {
    expect(
      resolveLocale([const Locale('de', 'AT')], supported),
      const Locale('de'),
    );
    expect(
      resolveLocale([const Locale('fa', 'AF')], supported),
      const Locale('fa'),
    );
    expect(
      resolveLocale([const Locale('zh', 'TW')], supported),
      const Locale('zh'),
    );
    expect(
      resolveLocale(
        [const Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl')],
        supported,
      ),
      const Locale('uz'),
    );
  });

  test('the user order wins over the supported order', () {
    expect(
      resolveLocale([
        const Locale('xx'),
        const Locale('ko'),
        const Locale('ar'),
      ], supported),
      const Locale('ko'),
    );
    expect(
      resolveLocale([const Locale('fr', 'CA'), const Locale('de')], supported),
      const Locale('fr'),
    );
  });

  test('language and country beat language alone when both exist', () {
    const list = [Locale('pt'), Locale('pt', 'BR')];
    expect(
      resolveLocale([const Locale('pt', 'BR')], list),
      const Locale('pt', 'BR'),
    );
    expect(resolveLocale([const Locale('pt', 'PT')], list), const Locale('pt'));
  });

  test('every shipped language resolves to itself', () {
    for (final locale in supported) {
      expect(resolveLocale([locale], supported), locale);
    }
  });
}
