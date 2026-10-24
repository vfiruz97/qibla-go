package com.kamranbekirov.compass_max

import android.hardware.SensorManager
import android.view.Surface

/**
 * Turns a rotation matrix into a heading.
 *
 * The matrix is expressed in the device's own frame, so it is remapped for the
 * current display rotation before the angles are read. The flat mapping also
 * degenerates as the device approaches vertical, where the azimuth can no
 * longer be recovered from it, so a second mapping is used past that tilt.
 */
internal object OrientationMath {

    /** Past this much tilt the phone is being held up rather than laid flat. */
    private const val UPRIGHT_PITCH_DEGREES = 55f

    private val remapped = FloatArray(9)
    private val orientation = FloatArray(3)

    data class Angles(
        val azimuth: Float,
        val pitch: Float,
        val roll: Float,
    )

    /**
     * @param rotationMatrix a 9 element matrix from [SensorManager.getRotationMatrixFromVector]
     * @param surfaceRotation one of the [Surface] rotation constants
     */
    @Synchronized
    fun anglesFrom(rotationMatrix: FloatArray, surfaceRotation: Int): Angles {
        val flat = remapForScreen(rotationMatrix, surfaceRotation, upright = false)
        val pitch = Math.toDegrees(flat[1].toDouble()).toFloat()

        // Held upright the flat mapping degenerates, so read the heading off
        // the axis that is still horizontal instead.
        if (kotlin.math.abs(pitch) > UPRIGHT_PITCH_DEGREES) {
            val upright = remapForScreen(rotationMatrix, surfaceRotation, upright = true)

            return Angles(
                azimuth = normalize(Math.toDegrees(upright[0].toDouble()).toFloat()),
                pitch = pitch,
                roll = Math.toDegrees(flat[2].toDouble()).toFloat(),
            )
        }

        return Angles(
            azimuth = normalize(Math.toDegrees(flat[0].toDouble()).toFloat()),
            pitch = pitch,
            roll = Math.toDegrees(flat[2].toDouble()).toFloat(),
        )
    }

    private fun remapForScreen(
        rotationMatrix: FloatArray,
        surfaceRotation: Int,
        upright: Boolean,
    ): FloatArray {
        val axisX: Int
        val axisY: Int

        if (upright) {
            axisX = SensorManager.AXIS_X
            axisY = SensorManager.AXIS_Z
        } else {
            when (surfaceRotation) {
                Surface.ROTATION_90 -> {
                    axisX = SensorManager.AXIS_Y
                    axisY = SensorManager.AXIS_MINUS_X
                }
                Surface.ROTATION_180 -> {
                    axisX = SensorManager.AXIS_MINUS_X
                    axisY = SensorManager.AXIS_MINUS_Y
                }
                Surface.ROTATION_270 -> {
                    axisX = SensorManager.AXIS_MINUS_Y
                    axisY = SensorManager.AXIS_X
                }
                else -> {
                    axisX = SensorManager.AXIS_X
                    axisY = SensorManager.AXIS_Y
                }
            }
        }

        SensorManager.remapCoordinateSystem(rotationMatrix, axisX, axisY, remapped)
        SensorManager.getOrientation(remapped, orientation)

        return orientation
    }

    fun normalize(degrees: Float): Float {
        if (degrees.isNaN() || degrees.isInfinite()) {
            return 0f
        }

        val wrapped = degrees % 360f

        return if (wrapped < 0f) wrapped + 360f else wrapped
    }

    /**
     * Copies a rotation vector down to four elements.
     *
     * The sensor may report up to five elements, but
     * [SensorManager.getRotationMatrixFromVector] throws on some devices when
     * given more than four.
     */
    fun truncateRotationVector(values: FloatArray): FloatArray {
        if (values.size <= 4) {
            return values
        }

        return values.copyOfRange(0, 4)
    }
}
