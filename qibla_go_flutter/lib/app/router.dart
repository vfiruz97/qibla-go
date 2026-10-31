import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';

import '../features/map/presentation/map_screen.dart';
import 'compass_routes.dart'
    if (dart.library.js_interop) 'compass_routes_web.dart';

/// Route names, so navigation never spells paths inline.
///
/// On a phone `/` is the compass and `/map` the map. On the web there is no
/// compass, so the map is the one page and lives at `/`; `/map` still works
/// for old links and redirects there.
abstract final class AppRoutes {
  static const qibla = '/';
  static const map = '/map';
}

/// Where a request for [path] should go instead, or null to keep it.
///
/// The live compass does not exist on the web: browsers give a rough
/// heading at best and desktop browsers none. The web build has no compass
/// route at all (see `compass_routes_web.dart`); this keeps the URL space
/// to a single page.
String? webRedirect(String path, {required bool web}) {
  if (web && path == AppRoutes.map) return AppRoutes.qibla;
  return null;
}

/// Builds the app router. [web] is a parameter so tests can cover both
/// platforms; the app passes the real value.
GoRouter createAppRouter({bool web = kIsWeb}) => GoRouter(
  initialLocation: AppRoutes.qibla,
  redirect: (context, state) => webRedirect(state.uri.path, web: web),
  routes: [
    if (!web) ...compassRoutes(),
    GoRoute(
      path: web ? AppRoutes.qibla : AppRoutes.map,
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);

/// Prayer times and settings will be siblings here; keep each feature's
/// screen under its own `features/<name>/presentation`.
final appRouter = createAppRouter();
