package com.kamranbekirov.compass_max

import android.content.Context
import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin

class CompassMaxPlugin : FlutterPlugin, CompassMaxHostApi {

    private lateinit var context: Context
    private lateinit var sensorManager: SensorManager
    private lateinit var streamHandler: CompassStreamHandler

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        streamHandler = CompassStreamHandler(context, sensorManager)

        CompassMaxHostApi.setUp(binding.binaryMessenger, this)
        StreamReadingsStreamHandler.register(binding.binaryMessenger, streamHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        streamHandler.stop()

        CompassMaxHostApi.setUp(binding.binaryMessenger, null)
    }

    override fun capabilities(callback: (Result<RawCompassCapabilities>) -> Unit) {
        val hasMagnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) != null
        val hasGyroscope = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) != null
        val bestSource = OrientationSourceFactory.bestAvailableSource(sensorManager)

        callback(
            Result.success(
                RawCompassCapabilities(
                    hasCompass = bestSource != RawCompassSource.UNKNOWN,
                    hasGyroscope = hasGyroscope,
                    hasMagnetometer = hasMagnetometer,
                    reportsHeadingAccuracy =
                        bestSource != RawCompassSource.ACCELEROMETER_MAGNETOMETER,
                    bestAvailableSource = bestSource,
                )
            )
        )
    }

    override fun setLocation(location: RawLocation?) {
        streamHandler.setLocation(location)
    }
}

/**
 * Assembles one [RawCompassReading] per sensor sample and pushes it to Dart.
 *
 * Sensors only run while Dart is listening, which is what keeps this off the
 * battery once the compass screen is closed.
 */
internal class CompassStreamHandler(
    private val context: Context,
    private val sensorManager: SensorManager,
) : StreamReadingsStreamHandler() {

    private companion object {
        /** Roughly 30 samples a second, which is more than a dial can show. */
        const val MIN_INTERVAL_MILLIS = 33L
    }

    private val headingSensor = HeadingSensorSource(sensorManager)
    private val magnetometer = MagnetometerSource(sensorManager)

    private var orientationSource: OrientationSource? = null
    private var sink: PigeonEventSink<RawCompassReading>? = null
    private var geomagneticField: GeomagneticField? = null
    private var lastEmittedAt = 0L

    override fun onListen(p0: Any?, sink: PigeonEventSink<RawCompassReading>) {
        this.sink = sink

        val source = OrientationSourceFactory.create(context, sensorManager)

        if (source == null) {
            sink.error(
                "SENSOR_NOT_FOUND",
                "This device has no sensor combination that can produce a heading.",
                null,
            )
            sink.endOfStream()

            return
        }

        orientationSource = source
        magnetometer.start()
        headingSensor.start()
        source.start(this::onOrientation)
    }

    override fun onCancel(p0: Any?) {
        stop()
    }

    fun stop() {
        orientationSource?.stop()
        orientationSource = null
        headingSensor.stop()
        magnetometer.stop()
        sink = null
        lastEmittedAt = 0L
    }

    fun setLocation(location: RawLocation?) {
        geomagneticField = location?.let {
            GeomagneticField(
                it.latitude.toFloat(),
                it.longitude.toFloat(),
                it.altitudeMeters.toFloat(),
                System.currentTimeMillis(),
            )
        }
    }

    private fun onOrientation(reading: OrientationReading) {
        val sink = this.sink ?: return
        val now = System.currentTimeMillis()

        if (now - lastEmittedAt < MIN_INTERVAL_MILLIS) {
            return
        }

        lastEmittedAt = now

        val field = geomagneticField

        // Prefer the dedicated heading sensor when the device has one: it is
        // already referenced to true north and carries its own error estimate.
        val sensorHeading = headingSensor.heading
        val magneticHeading: Float
        val trueHeading: Float?

        if (sensorHeading != null) {
            trueHeading = sensorHeading
            magneticHeading = field
                ?.let { OrientationMath.normalize(sensorHeading - it.declination) }
                ?: sensorHeading
        } else {
            magneticHeading = reading.azimuth
            trueHeading = field?.let {
                OrientationMath.normalize(reading.azimuth + it.declination)
            }
        }

        val accuracyDegrees = headingSensor.accuracyDegrees ?: reading.accuracyDegrees

        sink.success(
            RawCompassReading(
                magneticHeading = magneticHeading.toDouble(),
                trueHeading = trueHeading?.toDouble(),
                headingAccuracyDegrees = accuracyDegrees?.toDouble(),
                pitchDegrees = reading.pitch.toDouble(),
                rollDegrees = reading.roll.toDouble(),
                fieldStrengthMicroTesla = magnetometer.fieldStrength?.toDouble(),
                // GeomagneticField reports nanotesla, the sensors microtesla.
                expectedFieldStrengthMicroTesla = field?.let { it.fieldStrength / 1000.0 },
                sensorAccuracy = reading.sensorAccuracy,
                source = if (sensorHeading != null) RawCompassSource.HEADING else reading.source,
                timestampMillis = now,
            )
        )
    }
}
