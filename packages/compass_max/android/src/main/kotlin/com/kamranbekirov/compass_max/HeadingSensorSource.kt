package com.kamranbekirov.compass_max

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build

/**
 * Android 13's dedicated heading sensor, used as an overlay.
 *
 * It reports a true north heading and an error estimate in degrees, both
 * better than anything derivable from the rotation vector, but it says nothing
 * about tilt. So the rotation vector chain still runs for pitch and roll and
 * this simply overrides the heading when the device has it.
 */
internal class HeadingSensorSource(
    private val sensorManager: SensorManager,
) : SensorEventListener {

    private val sensor: Sensor? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        sensorManager.getDefaultSensor(Sensor.TYPE_HEADING)
    } else {
        null
    }

    val isAvailable: Boolean
        get() = sensor != null

    /** True north heading in degrees, or null before the first reading. */
    var heading: Float? = null
        private set

    /** Reported error in degrees, or null when the device omits it. */
    var accuracyDegrees: Float? = null
        private set

    fun start() {
        val sensor = this.sensor ?: return

        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME)
    }

    fun stop() {
        sensorManager.unregisterListener(this)
        heading = null
        accuracyDegrees = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || event.values.isEmpty()) {
            return
        }

        heading = OrientationMath.normalize(event.values[0])
        accuracyDegrees = if (event.values.size > 1 && event.values[1] >= 0f) {
            event.values[1]
        } else {
            null
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}
