import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_go_client/qibla_go_client.dart';

import '../../../core/serverpod/client.dart';

/// Seam over the generated Serverpod client so the form can be tested with
/// a fake. Throws on transport failure; callers treat any throw as offline.
abstract interface class SupportApi {
  Future<SupportChallenge?> challenge();

  Future<SupportSubmitResult> submit({
    required String challengeId,
    required int answer,
    required String message,
    String? contact,
    String? platform,
  });
}

final supportApiProvider = Provider<SupportApi>(
  (ref) => ServerpodSupportApi(ref),
);

final class ServerpodSupportApi implements SupportApi {
  ServerpodSupportApi(this._ref);

  final Ref _ref;

  Future<Client> get _client => _ref.read(serverpodClientProvider.future);

  @override
  Future<SupportChallenge?> challenge() async =>
      (await _client).support.challenge();

  @override
  Future<SupportSubmitResult> submit({
    required String challengeId,
    required int answer,
    required String message,
    String? contact,
    String? platform,
  }) async => (await _client).support.submit(
    challengeId: challengeId,
    answer: answer,
    message: message,
    contact: contact,
    platform: platform,
  );
}
