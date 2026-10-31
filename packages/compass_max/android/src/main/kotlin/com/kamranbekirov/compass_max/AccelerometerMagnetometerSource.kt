package com.kamranbekirov.compass_max

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorManager

/**
 * Orientation fused by hand from gravity and the magnetic field.
 *
 * The last resort, for devices with neither a gyroscope nor a geomagnetic
 * rotation vector. Noticeably noisier, so both inputs are low passed before
 * the matrix is built.
 */
internal class AccelerometerMagnetometerSource(
    private val context: Context,
    sensorManager: SensorManager,
    private val accelerometer: Sensor,
    private val magnetometer: Sensor,
) : BaseSensorSource(sensorManager, listOf(accelerometer, magnetometer)) {

    private companion object {
        const val ALPHA = 0.2f
    }

    override val source: RawCompassSource = RawCompassSource.ACCELEROMETER_MAGNETOMETER

    private val gravity = FloatArray(3)
    private val geomagnetic = FloatArray(3)
    private val rotationMatrix = FloatArray(9)
    private val inclinationMatrix = FloatArray(9)

    private var hasGravity = false
    private var hasGeomagnetic = false

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) {
            return
        }

        when (event.sensor.type) {
            accelerometer.type -> {
                lowPass(event.values, gravity)
                hasGravity = true
            }
            magnetometer.type -> {
                lowPass(event.values, geomagnetic)
                hasGeomagnetic = true
            }
            else -> return
        }

        if (!hasGravity || !hasGeomagnetic) {
            return
        }

        val didBuild = SensorManager.getRotationMatrix(
            rotationMatrix,
            inclinationMatrix,
            gravity,
            geomagnetic,
        )

        if (!didBuild) {
            return
        }

        val angles = OrientationMath.anglesFrom(
            rotationMatrix,
            SurfaceRotation.of(context),
        )

        emit(
            OrientationReading(
                azimuth = angles.azimuth,
                pitch = angles.pitch,
                roll = angles.roll,
                accuracyDegrees = null,
                sensorAccuracy = sensorAccuracy,
                source = source,
            )
        )
    }

    private fun lowPass(input: FloatArray, output: FloatArray) {
        for (index in output.indices) {
            output[index] = output[index] + ALPHA * (input[index] - output[index])
        }
    }
}
