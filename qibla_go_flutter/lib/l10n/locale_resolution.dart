import 'dart:ui' show Locale;

/// The language the app falls back to when none of the user's languages is
/// supported. English is also the template ARB, so it is always complete.
const Locale fallbackLocale = Locale('en');

/// Picks the UI language from the user's preferred locales (the system
/// language list on phones, `navigator.languages` in a browser).
///
/// The user's order wins: for each preferred locale in turn, an exact match
/// (language, script, country) is taken first, then a match on language and
/// country, then any supported locale with the same language. When nothing
/// matches, [fallbackLocale] is returned, never an arbitrary first entry of
/// [supported] (which the code generator sorts alphabetically, so that would
/// be Arabic).
///
/// Signature matches `LocaleListResolutionCallback`.
Locale resolveLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  final candidates = supported.toList(growable: false);
  if (candidates.isEmpty) return fallbackLocale;
  for (final want in preferred ?? const <Locale>[]) {
    for (final have in candidates) {
      if (have == want) return have;
    }
    if (want.countryCode != null) {
      for (final have in candidates) {
        if (have.languageCode == want.languageCode &&
            have.countryCode == want.countryCode) {
          return have;
        }
      }
    }
    for (final have in candidates) {
      if (have.languageCode == want.languageCode) return have;
    }
  }
  return candidates.contains(fallbackLocale)
      ? fallbackLocale
      : candidates.first;
}
