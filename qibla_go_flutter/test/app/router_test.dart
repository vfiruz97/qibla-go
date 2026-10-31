import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:qibla_go_flutter/app/router.dart';

void main() {
  group('webRedirect', () {
    test('on the web the old map path goes to the single page', () {
      expect(webRedirect(AppRoutes.map, web: true), AppRoutes.qibla);
    });

    test('on the web the root stays', () {
      expect(webRedirect(AppRoutes.qibla, web: true), isNull);
    });

    test('on a phone both screens stay', () {
      expect(webRedirect(AppRoutes.qibla, web: false), isNull);
      expect(webRedirect(AppRoutes.map, web: false), isNull);
    });
  });

  test('the web router has one page, the phone router two', () {
    expect(createAppRouter(web: true).configuration.routes, hasLength(1));
    expect(createAppRouter(web: false).configuration.routes, hasLength(2));
  });

  testWidgets(
    'Given the web router, when an old /map link opens, then it lands on /',
    (tester) async {
      // Same shape as the web router: one page at /, redirect for /map.
      final router = GoRouter(
        initialLocation: AppRoutes.map,
        redirect: (context, state) => webRedirect(state.uri.path, web: true),
        routes: [
          GoRoute(
            path: AppRoutes.qibla,
            builder: (context, state) => const SizedBox(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        WidgetsApp.router(routerConfig: router, color: const Color(0xFF000000)),
      );
      await tester.pumpAndSettle();
      expect(router.state.uri.path, AppRoutes.qibla);
    },
  );
}
