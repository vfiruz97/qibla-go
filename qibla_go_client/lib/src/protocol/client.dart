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
import 'package:qibla_go_client/src/protocol/support/support_challenge.dart'
    as _ikpsm4jw;
import 'package:qibla_go_client/src/protocol/support/support_submit_result.dart'
    as _iiq4zk6w;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

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
    health = EndpointHealth(this);
    support = EndpointSupport(this);
  }

  late final EndpointHealth health;

  late final EndpointSupport support;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'health': health,
    'support': support,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
