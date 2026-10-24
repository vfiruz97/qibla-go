package com.kamranbekirov.compass_max

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorManager

/**
 * Orientation from a rotation vector sensor.
 *
 * Backs both `TYPE_ROTATION_VECTOR` and `TYPE_GEOMAGNETIC_ROTATION_VECTOR`,
 * which report identically. The second one simply manages without a
 * gyroscope, at the cost of settling more slowly.
 */
internal class RotationVectorSource(
    private val context: Context,
    sensorManager: SensorManager,
    private val sensor: Sensor,
    override val source: RawCompassSource,
) : BaseSensorSource(sensorManager, listOf(sensor)) {

    private val rotationMatrix = FloatArray(9)

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || event.sensor.type != sensor.type) {
            return
        }

        val values = OrientationMath.truncateRotationVector(event.values)

        if (values.size < 4) {
            return
        }

        try {
            SensorManager.getRotationMatrixFromVector(rotationMatrix, values)
        } catch (error: IllegalArgumentException) {
            // A handful of devices reject their own rotation vector. Dropping
            // the sample keeps the stream alive instead of killing it.
            return
        }

        val angles = OrientationMath.anglesFrom(
            rotationMatrix,
            SurfaceRotation.of(context),
        )

        // The fifth element is the estimated heading error in radians, and it
        // is genuinely absent on many devices rather than merely unset.
        val accuracyDegrees = if (event.values.size > 4 && event.values[4] >= 0f) {
            Math.toDegrees(event.values[4].toDouble()).toFloat()
        } else {
            null
        }

        emit(
            OrientationReading(
                azimuth = angles.azimuth,
                pitch = angles.pitch,
                roll = angles.roll,
                accuracyDegrees = accuracyDegrees,
                sensorAccuracy = sensorAccuracy,
                source = source,
            )
        )
    }
}
