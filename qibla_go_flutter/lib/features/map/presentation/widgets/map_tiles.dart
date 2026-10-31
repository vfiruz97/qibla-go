import 'package:flutter_map/flutter_map.dart';

/// Raster tile source for every map in the app.
///
/// Defaults to the OpenStreetMap standard tiles, which need no API key and
/// draw every building from zoom 16 up, so the user can match the qibla line
/// to the houses and roads around them. The tiles are shown in their natural
/// light style: readability beats matching the night palette here (see
/// [qiblaTileInvert]). This app is free and stays on free providers; the OSM
/// tile usage policy tolerates light use by a small app but not heavy
/// traffic, so before a public release point this at a free-tier provider
/// whose terms cover the expected load via
/// `--dart-define=QIBLA_TILE_URL=https://.../{z}/{x}/{y}.png` and update the
/// attribution string in the ARB file.
///
/// CARTO's basemaps were the previous default; they now require an API key
/// and render an "API KEY REQUIRED" watermark without one.
const qiblaTileUrl = String.fromEnvironment(
  'QIBLA_TILE_URL',
  defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
);

/// Whether tiles are inverted into a dark style on the device. Off by
/// default: inverted tiles hide buildings and make comparing the line with
/// the surroundings hard.
const qiblaTileInvert = bool.fromEnvironment('QIBLA_TILE_INVERT');

/// Highest zoom the default provider serves; flutter_map scales beyond it.
const _maxNativeZoom = 19;

/// Widget tests turn this off: the on-disk tile cache needs a platform
/// channel that does not exist under `flutter test`.
bool tileCachingEnabled = true;

TileLayer qiblaTileLayer() => TileLayer(
  urlTemplate: qiblaTileUrl,
  maxNativeZoom: _maxNativeZoom,
  userAgentPackageName: 'app.qiblago',
  tileBuilder: qiblaTileInvert ? darkModeTileBuilder : null,
  tileProvider: tileCachingEnabled
      ? NetworkTileProvider()
      : NetworkTileProvider(
          cachingProvider: const DisabledMapCachingProvider(),
        ),
);
