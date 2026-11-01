import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qibla_go_client/qibla_go_client.dart';

import '../serverpod/client.dart';
import 'analytics_context.dart';
import 'analytics_event.dart';
import 'analytics_sink.dart';

/// Sends batches to `analytics.record`. Lives behind a deferred import (see
/// `lazy_analytics_sink.dart`) so neither the Serverpod client nor this
/// file is in the initial web bundle.
final class ServerpodAnalyticsSink implements AnalyticsSink {
  ServerpodAnalyticsSink(this._ref);

  final Ref _ref;
  Future<String?>? _version;

  /// The app version, read once. Null when the platform cannot say.
  Future<String?> get _appVersion => _version ??= PackageInfo.fromPlatform()
      .then<String?>((info) {
        final build = info.buildNumber;
        return build.isEmpty ? info.version : '${info.version}+$build';
      })
      .catchError((Object _) => null);

  @override
  Future<void> send(
    AnalyticsContext context,
    List<AnalyticsEvent> events,
  ) async {
    final client = await _ref.read(serverpodClientProvider.future);
    await client.analytics.record(
      sessionId: context.sessionId,
      platform: context.platform,
      appVersion: await _appVersion,
      language: context.language,
      events: [
        for (final e in events)
          AnalyticsEventInput(
            occurredAt: e.occurredAt,
            name: e.name.wire,
            screen: e.screen,
            fromScreen: e.fromScreen,
            durationMs: e.durationMs,
            outcome: e.outcome,
          ),
      ],
    );
  }
}
