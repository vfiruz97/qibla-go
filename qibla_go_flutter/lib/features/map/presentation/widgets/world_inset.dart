import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../../app/theme/qibla_palette.dart';
import 'kaaba_marker.dart';
import 'map_tiles.dart';

/// Circular mini-map showing the whole line from the user to Makkah, so
/// the street-level line is visibly the start of a real journey.
///
/// Keeps one map alive across location changes (recreating it reloads every
/// tile and flashes); the camera is refitted instead.
class WorldInset extends StatefulWidget {
  const WorldInset({
    super.key,
    required this.user,
    required this.kaaba,
    required this.path,
    required this.onTap,
    this.diameter = 150,
  });

  final LatLng user;
  final LatLng kaaba;
  final List<LatLng> path;
  final VoidCallback onTap;
  final double diameter;

  @override
  State<WorldInset> createState() => _WorldInsetState();
}

class _WorldInsetState extends State<WorldInset> {
  final _map = MapController();
  final _tiles = qiblaTileLayer();

  CameraFit _fit() => CameraFit.coordinates(
    coordinates: [widget.user, widget.kaaba],
    padding: const EdgeInsets.all(28),
  );

  @override
  void didUpdateWidget(WorldInset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user ||
        oldWidget.diameter != widget.diameter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _map.fitCamera(_fit());
      });
    }
  }

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    final user = widget.user;
    final kaaba = widget.kaaba;
    final diameter = widget.diameter;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: p.gold.withValues(alpha: 0.7), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: IgnorePointer(
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCameraFit: _fit(),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
                backgroundColor: p.surface,
              ),
              children: [
                _tiles,
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.path,
                      color: p.gold,
                      strokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: user,
                      width: 10,
                      height: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p.goldBright,
                        ),
                      ),
                    ),
                    Marker(
                      point: kaaba,
                      width: 16,
                      height: 18,
                      child: const KaabaMarker(size: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
