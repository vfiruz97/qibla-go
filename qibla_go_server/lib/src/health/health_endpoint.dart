import 'package:serverpod/serverpod.dart';

/// Lets the app confirm the server is reachable before it tries to sync.
///
/// This is the only endpoint today. It is public on purpose: the app has no
/// user accounts, and every future endpoint stays public and read-mostly.
class HealthEndpoint extends Endpoint {
  /// Returns the server's current UTC time, so the client can also detect a
  /// badly skewed device clock (which would shift prayer times).
  Future<DateTime> ping(Session session) async {
    return DateTime.now().toUtc();
  }
}
