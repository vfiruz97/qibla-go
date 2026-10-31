import '../../../core/location/location_models.dart';

/// Location as the qibla feature sees it.
final class LocationState {
  const LocationState({
    this.fix,
    this.problem = LocationProblem.none,
    this.isRefreshing = false,
  });

  /// Best known position, possibly cached or manual. Null until the user has
  /// ever granted location or typed one in.
  final LocationFix? fix;

  /// Why the last refresh produced nothing. Soft when [fix] is non-null.
  final LocationProblem problem;

  final bool isRefreshing;

  bool get hasFix => fix != null;

  LocationState copyWith({
    LocationFix? fix,
    bool clearFix = false,
    LocationProblem? problem,
    bool? isRefreshing,
  }) => LocationState(
    fix: clearFix ? null : (fix ?? this.fix),
    problem: problem ?? this.problem,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );
}
