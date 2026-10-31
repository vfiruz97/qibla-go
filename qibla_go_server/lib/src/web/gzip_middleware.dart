import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// Compresses text-like responses with gzip when the client accepts it.
///
/// Relic serves files as they are on disk; without this the 3 MB
/// `main.dart.js` of the web app went over the wire uncompressed. Only
/// successful, not-yet-encoded responses of compressible types above
/// [minBytes] are touched; conditional `304`s, ranges and images pass
/// through untouched. `ETag` is kept and `Vary: Accept-Encoding` added so
/// caches keep the two encodings apart.
///
/// [compressHtml] is false under `serverpod start`: the dev watcher injects
/// its live-reload script into HTML responses *outside* this middleware and
/// reads the body as UTF-8, which fails on gzipped bytes. In production the
/// page is compressed like everything else.
Middleware gzipMiddleware({required bool compressHtml}) =>
    (Handler next) => (Request req) async {
      final result = await next(req);
      if (result is! Response) return result;
      if (!acceptsGzip(req.headers.acceptEncoding)) return result;
      return gzipResponse(result, compressHtml: compressHtml);
    };

/// Below this a gzip header costs about as much as it saves.
const minBytes = 1024;

/// Compressible on top of what Relic already calls text (html, css, js,
/// json, xml and the `+json` / `+xml` families).
const _alsoCompressible = {
  'application/wasm',
  'image/svg+xml',
  'font/ttf',
  'font/otf',
  'application/font-sfnt',
  'application/x-font-ttf',
  'application/x-font-opentype',
  'application/vnd.ms-fontobject',
};

bool isCompressible(MimeType type, {required bool html}) {
  if (type == MimeType.html) return html;
  return type.isText || _alsoCompressible.contains(type.toHeaderValue());
}

bool acceptsGzip(AcceptEncodingHeader? accept) {
  if (accept == null) return false;
  if (accept.isWildcard) return true;
  for (final e in accept.encodings) {
    if (e.encoding == 'gzip' || e.encoding == '*') {
      return (e.quality ?? 1) > 0;
    }
  }
  return false;
}

/// Returns [response] gzip-encoded, or unchanged when it should not be.
Response gzipResponse(Response response, {required bool compressHtml}) {
  if (response.statusCode != 200) return response;
  if (response.headers.contentEncoding != null) return response;
  final body = response.body;
  final type = body.bodyType;
  if (type == null || !isCompressible(type.mimeType, html: compressHtml)) {
    return response;
  }
  final length = body.contentLength;
  if (length != null && length < minBytes) return response;

  final compressed = body
      .read()
      .cast<List<int>>()
      .transform(gzip.encoder)
      .map((chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk));
  return response.copyWith(
    headers: response.headers.transform((h) {
      h.contentEncoding = ContentEncodingHeader.encodings([
        ContentEncoding.gzip,
      ]);
      h.vary = VaryHeader.headers(fields: const ['accept-encoding']);
      h.contentLength = null;
      h.acceptRanges = null;
    }),
    body: Body.fromDataStream(
      compressed,
      mimeType: type.mimeType,
      encoding: type.encoding,
      parameters: type.parameters,
    ),
  );
}
