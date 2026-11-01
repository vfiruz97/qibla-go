import 'package:qibla_go_flutter/features/rating/application/review_launcher.dart';

/// Records calls; each step can be made to fail.
final class FakeReviewLauncher implements ReviewLauncher {
  FakeReviewLauncher({
    this.available = true,
    this.availabilityThrows = false,
    this.reviewThrows = false,
    this.storeThrows = false,
  });

  bool available;
  bool availabilityThrows;
  bool reviewThrows;
  bool storeThrows;
  final calls = <String>[];

  @override
  Future<bool> isAvailable() async {
    calls.add('isAvailable');
    if (availabilityThrows) throw StateError('no play services');
    return available;
  }

  @override
  Future<void> requestReview() async {
    calls.add('requestReview');
    if (reviewThrows) throw StateError('review failed');
  }

  @override
  Future<void> openStoreListing() async {
    calls.add('openStoreListing');
    if (storeThrows) throw StateError('no store');
  }
}
