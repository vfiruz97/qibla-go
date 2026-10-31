import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';

import '../features/map/presentation/map_screen.dart';
import '../features/qibla/presentation/qibla_screen.dart';

/// Route names, so navigation never spells paths inline.
abstract final class AppRoutes {
  static const qibla = '/';
  static const map = '/map';
}

/// Where a request for [path] should go instead, or null to keep it.
///
/// On the web the live compass does not exist: browsers give a rough
/// heading at best and desktop browsers none, so the compass screen is not
/// reachable there at all, not even by URL. Phones running the app keep
/// both screens.
String? webRedirect(String path, {required bool web}) {
  if (web && path == AppRoutes.qibla) return AppRoutes.map;
  return null;
}

/// Builds the app router. [web] is a parameter so tests can cover both
/// platforms; the app passes the real value.
GoRouter createAppRouter({bool web = kIsWeb}) => GoRouter(
  initialLocation: web ? AppRoutes.map : AppRoutes.qibla,
  redirect: (context, state) => webRedirect(state.uri.path, web: web),
  routes: [
    GoRoute(
      path: AppRoutes.qibla,
      name: 'qibla',
      builder: (context, state) => const QiblaScreen(),
    ),
    GoRoute(
      path: AppRoutes.map,
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);

/// Prayer times and settings will be siblings here; keep each feature's
/// screen under its own `features/<name>/presentation`.
final appRouter = createAppRouter();
