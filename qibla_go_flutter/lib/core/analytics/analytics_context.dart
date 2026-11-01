import 'dart:math';

import 'package:flutter/foundation.dart';

/// What travels once with every batch: which launch, which platform, which
/// language. Nothing here survives the process, so launches cannot be
/// linked to each other or to a person.
final class AnalyticsContext {
  const AnalyticsContext({
    required this.sessionId,
    required this.platform,
    this.language,
  });

  /// 32 hex characters drawn at launch and never stored.
  final String sessionId;

  /// `android`, `ios`, `web`, `macos`, `windows`, `linux` or `unknown`.
  final String platform;

  /// ISO 639 code of the language the app is shown in, once known.
  final String? language;

  AnalyticsContext withLanguage(String? language) => AnalyticsContext(
    sessionId: sessionId,
    platform: platform,
    language: language,
  );

  static String newSessionId([Random? random]) {
    final r = random ?? Random.secure();
    return List.generate(
      16,
      (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  /// The platform as the server's allowlist spells it.
  static String platformTag({
    bool web = kIsWeb,
    TargetPlatform? platform,
  }) {
    if (web) return 'web';
    return switch (platform ?? defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'unknown',
    };
  }
}
