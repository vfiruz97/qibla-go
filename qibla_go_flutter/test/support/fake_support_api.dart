import 'package:qibla_go_client/qibla_go_client.dart';
import 'package:qibla_go_flutter/features/support/application/support_api.dart';

/// Scripted stand-in for the support endpoint.
///
/// Issues questions "a + b" with a known answer, records every submit, and
/// can be told what to answer or to throw (offline).
final class FakeSupportApi implements SupportApi {
  FakeSupportApi({this.answer = 12});

  /// The correct answer to every issued question ("7 + 5" by default).
  final int answer;

  /// Set to make the next call(s) fail as if the server were unreachable.
  bool offline = false;

  /// Returned by [submit] when the answer is right.
  SupportSubmitResult onCorrect = SupportSubmitResult.accepted;

  /// Null makes [challenge] return null (rate limited).
  bool challengesAvailable = true;

  int issued = 0;
  final submits =
      <
        ({
          String challengeId,
          int answer,
          String message,
          String? contact,
          String? platform,
        })
      >[];

  @override
  Future<SupportChallenge?> challenge() async {
    if (offline) throw StateError('offline');
    if (!challengesAvailable) return null;
    issued++;
    return SupportChallenge(
      id: 'challenge-$issued',
      question: '7 + ${answer - 7}',
      expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<SupportSubmitResult> submit({
    required String challengeId,
    required int answer,
    required String message,
    String? contact,
    String? platform,
  }) async {
    if (offline) throw StateError('offline');
    submits.add((
      challengeId: challengeId,
      answer: answer,
      message: message,
      contact: contact,
      platform: platform,
    ));
    if (challengeId != 'challenge-$issued') {
      return SupportSubmitResult.challengeExpired;
    }
    return answer == this.answer ? onCorrect : SupportSubmitResult.wrongAnswer;
  }
}
