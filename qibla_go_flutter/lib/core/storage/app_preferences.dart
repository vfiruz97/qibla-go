import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../location/location_models.dart';

/// Provided from `main` after the preferences have loaded, so reads are
/// synchronous everywhere else.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  ),
);

final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => AppPreferences(ref.watch(sharedPreferencesProvider)),
);

/// Typed access to the few things the app remembers between launches.
///
/// Keys are namespaced and versioned so a future format change can migrate
/// instead of silently reading garbage.
final class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _lastFixKey = 'qibla.v1.lastLocationFix';

  LocationFix? readLastFix() {
    final raw = _prefs.getString(_lastFixKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) return null;
      return LocationFix.tryFromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  Future<void> writeLastFix(LocationFix fix) =>
      _prefs.setString(_lastFixKey, jsonEncode(fix.toJson()));

  Future<void> clearLastFix() => _prefs.remove(_lastFixKey);
}
