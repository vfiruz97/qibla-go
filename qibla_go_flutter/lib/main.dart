import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/analytics/analytics.dart';
import 'core/analytics/analytics_context.dart';
import 'core/analytics/lazy_analytics_sink.dart';
import 'core/storage/app_preferences.dart';

Future<void> main() async {
  appLaunchStopwatch.start();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // Anonymous usage events; see README "Usage statistics". The sink
        // behind it loads on the first batch, after the first frame.
        if (analyticsEnabled)
          analyticsProvider.overrideWith(
            (ref) => Analytics(
              sink: LazyAnalyticsSink(ref),
              context: AnalyticsContext(
                sessionId: AnalyticsContext.newSessionId(),
                platform: AnalyticsContext.platformTag(),
              ),
            ),
          ),
      ],
      child: const QiblaGoApp(),
    ),
  );
}
