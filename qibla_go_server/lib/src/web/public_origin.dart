import 'package:serverpod/serverpod.dart';

/// The address users and crawlers reach the web app on, built from the web
/// server's `publicScheme`, `publicHost` and `publicPort` in `config/*.yaml`.
///
/// Everything search engines see (canonical link, sitemap, Open Graph) is
/// derived from this, so `production.yaml` must carry the real domain.
String publicOrigin(ServerConfig? webServer) {
  if (webServer == null) return 'http://localhost:8082';
  final scheme = webServer.publicScheme;
  final port = webServer.publicPort;
  final isDefaultPort =
      (scheme == 'https' && port == 443) || (scheme == 'http' && port == 80);
  return Uri(
    scheme: scheme,
    host: webServer.publicHost,
    port: isDefaultPort ? null : port,
  ).toString();
}
