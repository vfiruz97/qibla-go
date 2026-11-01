/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:qibla_go_client/src/protocol/analytics/analytics_event_input.dart'
    as _io41fdcy;
import 'package:qibla_go_client/src/protocol/support/support_challenge.dart'
    as _ikpsm4jw;
import 'package:qibla_go_client/src/protocol/support/support_submit_result.dart'
    as _iiq4zk6w;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Anonymous usage events from the app. Write-only: nothing reads them back
/// through the API; counting happens in the database.
///
/// No challenge here (the app sends in the background, and a wrong batch
/// costs nothing but a row), so [AnalyticsGuard] carries the whole burden:
/// allowlists, bounds and an hourly budget per client address. The address
/// is used in memory only and never stored or logged.
/// {@category Endpoint}
class EndpointAnalytics extends _isc.EndpointRef {
  EndpointAnalytics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Stores the acceptable events of one batch and returns how many were
  /// stored. Always answers; a refused batch is 0, never an error, so the
  /// app has nothing to retry or report.
  _ida.Future<int> record({
    required String sessionId,
    required String platform,
    String? appVersion,
    String? language,
    required List<_io41fdcy.AnalyticsEventInput> events,
  }) => caller.callServerEndpoint<int>(
    'analytics',
    'record',
    {
      'sessionId': sessionId,
      'platform': platform,
      'appVersion': appVersion,
      'language': language,
      'events': events,
    },
  );
}

/// Lets the app confirm the server is reachable before it tries to sync.
///
/// This is the only endpoint today. It is public on purpose: the app has no
/// user accounts, and every future endpoint stays public and read-mostly.
/// {@category Endpoint}
class EndpointHealth extends _isc.EndpointRef {
  EndpointHealth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  /// Returns the server's current UTC time, so the client can also detect a
  /// badly skewed device clock (which would shift prayer times).
  _ida.Future<DateTime> ping() => caller.callServerEndpoint<DateTime>(
    'health',
    'ping',
    {},
  );
}

/// "Write to us": stores a message from a user. No account needed, so abuse
/// is handled by [SupportGuard] (arithmetic challenge + per-client rate
/// limits). The client address is used only in memory for the limits and is
/// never stored or logged.
/// {@category Endpoint}
class EndpointSupport extends _isc.EndpointRef {
  EndpointSupport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'support';

  /// A question to answer before [submit]. Null when this client has asked
  /// for too many challenges in the last hour.
  _ida.Future<_ikpsm4jw.SupportChallenge?> challenge() =>
      caller.callServerEndpoint<_ikpsm4jw.SupportChallenge?>(
        'support',
        'challenge',
        {},
      );

  /// Stores [message] when [answer] solves [challengeId] and the limits
  /// allow it. [contact] is optional and only for replying. [platform] and
  /// [appVersion] are short tags to help triage; never a device id.
  _ida.Future<_iiq4zk6w.SupportSubmitResult> submit({
    required String challengeId,
    required int answer,
    required String message,
    String? contact,
    String? platform,
    String? appVersion,
  }) => caller.callServerEndpoint<_iiq4zk6w.SupportSubmitResult>(
    'support',
    'submit',
    {
      'challengeId': challengeId,
      'answer': answer,
      'message': message,
      'contact': contact,
      'platform': platform,
      'appVersion': appVersion,
    },
  );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    analytics = EndpointAnalytics(this);
    health = EndpointHealth(this);
    support = EndpointSupport(this);
  }

  late final EndpointAnalytics analytics;

  late final EndpointHealth health;

  late final EndpointSupport support;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'analytics': analytics,
    'health': health,
    'support': support,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
