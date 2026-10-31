import '../models/compass_config.dart';
import '../models/compass_condition.dart';

/// Holds each condition steady so the UI never flickers.
///
/// A raw verdict changes several times a second. Binding a warning strip
/// straight to it would strobe. Each condition has to be true continuously before
/// it appears, and false continuously before it goes, longer to appear than
/// to go, so warnings are slow to arrive and quick to leave.
class ConditionDebouncer {
  ConditionDebouncer({
    this.thresholds = const CompassThresholds(),
  });

  final CompassThresholds thresholds;

  final Set<CompassCondition> _committed = <CompassCondition>{};
  final Map<CompassCondition, DateTime> _appearingSince =
      <CompassCondition, DateTime>{};
  final Map<CompassCondition, DateTime> _clearingSince =
      <CompassCondition, DateTime>{};

  /// Feeds the raw verdict for this sample and returns the conditions to show,
  /// sorted most severe first.
  List<CompassCondition> update({
    required Set<CompassCondition> candidates,
    required DateTime timestamp,
  }) {
    for (final CompassCondition condition in CompassCondition.values) {
      final bool isCandidate = candidates.contains(condition);
      final bool isCommitted = _committed.contains(condition);

      if (isCandidate == isCommitted) {
        _appearingSince.remove(condition);
        _clearingSince.remove(condition);

        continue;
      }

      if (isCandidate) {
        _clearingSince.remove(condition);
        final DateTime since = _appearingSince[condition] ??= timestamp;

        if (timestamp.difference(since) >= thresholds.appearAfter) {
          _committed.add(condition);
          _appearingSince.remove(condition);
        }

        continue;
      }

      _appearingSince.remove(condition);
      final DateTime since = _clearingSince[condition] ??= timestamp;

      if (timestamp.difference(since) >= thresholds.clearAfter) {
        _committed.remove(condition);
        _clearingSince.remove(condition);
      }
    }

    return _sorted();
  }

  void reset() {
    _committed.clear();
    _appearingSince.clear();
    _clearingSince.clear();
  }

  List<CompassCondition> _sorted() {
    final List<CompassCondition> conditions = _committed.toList()
      ..sort(
        (CompassCondition a, CompassCondition b) {
          return a.index.compareTo(b.index);
        },
      );

    return List<CompassCondition>.unmodifiable(conditions);
  }
}
