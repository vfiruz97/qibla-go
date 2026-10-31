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
import 'package:serverpod/serverpod.dart' as _is;
import '../health/health_endpoint.dart' as _id9paj9q;
import '../support/support_endpoint.dart' as _iqxms0ns;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'health': _id9paj9q.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'support': _iqxms0ns.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
    };
    connectors['health'] = _is.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'ping': _is.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['health'] as _id9paj9q.HealthEndpoint).ping(
                session,
              ),
        ),
      },
    );
    connectors['support'] = _is.EndpointConnector(
      name: 'support',
      endpoint: endpoints['support']!,
      methodConnectors: {
        'challenge': _is.MethodConnector(
          name: 'challenge',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _iqxms0ns.SupportEndpoint)
                  .challenge(session),
        ),
        'submit': _is.MethodConnector(
          name: 'submit',
          params: {
            'challengeId': _is.ParameterDescription(
              name: 'challengeId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'answer': _is.ParameterDescription(
              name: 'answer',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'contact': _is.ParameterDescription(
              name: 'contact',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'platform': _is.ParameterDescription(
              name: 'platform',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'appVersion': _is.ParameterDescription(
              name: 'appVersion',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _iqxms0ns.SupportEndpoint).submit(
                    session,
                    challengeId: params['challengeId'],
                    answer: params['answer'],
                    message: params['message'],
                    contact: params['contact'],
                    platform: params['platform'],
                    appVersion: params['appVersion'],
                  ),
        ),
      },
    );
  }
}
