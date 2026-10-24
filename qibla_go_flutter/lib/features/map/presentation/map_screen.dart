import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../app/router.dart';
import '../../../app/theme/qibla_palette.dart';
import '../../../core/geo/geo_point.dart';
import '../../../core/geo/great_circle.dart';
import '../../../core/geo/qibla_geometry.dart' as geo;
import '../../../l10n/app_localizations.dart';
import '../../qibla/application/location_controller.dart';
import '../../qibla/application/qibla_providers.dart';
import '../../qibla/presentation/widgets/location_sheet.dart';
import '../application/sky_providers.dart';
import 'widgets/how_to_panel.dart';
import 'widgets/kaaba_marker.dart';
import 'widgets/map_tiles.dart';
import 'widgets/sky_overlay.dart';
import 'widgets/world_inset.dart';

/// The qibla as a line on a map: from the user, along the great circle,
/// to the Kaaba. For browsers without sensors, and for anyone who wants
/// to check the compass against the streets around them.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _map = MapController();
  bool _howExpanded = true;
  GeoPoint? _centeredOn;

  static final _kaaba = LatLng(geo.kaaba.latitude, geo.kaaba.longitude);

  /// Street level: individual buildings are drawn, so the line can be
  /// compared with the houses and roads around the user.
  static const _streetZoom = 17.0;

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  /// Centers on the user; on narrow screens the guide panel covers the
  /// lower part of the map, so the marker is placed in the upper third.
  void _recenter(GeoPoint point) {
    final target = LatLng(point.latitude, point.longitude);
    _map.move(target, _streetZoom);
    final camera = _map.camera;
    final size = camera.nonRotatedSize;
    if (size.width >= 860) return;
    final shifted = camera.screenOffsetToLatLng(
      Offset(size.width / 2, size.height / 2 + size.height * 0.17),
    );
    _map.move(shifted, _streetZoom);
  }

  void _zoomBy(double delta) {
    final camera = _map.camera;
    final zoom = (camera.zoom + delta).clamp(_minZoom, _maxZoom).toDouble();
    _map.move(camera.center, zoom);
  }

  static const _minZoom = 2.0;
  static const _maxZoom = 19.0;

  void _fitWhole(GeoPoint point) {
    _map.fitCamera(
      CameraFit.coordinates(
        coordinates: [LatLng(point.latitude, point.longitude), _kaaba],
        padding: const EdgeInsets.all(48),
      ),
    );
  }

  Future<void> _setLocation(LatLng at) async {
    await ref
        .read(locationControllerProvider.notifier)
        .setManual(GeoPoint(latitude: at.latitude, longitude: at.longitude));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).mapLocationSet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final point = ref.watch(locationPointProvider);
    final geometry = ref.watch(qiblaGeometryProvider);
    final sky = ref.watch(skySnapshotProvider);

    // Follow the user's position when it changes (first fix, manual edit).
    if (point != null && point != _centeredOn) {
      _centeredOn = point;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _recenter(point);
      });
    }

    final user = point == null ? null : LatLng(point.latitude, point.longitude);
    final path = point == null
        ? const <LatLng>[]
        : greatCirclePath(
            point,
            geo.kaaba,
            segments: 256,
          ).map((g) => LatLng(g.latitude, g.longitude)).toList(growable: false);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          final panelWidth = wide ? 360.0 : constraints.maxWidth - 32;
          return Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                mapController: _map,
                options: MapOptions(
                  initialCenter: user ?? _kaaba,
                  initialZoom: user == null ? 4 : _streetZoom,
                  minZoom: _minZoom,
                  maxZoom: _maxZoom,
                  backgroundColor: p.background,
                  onLongPress: (_, at) => _setLocation(at),
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  qiblaTileLayer(),
                  if (path.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: path,
                          color: p.background.withValues(alpha: 0.8),
                          strokeWidth: 7,
                        ),
                        Polyline(
                          points: path,
                          color: p.goldBright,
                          strokeWidth: 3,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _kaaba,
                        width: 30,
                        height: 32,
                        child: const KaabaMarker(),
                      ),
                      if (user != null)
                        Marker(
                          point: user,
                          width: 48,
                          height: 48,
                          child: const UserMarker(),
                        ),
                    ],
                  ),
                  if (sky != null)
                    SkyOverlay(
                      sky: sky,
                      sunLabel: l10n.mapSun,
                      moonLabel: l10n.mapMoon,
                    ),
                  RichAttributionWidget(
                    alignment: AttributionAlignment.bottomLeft,
                    popupBackgroundColor: p.surface,
                    attributions: [
                      TextSourceAttribution(
                        l10n.mapAttribution,
                        prependCopyright: false,
                      ),
                    ],
                  ),
                ],
              ),
              // Top bar.
              Positioned(
                left: 16,
                right: 16,
                top: MediaQuery.paddingOf(context).top + 12,
                child: Row(
                  children: [
                    _RoundButton(
                      icon: Icons.explore_outlined,
                      tooltip: l10n.navCompass,
                      onTap: () => context.go(AppRoutes.qibla),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: p.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: p.inkFaint.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                geometry == null
                                    ? l10n.mapNeedsLocation
                                    : '${l10n.mapTitle} · '
                                          '${geometry.bearingFromTrueNorth.round() % 360}° · '
                                          '${l10n.distanceToMakkah(_km(geometry.distanceKm))}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: () => LocationSheet.show(context),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_location_alt_outlined,
                                  size: 18,
                                  color: p.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (point != null)
                      _RoundButton(
                        icon: Icons.my_location,
                        tooltip: l10n.mapRecenter,
                        onTap: () => _recenter(point),
                      ),
                  ],
                ),
              ),
              // World inset and zoom buttons, stacked on the right.
              Positioned(
                right: 16,
                top: MediaQuery.paddingOf(context).top + 72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (user != null)
                      WorldInset(
                        user: user,
                        kaaba: _kaaba,
                        path: path,
                        onTap: () => _fitWhole(point!),
                        diameter: wide ? 170 : 128,
                      ),
                    const SizedBox(height: 12),
                    _RoundButton(
                      icon: Icons.add,
                      tooltip: l10n.mapZoomIn,
                      onTap: () => _zoomBy(1),
                    ),
                    const SizedBox(height: 8),
                    _RoundButton(
                      icon: Icons.remove,
                      tooltip: l10n.mapZoomOut,
                      onTap: () => _zoomBy(-1),
                    ),
                  ],
                ),
              ),
              // Guide panel.
              Positioned(
                left: 16,
                bottom: MediaQuery.paddingOf(context).bottom + 16,
                width: panelWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HowToPanel(
                      sky: sky,
                      expanded: _howExpanded,
                      onToggle: () =>
                          setState(() => _howExpanded = !_howExpanded),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: p.surface.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.mapLongPressHint,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: p.inkMuted, letterSpacing: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _km(double km) {
    final rounded = km.round();
    final s = rounded.toString();
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      out.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) out.write(' ');
    }
    return math.max(0, rounded) == 0 ? '0' : out.toString();
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: p.surface.withValues(alpha: 0.92),
        shape: CircleBorder(
          side: BorderSide(color: p.inkFaint.withValues(alpha: 0.4)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 20, color: p.ink),
          ),
        ),
      ),
    );
  }
}
