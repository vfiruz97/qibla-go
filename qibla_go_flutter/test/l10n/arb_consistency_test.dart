import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every language ships the same keys as the English template, with the same
/// placeholders, and is actually translated. Runs on the ARB files directly,
/// so a forgotten key fails here before anyone sees English leak through.
void main() {
  final dir = Directory('lib/l10n');
  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.arb'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final arbs = {
    for (final f in files)
      RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)!.group(1)!:
          jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  };
  final en = arbs['en']!;
  Iterable<String> keysOf(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@'));
  final enKeys = keysOf(en).toSet();

  /// Placeholder names: `{name}` and the `{count, plural, ...}` selector.
  Set<String> placeholders(String message) => RegExp(
    r'\{(\w+)(?=[,}])',
  ).allMatches(message).map((m) => m.group(1)!).toSet();

  // Values that are legitimately the same as English: the brand, pure
  // symbols and numbers, and words that several languages share.
  const mayEqualEnglish = {
    'appName',
    'qiblaLabel',
    'accuracyPlusMinus',
    'locationAccuracyMeters',
    'locationCoordinates',
    'detailsNotAvailable',
    'supportAnswerHint',
    'skyMarkerLabel',
    'detailsKaaba',
    'detailsSource',
    'detailsLocation',
    'detailsButton',
    'locationLatitude',
    'locationLongitude',
    'cardinalN',
    'cardinalE',
    'cardinalS',
    'cardinalW',
  };

  test('all seventeen languages are present', () {
    expect(
      arbs.keys,
      containsAll([
        'en',
        'de',
        'ru',
        'tg',
        'uz',
        'tr',
        'fa',
        'ar',
        'az',
        'zh',
        'ko',
        'ja',
        'fr',
        'it',
        'sv',
        'id',
        'ur',
      ]),
    );
    expect(arbs.length, 17);
  });

  for (final entry in arbs.entries) {
    final locale = entry.key;
    final arb = entry.value;
    group(locale, () {
      test('declares its own locale', () {
        expect(arb['@@locale'], locale);
      });

      test('has exactly the English keys', () {
        final keys = keysOf(arb).toSet();
        expect(enKeys.difference(keys), isEmpty, reason: 'missing keys');
        expect(keys.difference(enKeys), isEmpty, reason: 'unknown keys');
      });

      test('keeps every placeholder and every plural has other', () {
        for (final key in enKeys) {
          final source = en[key] as String;
          final message = arb[key] as String;
          expect(
            placeholders(message),
            placeholders(source),
            reason: '$key: placeholders differ',
          );
          if (source.contains(', plural,')) {
            expect(message, contains('other{'), reason: '$key: no other');
          }
          var depth = 0;
          for (final rune in message.runes) {
            if (rune == 0x7B) depth++;
            if (rune == 0x7D) depth--;
            expect(depth, greaterThanOrEqualTo(0), reason: '$key: braces');
          }
          expect(depth, 0, reason: '$key: unbalanced braces');
          expect(message.trim(), isNotEmpty, reason: '$key: empty');
        }
      });

      if (locale != 'en') {
        test('is translated, not copied', () {
          final copied = enKeys
              .where((k) => arb[k] == en[k] && !mayEqualEnglish.contains(k))
              .toList();
          expect(copied, isEmpty);
        });
      }
    });
  }
}
