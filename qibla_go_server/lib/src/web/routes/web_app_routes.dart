import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../seo.dart';

/// Serves `web/app/index.html` with the public origin filled in, for the
/// web app's one page at `/`. Every other path is handled by [FlutterRoute]
/// or by a [RedirectRoute].
class IndexPageRoute extends Route {
  IndexPageRoute(this.file, {required this.origin})
    : super(methods: {Method.get, Method.head});

  final File file;
  final String origin;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    // Read per request: the file is small and changes on every
    // `serverpod run flutter_build`; no restart needed to pick it up.
    final html = renderIndex(await file.readAsString(), origin);
    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
      headers: Headers.build(
        (h) => h.cacheControl = CacheControlHeader(
          noCache: true,
          privateCache: true,
        ),
      ),
    );
  }
}

/// Permanent redirect, so crawlers see one URL for the page instead of a
/// client-side hop.
class RedirectRoute extends Route {
  RedirectRoute(this.to) : super(methods: {Method.get, Method.head});

  final String to;

  @override
  Result handleCall(Session session, Request request) =>
      Response.movedPermanently(Uri.parse(to));
}

/// A fixed text document such as `robots.txt` or `sitemap.xml`.
class TextRoute extends Route {
  TextRoute(this.text, {required this.mimeType})
    : super(methods: {Method.get, Method.head});

  final String text;
  final MimeType mimeType;

  @override
  Result handleCall(Session session, Request request) => Response.ok(
    body: Body.fromString(text, mimeType: mimeType),
    headers: Headers.build(
      (h) => h.cacheControl = CacheControlHeader(
        publicCache: true,
        maxAge: 3600,
      ),
    ),
  );
}
