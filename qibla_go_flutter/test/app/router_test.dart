import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/router.dart';

void main() {
  group('webRedirect', () {
    test('on the web the compass path goes to the map', () {
      expect(webRedirect(AppRoutes.qibla, web: true), AppRoutes.map);
    });

    test('on the web the map stays', () {
      expect(webRedirect(AppRoutes.map, web: true), isNull);
    });

    test('on a phone both screens stay', () {
      expect(webRedirect(AppRoutes.qibla, web: false), isNull);
      expect(webRedirect(AppRoutes.map, web: false), isNull);
    });
  });

  test('the web router starts on the map, the phone router on the compass', () {
    expect(
      createAppRouter(web: true).routeInformationProvider.value.uri.path,
      AppRoutes.map,
    );
    expect(
      createAppRouter(web: false).routeInformationProvider.value.uri.path,
      AppRoutes.qibla,
    );
  });
}
