import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:qibla_go_server/src/web/gzip_middleware.dart';
import 'package:qibla_go_server/src/web/public_origin.dart';
import 'package:qibla_go_server/src/web/seo.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('publicOrigin', () {
    ServerConfig config(String scheme, String host, int port) => ServerConfig(
      port: 8082,
      publicScheme: scheme,
      publicHost: host,
      publicPort: port,
    );

    test('drops the default port', () {
      expect(
        publicOrigin(config('https', 'qibla.example', 443)),
        'https://qibla.example',
      );
      expect(
        publicOrigin(config('http', 'qibla.example', 80)),
        'http://qibla.example',
      );
    });

    test('keeps a non-default port', () {
      expect(
        publicOrigin(config('http', 'localhost', 8082)),
        'http://localhost:8082',
      );
    });

    test('falls back to the development address without a web server', () {
      expect(publicOrigin(null), 'http://localhost:8082');
    });
  });

  group('seo text', () {
    const origin = 'https://qibla.example';

    test('index gets absolute links', () {
      final html = renderIndex(
        '<link rel="canonical" href="$originPlaceholder/">',
        origin,
      );
      expect(html, '<link rel="canonical" href="$origin/">');
      expect(html, isNot(contains(originPlaceholder)));
    });

    test('robots points at the sitemap and allows the page', () {
      final robots = robotsTxt(origin);
      expect(robots, contains('Allow: /\n'));
      expect(robots, contains('Sitemap: $origin/sitemap.xml'));
    });

    test('sitemap lists the single page with the build date', () {
      final xml = sitemapXml(
        origin,
        lastModified: DateTime.utc(2026, 10, 31, 23),
      );
      expect(xml, contains('<loc>$origin/</loc>'));
      expect(xml, contains('<lastmod>2026-10-31</lastmod>'));
      expect('<url>'.allMatches(xml), hasLength(1));
    });
  });

  group('acceptsGzip', () {
    AcceptEncodingHeader? accept(String? value) =>
        value == null ? null : AcceptEncodingHeader.parse([value]);

    test('is true for gzip, wildcards and weighted gzip', () {
      expect(acceptsGzip(accept('gzip, deflate, br')), isTrue);
      expect(acceptsGzip(accept('*')), isTrue);
      expect(acceptsGzip(accept('br;q=1.0, gzip;q=0.8')), isTrue);
    });

    test('is false without the header, for other encodings, or q=0', () {
      expect(acceptsGzip(accept(null)), isFalse);
      expect(acceptsGzip(accept('br')), isFalse);
      expect(acceptsGzip(accept('gzip;q=0')), isFalse);
    });
  });

  group('gzipResponse', () {
    final script = List.filled(4000, 'var a = 1;').join('\n');

    Future<List<int>> bytes(Response r) async =>
        (await r.body.read().toList()).expand((c) => c).toList();

    test(
      'Given a large script, when gzipped then it decodes to the same text',
      () async {
        final out = gzipResponse(
          Response.ok(
            body: Body.fromString(script, mimeType: MimeType.javascript),
            headers: Headers.build(
              (h) => h.acceptRanges = AcceptRangesHeader.bytes(),
            ),
          ),
          compressHtml: false,
        );
        expect(out.headers.contentEncoding?.encodings, [ContentEncoding.gzip]);
        expect(out.headers.vary?.fields, ['accept-encoding']);
        expect(out.headers.contentLength, isNull);
        expect(out.headers.acceptRanges, isNull);
        expect(out.body.bodyType?.mimeType, MimeType.javascript);

        final raw = await bytes(out);
        expect(raw.length, lessThan(script.length ~/ 10));
        expect(utf8.decode(gzip.decode(raw)), script);
      },
    );

    test('Given a small body, then it is left alone', () {
      final small = Response.ok(
        body: Body.fromString('ok', mimeType: MimeType.plainText),
      );
      expect(
        identical(gzipResponse(small, compressHtml: false), small),
        isTrue,
      );
    });

    test('Given an image or a 304, then it is left alone', () {
      final image = Response.ok(
        body: Body.fromData(
          Uint8List(5000),
          mimeType: const MimeType('image', 'png'),
        ),
      );
      expect(
        identical(gzipResponse(image, compressHtml: false), image),
        isTrue,
      );
      final notModified = Response.notModified();
      expect(
        identical(gzipResponse(notModified, compressHtml: false), notModified),
        isTrue,
      );
    });

    test('Given an already encoded body, then it is left alone', () {
      final encoded = Response.ok(
        body: Body.fromString(script, mimeType: MimeType.javascript),
        headers: Headers.build(
          (h) => h.contentEncoding = ContentEncodingHeader.encodings([
            ContentEncoding.br,
          ]),
        ),
      );
      expect(
        identical(gzipResponse(encoded, compressHtml: false), encoded),
        isTrue,
      );
    });
  });

  test('compressible types', () {
    expect(isCompressible(MimeType.css, html: false), isTrue);
    expect(isCompressible(MimeType.javascript, html: false), isTrue);
    expect(
      isCompressible(const MimeType('application', 'wasm'), html: false),
      isTrue,
    );
    expect(isCompressible(const MimeType('font', 'ttf'), html: false), isTrue);
    expect(
      isCompressible(const MimeType('font', 'woff2'), html: false),
      isFalse,
    );
    expect(
      isCompressible(const MimeType('image', 'png'), html: false),
      isFalse,
    );
  });

  test('HTML is compressed only when allowed (not under the dev watcher)', () {
    expect(isCompressible(MimeType.html, html: true), isTrue);
    expect(isCompressible(MimeType.html, html: false), isFalse);
    final page = Response.ok(
      body: Body.fromString('<p>${'x' * 5000}</p>', mimeType: MimeType.html),
    );
    expect(identical(gzipResponse(page, compressHtml: false), page), isTrue);
    expect(
      gzipResponse(page, compressHtml: true).headers.contentEncoding?.encodings,
      [ContentEncoding.gzip],
    );
  });
}
