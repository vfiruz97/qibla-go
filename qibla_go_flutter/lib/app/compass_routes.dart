import 'package:go_router/go_router.dart';

import '../features/qibla/presentation/qibla_screen.dart';
import 'router.dart';

/// The compass screen, phone builds only. The web build imports
/// `compass_routes_web.dart` instead, so none of the compass, sensor or
/// dial code is compiled into the web bundle (see `tool/check_web_bundle.sh`).
List<RouteBase> compassRoutes() => [
  GoRoute(
    path: AppRoutes.qibla,
    name: 'qibla',
    builder: (context, state) => const QiblaScreen(),
  ),
];
