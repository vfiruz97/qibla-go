import 'dart:io';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/web/gzip_middleware.dart';
import 'src/web/public_origin.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/web_app_routes.dart';
import 'src/web/seo.dart';

/// The starting point of the Serverpod server.
///
/// Qibla Go has no user accounts: every endpoint is public and read-mostly.
/// Authentication is deliberately not initialised here (see AGENTS.md).
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Everything the web server sends that compresses well goes out gzipped.
  // HTML only outside development; see gzipMiddleware.
  pod.webServer.addMiddleware(
    gzipMiddleware(compressHtml: pod.runMode != ServerpodRunMode.development),
    '/',
  );

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // The page itself, with absolute links for search engines, plus
    // robots.txt and the sitemap. See src/web/seo.dart.
    final origin = publicOrigin(pod.config.webServer);
    final indexFile = File('${appDir.path}/index.html');
    pod.webServer.addRoute(IndexPageRoute(indexFile, origin: origin), '/');
    // The one page lives at /; old links and the file name go there for good.
    for (final oldPath in ['/map', '/index.html']) {
      pod.webServer.addRoute(RedirectRoute('/'), oldPath);
    }
    pod.webServer.addRoute(
      TextRoute(robotsTxt(origin), mimeType: MimeType.plainText),
      '/robots.txt',
    );
    pod.webServer.addRoute(
      TextRoute(
        sitemapXml(origin, lastModified: indexFile.lastModifiedSync()),
        mimeType: MimeType.xml,
      ),
      '/sitemap.xml',
    );

    // Serve the flutter web app under /.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/**',
    );
  }

  // Start the server.
  await pod.start();
}
