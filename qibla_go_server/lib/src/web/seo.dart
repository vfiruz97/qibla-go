// Text that search engines fetch. Pure functions, unit tested.

/// Placeholder in `web/index.html` that the server fills with the public
/// origin, so canonical and Open Graph links are absolute.
const originPlaceholder = '__QIBLA_ORIGIN__';

String renderIndex(String template, String origin) =>
    template.replaceAll(originPlaceholder, origin);

String robotsTxt(String origin) =>
    'User-agent: *\n'
    'Allow: /\n'
    'Disallow: /assets/\n'
    'Disallow: /canvaskit/\n'
    'Sitemap: $origin/sitemap.xml\n';

/// One page: on the web the app is a single screen at `/` (`/map` redirects
/// there), so that is the only URL worth indexing.
String sitemapXml(String origin, {required DateTime lastModified}) {
  final day = lastModified.toUtc().toIso8601String().substring(0, 10);
  return '<?xml version="1.0" encoding="UTF-8"?>\n'
      '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
      '  <url><loc>$origin/</loc><lastmod>$day</lastmod></url>\n'
      '</urlset>\n';
}
