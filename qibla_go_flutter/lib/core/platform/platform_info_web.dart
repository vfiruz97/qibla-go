import 'package:web/web.dart' as web;

/// True on a desktop browser, where no orientation sensor exists and the
/// map is the better experience.
bool get isDesktopBrowser {
  final ua = web.window.navigator.userAgent.toLowerCase();
  const mobileMarkers = ['mobi', 'android', 'iphone', 'ipad', 'ipod'];
  if (mobileMarkers.any(ua.contains)) return false;
  // iPadOS Safari reports itself as a Mac but has touch points.
  if (ua.contains('macintosh') && web.window.navigator.maxTouchPoints > 1) {
    return false;
  }
  return true;
}
