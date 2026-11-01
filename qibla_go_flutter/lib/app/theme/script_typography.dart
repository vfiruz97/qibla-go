import 'package:flutter/widgets.dart';

import 'app_theme.dart';

/// Writing systems the UI languages use; each needs slightly different type.
enum ScriptGroup { latin, cyrillic, arabic, cjk }

/// Typography choices that follow the script of the UI language.
///
/// The bundled display face (Marcellus) has Latin glyphs only, so other
/// scripts use the body face for headlines instead of a silent fallback to
/// whatever the system has. Arabic script is cursive: letter-spacing pulls
/// the joined letters apart, so tracking is zero there. Arabic and East
/// Asian glyphs are taller than Latin ones and need more line height.
final class ScriptTypography {
  const ScriptTypography._(this.group);

  final ScriptGroup group;

  static const latin = ScriptTypography._(ScriptGroup.latin);
  static const cyrillic = ScriptTypography._(ScriptGroup.cyrillic);
  static const arabic = ScriptTypography._(ScriptGroup.arabic);
  static const cjk = ScriptTypography._(ScriptGroup.cjk);

  static ScriptTypography forLocale(Locale? locale) =>
      switch (locale?.languageCode) {
        'ru' || 'tg' => cyrillic,
        'ar' || 'fa' || 'ur' => arabic,
        'zh' || 'ja' || 'ko' => cjk,
        _ => latin,
      };

  static ScriptTypography of(BuildContext context) =>
      forLocale(Localizations.maybeLocaleOf(context));

  /// Font family for the wordmark, headlines and the big numerals.
  String get displayFamily =>
      group == ScriptGroup.latin ? AppFonts.display : AppFonts.body;

  /// Whether letter-spacing may be applied at all.
  bool get tracks => group != ScriptGroup.arabic;

  /// [value] when the script tolerates tracking, otherwise zero.
  double tracking(double value) => tracks ? value : 0;

  double get displayHeight => switch (group) {
    ScriptGroup.latin || ScriptGroup.cyrillic => 1.05,
    ScriptGroup.arabic => 1.3,
    ScriptGroup.cjk => 1.2,
  };

  double get bodyHeight => switch (group) {
    ScriptGroup.latin || ScriptGroup.cyrillic => 1.35,
    ScriptGroup.arabic => 1.6,
    ScriptGroup.cjk => 1.5,
  };
}
