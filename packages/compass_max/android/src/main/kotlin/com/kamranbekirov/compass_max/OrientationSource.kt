package com.kamranbekirov.compass_max

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.display.DisplayManager
import android.os.SystemClock
import android.view.Display
import android.view.Surface

/** One orientation reading, still referenced to magnetic north. */
internal data class OrientationReading(
    val azimuth: Float,
    val pitch: Float,
    val roll: Float,
    /** Platform estimate of heading error, or null when it does not report one. */
    val accuracyDegrees: Float?,
    val sensorAccuracy: RawSensorAccuracy,
    val source: RawCompassSource,
)

/**
 * A way of getting the device orientation.
 *
 * Several exist and none of them are present on every device, so
 * [OrientationSourceFactory] walks them in order of quality and returns the
 * best one this device has.
 */
internal interface OrientationSource {

    val source: RawCompassSource

    fun start(onReading: (OrientationReading) -> Unit)

    fun stop()
}

internal object OrientationSourceFactory {

    /**
     * Best available source, or null when the device has no way at all of
     * telling which way it is pointing.
     */
    fun create(context: Context, sensorManager: SensorManager): OrientationSource? {
        val rotationVector = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)

        if (rotationVector != null) {
            return RotationVectorSource(
                context = context,
                sensorManager = sensorManager,
                sensor = rotationVector,
                source = RawCompassSource.ROTATION_VECTOR,
            )
        }

        // No gyroscope. Common on budget devices, and the point at which every
        // other Flutter compass plugin reports "no sensor found".
        val geomagnetic = sensorManager.getDefaultSensor(Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR)

        if (geomagnetic != null) {
            return RotationVectorSource(
                context = context,
                sensorManager = sensorManager,
                sensor = geomagnetic,
                source = RawCompassSource.GEOMAGNETIC_ROTATION_VECTOR,
            )
        }

        val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        val magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        if (accelerometer != null && magnetometer != null) {
            return AccelerometerMagnetometerSource(
                context = context,
                sensorManager = sensorManager,
                accelerometer = accelerometer,
                magnetometer = magnetometer,
            )
        }

        return null
    }

    fun bestAvailableSource(sensorManager: SensorManager): RawCompassSource {
        if (sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR) != null) {
            return RawCompassSource.ROTATION_VECTOR
        }

        if (sensorManager.getDefaultSensor(Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR) != null) {
            return RawCompassSource.GEOMAGNETIC_ROTATION_VECTOR
        }

        val hasAccelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) != null
        val hasMagnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) != null

        if (hasAccelerometer && hasMagnetometer) {
            return RawCompassSource.ACCELEROMETER_MAGNETOMETER
        }

        return RawCompassSource.UNKNOWN
    }
}

internal fun sensorAccuracyOf(accuracy: Int): RawSensorAccuracy {
    return when (accuracy) {
        SensorManager.SENSOR_STATUS_ACCURACY_HIGH -> RawSensorAccuracy.HIGH
        SensorManager.SENSOR_STATUS_ACCURACY_MEDIUM -> RawSensorAccuracy.MEDIUM
        SensorManager.SENSOR_STATUS_ACCURACY_LOW -> RawSensorAccuracy.LOW
        SensorManager.SENSOR_STATUS_UNRELIABLE -> RawSensorAccuracy.UNRELIABLE
        else -> RawSensorAccuracy.UNKNOWN
    }
}

/**
 * Screen rotation as one of the `Surface.ROTATION_*` constants.
 *
 * Read through [DisplayManager] rather than `Context.getDisplay`, because a
 * plugin only ever holds the application context and asking that for a display
 * throws. Cached, because this runs on every sensor sample.
 */
internal object SurfaceRotation {

    private const val CACHE_MILLIS = 500L

    private var cached = Surface.ROTATION_0
    private var readAt = 0L
    private var hasRead = false

    fun of(context: Context): Int {
        val now = SystemClock.elapsedRealtime()

        if (hasRead && now - readAt < CACHE_MILLIS) {
            return cached
        }

        hasRead = true

        readAt = now
        cached = read(context)

        return cached
    }

    private fun read(context: Context): Int {
        val displayManager = context.getSystemService(Context.DISPLAY_SERVICE)
            as? DisplayManager

        return displayManager?.getDisplay(Display.DEFAULT_DISPLAY)?.rotation
            ?: Surface.ROTATION_0
    }
}

/** Shared listener plumbing so each source only implements the maths. */
internal abstract class BaseSensorSource(
    private val sensorManager: SensorManager,
    private val sensors: List<Sensor>,
) : OrientationSource, SensorEventListener {

    protected var sensorAccuracy: RawSensorAccuracy = RawSensorAccuracy.UNKNOWN
        private set

    private var onReading: ((OrientationReading) -> Unit)? = null

    override fun start(onReading: (OrientationReading) -> Unit) {
        this.onReading = onReading

        for (sensor in sensors) {
            sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME)
        }
    }

    override fun stop() {
        sensorManager.unregisterListener(this)
        onReading = null
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        if (sensor == null || sensors.none { it.type == sensor.type }) {
            return
        }

        sensorAccuracy = sensorAccuracyOf(accuracy)
    }

    protected fun emit(reading: OrientationReading) {
        onReading?.invoke(reading)
    }
}
