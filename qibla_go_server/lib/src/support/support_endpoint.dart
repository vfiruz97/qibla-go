import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'support_guard.dart';

/// "Write to us": stores a message from a user. No account needed, so abuse
/// is handled by [SupportGuard] (arithmetic challenge + per-client rate
/// limits). The client address is used only in memory for the limits and is
/// never stored or logged.
class SupportEndpoint extends Endpoint {
  /// One guard per server process; see [SupportGuard] for the scale note.
  static final guard = SupportGuard();

  /// A question to answer before [submit]. Null when this client has asked
  /// for too many challenges in the last hour.
  Future<SupportChallenge?> challenge(Session session) async {
    final issued = guard.issue(_clientKey(session));
    if (issued == null) return null;
    return SupportChallenge(
      id: issued.id,
      question: issued.question,
      expiresAt: issued.expiresAt,
    );
  }

  /// Stores [message] when [answer] solves [challengeId] and the limits
  /// allow it. [contact] is optional and only for replying. [platform] and
  /// [appVersion] are short tags to help triage; never a device id.
  Future<SupportSubmitResult> submit(
    Session session, {
    required String challengeId,
    required int answer,
    required String message,
    String? contact,
    String? platform,
    String? appVersion,
  }) async {
    final client = _clientKey(session);
    switch (guard.check(
      client: client,
      challengeId: challengeId,
      answer: answer,
    )) {
      case GuardVerdict.tooManyRequests:
        return SupportSubmitResult.tooManyRequests;
      case GuardVerdict.challengeExpired:
        return SupportSubmitResult.challengeExpired;
      case GuardVerdict.wrongAnswer:
        return SupportSubmitResult.wrongAnswer;
      case GuardVerdict.ok:
        break;
    }

    final text = SupportGuard.normalizeMessage(message);
    final contactValue = SupportGuard.normalizeOptional(
      contact,
      SupportGuard.maxContactLength,
    );
    final platformValue = SupportGuard.normalizeOptional(
      platform,
      SupportGuard.maxTagLength,
    );
    final versionValue = SupportGuard.normalizeOptional(
      appVersion,
      SupportGuard.maxTagLength,
    );
    if (text == null ||
        identical(contactValue, SupportGuard.invalid) ||
        identical(platformValue, SupportGuard.invalid) ||
        identical(versionValue, SupportGuard.invalid)) {
      return SupportSubmitResult.messageInvalid;
    }

    final stored = await SupportMessage.db.insertRow(
      session,
      SupportMessage(
        message: text,
        contact: contactValue as String?,
        platform: platformValue as String?,
        appVersion: versionValue as String?,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    guard.recordAccepted(client);
    // Content and contact are deliberately not logged.
    session.log('support message stored id=${stored.id}');
    return SupportSubmitResult.accepted;
  }

  /// Something that identifies the caller well enough to rate-limit: the
  /// first X-Forwarded-For address behind a proxy, else the socket address.
  /// Not persisted anywhere.
  static String _clientKey(Session session) {
    final request = session.request;
    if (request == null) return 'unknown';
    final forwarded = request.headers.xForwardedFor?.addresses;
    if (forwarded != null && forwarded.isNotEmpty) return forwarded.first;
    return request.connectionInfo.remote.address.toString();
  }
}
