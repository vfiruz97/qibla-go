import 'compass_diagnostics.dart';
import 'compass_condition.dart';

/// One compass reading.
///
/// Three fields: a number you rotate a widget by, a list you translate, and a
/// bag you never open unless you want the numbers behind the list.
///
/// [heading] is never null. When declination is unknown it falls back to the
/// magnetic heading rather than going missing, so callers never have to guard
/// the one value they always need.
class CompassEvent {
  const CompassEvent({
    required this.heading,
    required this.conditions,
    required this.diagnostics,
  });

  /// Degrees clockwise from true north, `0..360`, smoothed.
  ///
  /// Already declination corrected, so it can be compared directly against a
  /// bearing calculated from coordinates.
  final double heading;

  /// What the compass noticed, most distorting first. Empty means there is
  /// nothing to report.
  final List<CompassCondition> conditions;

  final CompassDiagnostics diagnostics;

  /// The one condition worth a sentence of UI, or null when there is nothing to
  /// say.
  CompassCondition? get topCondition {
    return conditions.isEmpty ? null : conditions.first;
  }

  @override
  String toString() {
    return 'CompassEvent(heading: ${heading.toStringAsFixed(1)}, '
        'conditions: $conditions)';
  }
}
