import 'package:go_router/go_router.dart';

import '../features/map/presentation/map_screen.dart';
import '../features/qibla/presentation/qibla_screen.dart';

/// Route names, so navigation never spells paths inline.
abstract final class AppRoutes {
  static const qibla = '/';
  static const map = '/map';
}

/// One route today. Prayer times and settings will be siblings here; keep
/// each feature's screen under its own `features/<name>/presentation`.
final appRouter = GoRouter(
  initialLocation: AppRoutes.qibla,
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
