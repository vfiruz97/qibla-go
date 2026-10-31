package com.kamranbekirov.compass_max

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlin.math.sqrt

/**
 * Raw magnetic field magnitude, in microtesla.
 *
 * This is what makes interference detectable rather than guessable: compared
 * against what the World Magnetic Model predicts for the user's coordinates,
 * a reading far off means there is metal or a magnet nearby, no matter how
 * confident the platform's own accuracy flag is.
 */
internal class MagnetometerSource(
    private val sensorManager: SensorManager,
) : SensorEventListener {

    private companion object {
        const val ALPHA = 0.2f
    }

    private val sensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

    val isAvailable: Boolean
        get() = sensor != null

    /** Smoothed field magnitude, or null before the first reading. */
    var fieldStrength: Float? = null
        private set

    fun start() {
        val sensor = this.sensor ?: return

        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
    }

    fun stop() {
        sensorManager.unregisterListener(this)
        fieldStrength = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || event.values.size < 3) {
            return
        }

        val magnitude = sqrt(
            event.values[0] * event.values[0] +
                event.values[1] * event.values[1] +
                event.values[2] * event.values[2]
        )

        if (magnitude.isNaN() || magnitude.isInfinite()) {
            return
        }

        val previous = fieldStrength
        fieldStrength = if (previous == null) {
            magnitude
        } else {
            previous + ALPHA * (magnitude - previous)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}
