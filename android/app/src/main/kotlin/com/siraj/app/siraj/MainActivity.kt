package com.siraj.app.siraj

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.media.audiofx.LoudnessEnhancer
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val OVERLAY_CHANNEL = "com.siraj.app/native_overlay"
    private val AUDIO_BOOSTER_CHANNEL = "com.siraj.app/audio_booster"

    private var loudnessEnhancer: LoudnessEnhancer? = null
    private var currentBoostLevel: Double = 1.0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        wakeAndUnlock()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. Native Overlay and Lockscreen Wake Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "wakeScreenAndShowOverLockscreen" -> {
                    wakeAndUnlock()
                    result.success(true)
                }
                "bringAppToForeground" -> {
                    wakeAndUnlock()
                    val intent = Intent(this, MainActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_SINGLE_TOP
                    }
                    startActivity(intent)
                    result.success(true)
                }
                "isScreenLocked" -> {
                    val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
                    val isLocked = keyguardManager?.isKeyguardLocked ?: false
                    result.success(isLocked)
                }
                "checkOverlayPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        result.success(Settings.canDrawOverlays(this))
                    } else {
                        result.success(true)
                    }
                }
                "requestOverlayPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        )
                        startActivity(intent)
                        result.success(true)
                    } else {
                        result.success(true)
                    }
                }
                "requestFullScreenIntentPermission" -> {
                    if (Build.VERSION.SDK_INT >= 34) {
                        try {
                            val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                                data = Uri.parse("package:$packageName")
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    } else {
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // 2. Hardware/Software Audio Volume Booster (LoudnessEnhancer up to 200%)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_BOOSTER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setBoostLevel" -> {
                    val level = call.argument<Double>("level") ?: 1.0
                    applyBoost(level)
                    result.success(true)
                }
                "getBoostLevel" -> {
                    result.success(currentBoostLevel)
                }
                "isSupported" -> {
                    result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun applyBoost(level: Double) {
        try {
            currentBoostLevel = level
            if (level <= 1.0) {
                loudnessEnhancer?.enabled = false
                loudnessEnhancer?.release()
                loudnessEnhancer = null
            } else {
                if (loudnessEnhancer == null) {
                    loudnessEnhancer = LoudnessEnhancer(0)
                }
                // Convert boost 1.0..2.0 to millibels (0..1600 mB = 0..16 dB)
                val gainMb = ((level - 1.0) * 1600).toInt().coerceIn(0, 2000)
                loudnessEnhancer?.setTargetGain(gainMb)
                loudnessEnhancer?.enabled = true
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error applying loudness boost: ${e.message}")
        }
    }

    private fun wakeAndUnlock() {
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
            keyguardManager?.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }

    override fun onDestroy() {
        try {
            loudnessEnhancer?.enabled = false
            loudnessEnhancer?.release()
            loudnessEnhancer = null
        } catch (_: Exception) {}
        super.onDestroy()
    }
}

