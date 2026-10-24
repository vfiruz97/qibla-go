import CoreLocation
import CoreMotion
import Flutter
import UIKit

public class CompassMaxPlugin: NSObject, FlutterPlugin, CompassMaxHostApi {

  private let streamHandler = CompassStreamHandler()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = CompassMaxPlugin()

    CompassMaxHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    StreamReadingsStreamHandler.register(
      with: registrar.messenger(),
      streamHandler: instance.streamHandler
    )
    registrar.publish(instance)
  }

  func capabilities(completion: @escaping (Result<RawCompassCapabilities, Error>) -> Void) {
    let motionManager = CMMotionManager()
    let hasCompass = CLLocationManager.headingAvailable()

    completion(
      .success(
        RawCompassCapabilities(
          hasCompass: hasCompass,
          hasGyroscope: motionManager.isGyroAvailable,
          hasMagnetometer: motionManager.isMagnetometerAvailable,
          // CLHeading always carries headingAccuracy, in degrees.
          reportsHeadingAccuracy: hasCompass,
          bestAvailableSource: hasCompass ? .coreLocation : .unknown
        )
      )
    )
  }

  func setLocation(location: RawLocation?) throws {
    // CoreLocation applies declination itself, so the coordinates are unused
    // on this platform.
  }
}

/// Streams headings from CoreLocation, with tilt and field strength from
/// CoreMotion, so the reading carries the same set of facts as on Android.
///
/// The delegate is a separate object because the generated stream handler is
/// not an `NSObject`, which `CLLocationManagerDelegate` requires.
class CompassStreamHandler: StreamReadingsStreamHandler {

  /// Roughly 30 samples a second, matching the Android side.
  fileprivate static let minInterval: TimeInterval = 0.033

  private let locationManager = CLLocationManager()
  private let motionManager = CMMotionManager()
  private lazy var headingDelegate = HeadingDelegate(
    onHeading: { [weak self] heading in
      self?.onHeading(heading)
    }
  )

  private var sink: PigeonEventSink<RawCompassReading>?
  private var lastEmittedAt: TimeInterval = 0

  override init() {
    super.init()

    locationManager.delegate = headingDelegate
    locationManager.headingFilter = 0.1
  }

  override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<RawCompassReading>) {
    self.sink = sink

    guard CLLocationManager.headingAvailable() else {
      sink.error(
        code: "SENSOR_NOT_FOUND",
        message: "This device has no magnetometer, so it cannot produce a heading.",
        details: nil
      )
      sink.endOfStream()

      return
    }

    startMotionUpdates()
    locationManager.headingOrientation = Self.headingOrientation()
    locationManager.startUpdatingHeading()

    // trueHeading stays invalid unless location updates are also running.
    // The permission is never requested here: with it already granted the
    // heading is true north, without it the heading stays magnetic.
    if isLocationAuthorized() {
      locationManager.startUpdatingLocation()
    }
  }

  override func onCancel(withArguments arguments: Any?) {
    stop()
  }

  func stop() {
    locationManager.stopUpdatingHeading()
    locationManager.stopUpdatingLocation()
    motionManager.stopDeviceMotionUpdates()
    sink = nil
    lastEmittedAt = 0
  }

  private func onHeading(_ newHeading: CLHeading) {
    guard let sink = sink else {
      return
    }

    let now = Date().timeIntervalSince1970

    if now - lastEmittedAt < Self.minInterval {
      return
    }

    lastEmittedAt = now

    let motion = motionManager.deviceMotion
    let accuracy = newHeading.headingAccuracy

    sink.success(
      RawCompassReading(
        magneticHeading: newHeading.magneticHeading,
        trueHeading: newHeading.trueHeading >= 0 ? newHeading.trueHeading : nil,
        headingAccuracyDegrees: accuracy >= 0 ? accuracy : nil,
        pitchDegrees: motion.map { $0.attitude.pitch * 180 / .pi } ?? 0,
        rollDegrees: motion.map { $0.attitude.roll * 180 / .pi } ?? 0,
        fieldStrengthMicroTesla: Self.fieldStrength(from: motion),
        // There is no equivalent of Android's GeomagneticField here, so the
        // Dart layer falls back to the absolute 25 to 65 uT band.
        expectedFieldStrengthMicroTesla: nil,
        sensorAccuracy: Self.sensorAccuracy(from: motion, headingAccuracy: accuracy),
        source: .coreLocation,
        timestampMillis: Int64(now * 1000)
      )
    )
  }

  private func startMotionUpdates() {
    guard motionManager.isDeviceMotionAvailable else {
      return
    }

    motionManager.deviceMotionUpdateInterval = Self.minInterval
    // A magnetic reference frame is required for `magneticField` to be set.
    motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
  }

  private func isLocationAuthorized() -> Bool {
    let status: CLAuthorizationStatus

    if #available(iOS 14.0, *) {
      status = locationManager.authorizationStatus
    } else {
      status = CLLocationManager.authorizationStatus()
    }

    return status == .authorizedWhenInUse || status == .authorizedAlways
  }

  private static func fieldStrength(from motion: CMDeviceMotion?) -> Double? {
    guard let field = motion?.magneticField, field.accuracy != .uncalibrated else {
      return nil
    }

    let x = field.field.x
    let y = field.field.y
    let z = field.field.z

    return (x * x + y * y + z * z).squareRoot()
  }

  private static func sensorAccuracy(
    from motion: CMDeviceMotion?,
    headingAccuracy: CLLocationDirection
  ) -> RawSensorAccuracy {
    if let calibration = motion?.magneticField.accuracy {
      switch calibration {
      case .uncalibrated:
        return .unreliable
      case .low:
        return .low
      case .medium:
        return .medium
      case .high:
        return .high
      @unknown default:
        break
      }
    }

    // Without device motion, derive the level from the reported accuracy.
    if headingAccuracy < 0 {
      return .unreliable
    }

    if headingAccuracy <= 15 {
      return .high
    }

    if headingAccuracy <= 30 {
      return .medium
    }

    return .low
  }

  fileprivate static func headingOrientation() -> CLDeviceOrientation {
    switch UIDevice.current.orientation {
    case .landscapeLeft:
      return .landscapeLeft
    case .landscapeRight:
      return .landscapeRight
    case .portraitUpsideDown:
      return .portraitUpsideDown
    default:
      return .portrait
    }
  }
}

/// Receives the CoreLocation callbacks on behalf of the stream handler.
private class HeadingDelegate: NSObject, CLLocationManagerDelegate {

  private let onHeading: (CLHeading) -> Void

  init(onHeading: @escaping (CLHeading) -> Void) {
    self.onHeading = onHeading
  }

  /// Allows the system calibration sheet to appear. It is presented and
  /// dismissed by the system, so the app has nothing to handle.
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    onHeading(newHeading)
  }
}
