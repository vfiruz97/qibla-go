import 'package:flutter/widgets.dart';

import 'analytics.dart';
import 'analytics_event.dart';

/// Turns the navigator's traffic into `screen_view` and `sheet_view`
/// events. Only named routes count: the two screens get their names from
/// the router, the sheets from `RouteSettings(name:)` in their `show`.
/// Anything unnamed (dialogs, transient routes) is ignored.
final class AnalyticsNavigatorObserver extends NavigatorObserver {
  AnalyticsNavigatorObserver(this._analytics);

  final Analytics _analytics;
  final _screens = <String>[];

  String? get _currentScreen => _screens.isEmpty ? null : _screens.last;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name;
    if (name == null) return;
    if (route is PageRoute) {
      _analytics.track(
        AnalyticsEventName.screenView,
        screen: name,
        fromScreen: _currentScreen,
      );
      _screens.add(name);
    } else {
      _analytics.track(
        AnalyticsEventName.sheetView,
        screen: name,
        fromScreen: _currentScreen,
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _forget(route);
    final back = previousRoute?.settings.name;
    if (route is PageRoute && previousRoute is PageRoute && back != null) {
      _analytics.track(
        AnalyticsEventName.screenView,
        screen: back,
        fromScreen: route.settings.name,
      );
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _forget(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _forget(oldRoute);
    if (newRoute != null) didPush(newRoute, oldRoute);
  }

  void _forget(Route<dynamic> route) {
    final name = route.settings.name;
    if (route is PageRoute && name != null) {
      final i = _screens.lastIndexOf(name);
      if (i >= 0) _screens.removeAt(i);
    }
  }
}
