import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/qibla_palette.dart';
import '../../../../core/geo/geo_point.dart';
import '../../../../core/location/location_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/location_controller.dart';

/// Bottom sheet for seeing, refreshing or typing the position.
class LocationSheet extends ConsumerStatefulWidget {
  const LocationSheet({super.key, this.startWithForm = false});

  final bool startWithForm;

  static Future<void> show(BuildContext context, {bool startWithForm = false}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LocationSheet(startWithForm: startWithForm),
    );
  }

  @override
  ConsumerState<LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends ConsumerState<LocationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _lat = TextEditingController();
  final _lon = TextEditingController();
  late bool _showForm = widget.startWithForm;

  @override
  void initState() {
    super.initState();
    final fix = ref.read(locationControllerProvider).fix;
    if (fix != null) {
      _lat.text = fix.point.latitude.toStringAsFixed(5);
      _lon.text = fix.point.longitude.toStringAsFixed(5);
    }
  }

  @override
  void dispose() {
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(locationControllerProvider);
    final fix = state.fix;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 4, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            fix == null ? l10n.locationNeededTitle : l10n.locationSheetTitle,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (fix == null)
            Text(l10n.locationNeededBody, style: text.bodyMedium)
          else
            _FixSummary(fix: fix),
          if (state.problem != LocationProblem.none) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: p.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _problemText(l10n, state.problem),
                    style: text.bodySmall?.copyWith(color: p.warning),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.isRefreshing
                      ? null
                      : () => ref
                            .read(locationControllerProvider.notifier)
                            .refresh(),
                  icon: state.isRefreshing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: p.background,
                          ),
                        )
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(
                    state.isRefreshing
                        ? l10n.locationLocating
                        : l10n.locationUseMyLocation,
                  ),
                ),
              ),
              if (state.problem == LocationProblem.permissionDeniedForever ||
                  state.problem == LocationProblem.servicesDisabled) ...[
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => ref
                      .read(locationControllerProvider.notifier)
                      .openSettings(),
                  child: Text(l10n.locationOpenSettings),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          if (!_showForm)
            OutlinedButton.icon(
              onPressed: () => setState(() => _showForm = true),
              icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
              label: Text(l10n.locationEnterCoordinates),
            )
          else
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lat,
                          decoration: InputDecoration(
                            labelText: l10n.locationLatitude,
                            hintText: l10n.locationLatitudeHint,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          validator: (v) => _validate(v, 90) == null
                              ? l10n.locationInvalidLatitude
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lon,
                          decoration: InputDecoration(
                            labelText: l10n.locationLongitude,
                            hintText: l10n.locationLongitudeHint,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          validator: (v) => _validate(v, 180) == null
                              ? l10n.locationInvalidLongitude
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _submit,
                    child: Text(l10n.locationSave),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static double? _validate(String? raw, double limit) {
    if (raw == null) return null;
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (value == null || value.isNaN || value.abs() > limit) return null;
    return value;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final point = GeoPoint(
      latitude: _validate(_lat.text, 90)!,
      longitude: _validate(_lon.text, 180)!,
    );
    await ref.read(locationControllerProvider.notifier).setManual(point);
    if (mounted) Navigator.of(context).pop();
  }

  static String _problemText(
    AppLocalizations l10n,
    LocationProblem problem,
  ) => switch (problem) {
    LocationProblem.none => '',
    LocationProblem.servicesDisabled => l10n.locationProblemServicesDisabled,
    LocationProblem.permissionDenied => l10n.locationProblemPermissionDenied,
    LocationProblem.permissionDeniedForever =>
      l10n.locationProblemPermissionDeniedForever,
    LocationProblem.timeout => l10n.locationProblemTimeout,
    LocationProblem.unavailable => l10n.locationProblemUnavailable,
  };
}

class _FixSummary extends StatelessWidget {
  const _FixSummary({required this.fix});

  final LocationFix fix;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final origin = switch (fix.origin) {
      LocationOrigin.device => l10n.locationOriginDevice,
      LocationOrigin.cached => l10n.locationOriginCached,
      LocationOrigin.manual => l10n.locationOriginManual,
    };
    final parts = <String>[
      origin,
      if (fix.accuracyMeters != null)
        l10n.locationAccuracyMeters(fix.accuracyMeters!.round()),
      formatAge(l10n, DateTime.now().difference(fix.time)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.locationCoordinates(
            fix.point.latitude.toStringAsFixed(4),
            fix.point.longitude.toStringAsFixed(4),
          ),
          style: text.titleMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(parts.join(' · '), style: text.bodySmall),
        if (fix.origin == LocationOrigin.cached) ...[
          const SizedBox(height: 6),
          Text(
            l10n.locationStaleNote,
            style: text.bodySmall?.copyWith(color: p.inkMuted),
          ),
        ],
      ],
    );
  }
}

/// "just now", "3 minutes ago", "2 days ago".
String formatAge(AppLocalizations l10n, Duration age) {
  if (age.inMinutes < 1) return l10n.locationAgeJustNow;
  if (age.inHours < 1) return l10n.locationAgeMinutes(age.inMinutes);
  if (age.inDays < 1) return l10n.locationAgeHours(age.inHours);
  return l10n.locationAgeDays(age.inDays);
}
