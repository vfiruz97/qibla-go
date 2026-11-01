import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

/// The App Store numeric id, needed to open the listing on iOS. Set at build
/// time once the app exists there: `--dart-define=QIBLA_APP_STORE_ID=…`.
const qiblaAppStoreId = String.fromEnvironment('QIBLA_APP_STORE_ID');

/// Seam over the store review APIs so the controller is testable and
/// widgets never import the plugin.
abstract interface class ReviewLauncher {
  /// Whether the in-app review flow can run here (Play Store present,
  /// supported OS version). False on a sideloaded build or an emulator.
  Future<bool> isAvailable();

  /// Shows the system's own review card (Google Play In-App Review, StoreKit
  /// `requestReview`). Both platforms may silently show nothing when their
  /// quota is spent; neither reports whether a review was written.
  Future<void> requestReview();

  /// Opens the store listing on its review page. Not quota-limited.
  Future<void> openStoreListing();
}

final class InAppReviewLauncher implements ReviewLauncher {
  InAppReviewLauncher(this._plugin, {this.appStoreId = qiblaAppStoreId});

  final InAppReview _plugin;
  final String appStoreId;

  @override
  Future<bool> isAvailable() => _plugin.isAvailable();

  @override
  Future<void> requestReview() => _plugin.requestReview();

  @override
  Future<void> openStoreListing() => _plugin.openStoreListing(
    appStoreId: appStoreId.isEmpty ? null : appStoreId,
  );
}

final reviewLauncherProvider = Provider<ReviewLauncher>(
  (ref) => InAppReviewLauncher(InAppReview.instance),
);
