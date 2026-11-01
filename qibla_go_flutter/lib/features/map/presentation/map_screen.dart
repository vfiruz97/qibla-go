import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../app/router.dart';
import '../../../app/theme/qibla_palette.dart';
import '../../../core/geo/geo_point.dart';
import '../../../core/geo/great_circle.dart';
import '../../../core/geo/qibla_geometry.dart' as geo;
import '../../../core/location/location_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../qibla/application/location_controller.dart';
import '../../qibla/application/qibla_geometry_provider.dart';
import '../../qibla/presentation/widgets/location_sheet.dart';
import '../application/sky_providers.dart';
import 'widgets/how_to_panel.dart';
import 'widgets/kaaba_marker.dart';
import 'widgets/map_camera_animator.dart';
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

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final _map = MapController();
  final _tiles = qiblaTileLayer();
  late final _camera = MapCameraAnimator(vsync: this, controller: _map);

  /// Drives the marker and the line from the old position to the new one,
  /// so a change of location is a movement, not a cut.
  late final _origin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..addListener(() => setState(() {}));
  GeoPoint? _originFrom;
  GeoPoint? _originTo;

  bool _howExpanded = true;

  /// Set when the next location change comes from a long-press: the user
  /// chose that spot on screen, so the camera must not move away from it.
  bool _skipFollow = false;

  static final _kaaba = LatLng(geo.kaaba.latitude, geo.kaaba.longitude);

  /// Street level: individual buildings are drawn, so the line can be
  /// compared with the houses and roads around the user.
  static const _streetZoom = 17.0;
  static const _minZoom = 2.0;
  static const _maxZoom = 19.0;

  @override
  void dispose() {
    _origin.dispose();
    _camera.dispose();
    _map.dispose();
    super.dispose();
  }

  /// Where the marker is drawn right now: the real position, or a point on
  /// the way there while the move animates.
  GeoPoint? get _shownOrigin {
    final to = _originTo;
    final from = _originFrom;
    if (to == null) return null;
    if (from == null || !_origin.isAnimating) return to;
    final t = Curves.easeInOutCubic.transform(_origin.value);
    return GeoPoint.lerp(from, to, t);
  }

  /// Reacts to a new position: animates the marker there and, unless the
  /// user picked it on the map, flies the camera along.
  void _onPointChanged(GeoPoint point) {
    final previous = _shownOrigin;
    _originFrom = previous;
    _originTo = point;
    if (previous != null) {
      _origin.forward(from: 0);
    }
    final follow = !_skipFollow;
    _skipFollow = false;
    if (follow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _recenter(point);
      });
    }
  }

  /// Flies to the user; on narrow screens the guide panel covers the lower
  /// part of the map, so the marker is placed in the upper third.
  void _recenter(GeoPoint point) {
    final size = _map.camera.nonRotatedSize;
    final shift = size.width >= 860 ? 0.0 : -size.height * 0.17;
    _camera.flyTo(
      LatLng(point.latitude, point.longitude),
      _streetZoom,
      screenOffset: Offset(0, shift),
    );
  }

  void _zoomBy(double delta) =>
      _camera.zoomBy(delta, min: _minZoom, max: _maxZoom);

  void _fitWhole(GeoPoint point) {
    _camera.flyToFit(
      CameraFit.coordinates(
        coordinates: [LatLng(point.latitude, point.longitude), _kaaba],
        padding: const EdgeInsets.all(48),
      ),
    );
  }

  /// Long-press: the marker and the line glide to the pressed spot, which is
  /// confirmation enough; no message, so nothing competes with the map.
  Future<void> _setLocation(LatLng at) async {
    HapticFeedback.selectionClick();
    _skipFollow = true;
    await ref
        .read(locationControllerProvider.notifier)
        .setManual(GeoPoint(latitude: at.latitude, longitude: at.longitude));
  }

  /// "Back to my location": asks the device for the real position (which
  /// replaces a long-pressed or typed one) and flies there. If the device
  /// cannot answer, says why and offers the location sheet.
  Future<void> _goToMyLocation() async {
    final controller = ref.read(locationControllerProvider.notifier);
    await controller.refresh();
    if (!mounted) return;
    final state = ref.read(locationControllerProvider);
    final fix = state.fix;
    if (state.problem == LocationProblem.none && fix != null) {
      // A changed point already flew the camera; the same point would not.
      if (fix.point == _originTo) _recenter(fix.point);
      return;
    }
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(locationProblemText(l10n, state.problem)),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: l10n.locationEnterCoordinates,
            onPressed: () => LocationSheet.show(context, startWithForm: true),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final point = ref.watch(locationPointProvider);
    final locating = ref.watch(
      locationControllerProvider.select((s) => s.isRefreshing),
    );
    final geometry = ref.watch(qiblaGeometryProvider);
    final sky = ref.watch(skySnapshotProvider);

    // A new position (first fix, long-press, typed coordinates, refresh).
    if (point != null && point != _originTo) _onPointChanged(point);

    final shown = _shownOrigin;
    final user = shown == null ? null : LatLng(shown.latitude, shown.longitude);
    final path = shown == null
        ? const <LatLng>[]
        : greatCirclePath(
            shown,
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
                  initialCenter: point == null
                      ? _kaaba
                      : LatLng(point.latitude, point.longitude),
                  initialZoom: point == null ? 4 : _streetZoom,
                  minZoom: _minZoom,
                  maxZoom: _maxZoom,
                  backgroundColor: p.background,
                  onLongPress: (_, at) => _setLocation(at),
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  _tiles,
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
                      origin: user,
                      sunLabel: l10n.mapSun,
                      moonLabel: l10n.mapMoon,
                    ),
                  RichAttributionWidget(
                    alignment: Directionality.of(context) == TextDirection.rtl
                        ? AttributionAlignment.bottomRight
                        : AttributionAlignment.bottomLeft,
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
                    // The compass screen does not exist on the web.
                    if (!kIsWeb) ...[
                      _RoundButton(
                        icon: Icons.explore_outlined,
                        tooltip: l10n.navCompass,
                        onTap: () => context.go(AppRoutes.qibla),
                      ),
                      const SizedBox(width: 10),
                    ],
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
                    _RoundButton(
                      icon: Icons.my_location,
                      tooltip: l10n.mapRecenter,
                      busy: locating,
                      onTap: locating ? null : _goToMyLocation,
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
                    if (point != null)
                      WorldInset(
                        user: LatLng(point.latitude, point.longitude),
                        kaaba: _kaaba,
                        path: path,
                        onTap: () => _fitWhole(point),
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
                      alignment: AlignmentDirectional.centerStart,
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
    this.busy = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  /// Shows a spinner instead of the icon while a request is in flight.
  final bool busy;

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
            child: busy
                ? Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: p.gold,
                      ),
                    ),
                  )
                : Icon(icon, size: 20, color: p.ink),
          ),
        ),
      ),
    );
  }
}
