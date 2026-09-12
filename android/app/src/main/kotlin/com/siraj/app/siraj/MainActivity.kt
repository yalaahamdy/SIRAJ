package com.siraj.app.siraj

import android.app.AlarmManager
import android.app.KeyguardManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.audiofx.Equalizer
import android.media.audiofx.LoudnessEnhancer
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val OVERLAY_CHANNEL = "com.siraj.app/native_overlay"
    private val AUDIO_BOOSTER_CHANNEL = "com.siraj.app/audio_booster"

    private var loudnessEnhancer: LoudnessEnhancer? = null
    private var equalizer: Equalizer? = null
    private var currentBoostLevel: Double = 1.0
    private var isDeNoiseEnabled: Boolean = true

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
                "getDeviceTimeZone" -> {
                    try {
                        val tzId = java.util.TimeZone.getDefault().id
                        result.success(tzId)
                    } catch (e: Exception) {
                        result.success(null)
                    }
                }
                "canScheduleExactAlarms" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val alarmManager = getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                        result.success(alarmManager?.canScheduleExactAlarms() ?: true)
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
                "isIgnoringBatteryOptimizations" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                        val isIgnoring = powerManager?.isIgnoringBatteryOptimizations(packageName) ?: false
                        result.success(isIgnoring)
                    } else {
                        result.success(true)
                    }
                }
                "requestIgnoreBatteryOptimizations" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        try {
                            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                                data = Uri.parse("package:$packageName")
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                                startActivity(intent)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.success(false)
                            }
                        }
                    } else {
                        result.success(true)
                    }
                }
                "scheduleNativeAlarm" -> {
                    try {
                        val id = call.argument<Int>("id") ?: 99998
                        val title = call.argument<String>("title") ?: "أذان سِراج — الله أكبر"
                        val body = call.argument<String>("body") ?: "حي على الصلاة، حي على الفلاح"
                        val triggerAtMillis = call.argument<Long>("triggerAtMillis") ?: (System.currentTimeMillis() + 10000)
                        val sound = call.argument<String>("sound") ?: "athan_abdulbasit"

                        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        val intent = Intent(this, SirajAlarmReceiver::class.java).apply {
                            putExtra(SirajAlarmReceiver.EXTRA_ID, id)
                            putExtra(SirajAlarmReceiver.EXTRA_TITLE, title)
                            putExtra(SirajAlarmReceiver.EXTRA_BODY, body)
                            putExtra(SirajAlarmReceiver.EXTRA_SOUND, sound)
                        }

                        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or
                                (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
                        val pendingIntent = PendingIntent.getBroadcast(this, id, intent, pendingFlags)

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerAtMillis, pendingIntent)
                            alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
                        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                        } else {
                            alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "cancelNativeAlarm" -> {
                    try {
                        val id = call.argument<Int>("id") ?: 99998
                        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        val intent = Intent(this, SirajAlarmReceiver::class.java)
                        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or
                                (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
                        val pendingIntent = PendingIntent.getBroadcast(this, id, intent, pendingFlags)
                        alarmManager.cancel(pendingIntent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "showNativeNotificationNow" -> {
                    try {
                        val id = call.argument<Int>("id") ?: 99999
                        val title = call.argument<String>("title") ?: "تجربة أذان سِراج الفورية"
                        val body = call.argument<String>("body") ?: "الله أكبر — التنبيهات والصوت تعمل بنجاح فوري!"
                        val sound = call.argument<String>("sound") ?: "athan_abdulbasit"

                        val intent = Intent(this, SirajAlarmReceiver::class.java).apply {
                            putExtra(SirajAlarmReceiver.EXTRA_ID, id)
                            putExtra(SirajAlarmReceiver.EXTRA_TITLE, title)
                            putExtra(SirajAlarmReceiver.EXTRA_BODY, body)
                            putExtra(SirajAlarmReceiver.EXTRA_SOUND, sound)
                        }
                        sendBroadcast(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "stopActiveSound" -> {
                    SirajAlarmReceiver.stopActiveSound()
                    result.success(true)
                }
                "openNotificationSettings" -> {
                    try {
                        val intent = Intent().apply {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
                                putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                            } else {
                                action = "android.settings.APP_NOTIFICATION_SETTINGS"
                                putExtra("app_package", packageName)
                                putExtra("app_uid", applicationInfo.uid)
                            }
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "openAutoStartSettings" -> {
                    val intents = listOf(
                        Intent().setComponent(android.content.ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
                        Intent().setComponent(android.content.ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity")),
                        Intent().setComponent(android.content.ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
                        Intent().setComponent(android.content.ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")),
                        Intent().setComponent(android.content.ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
                        Intent().setComponent(android.content.ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
                        Intent().setComponent(android.content.ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
                        Intent().setComponent(android.content.ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
                        Intent().setComponent(android.content.ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
                        Intent().setComponent(android.content.ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")),
                        Intent().setComponent(android.content.ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")),
                        Intent().setComponent(android.content.ComponentName("com.htc.pitroad", "com.htc.pitroad.landingpage.activity.LandingPageActivity")),
                        Intent().setComponent(android.content.ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.entry.FunctionActivity"))
                    )
                    var opened = false
                    for (intent in intents) {
                        try {
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            opened = true
                            break
                        } catch (_: Exception) {}
                    }
                    result.success(opened)
                }
                else -> result.notImplemented()
            }
        }

        // 2. Hardware/Software Audio Volume Booster (LoudnessEnhancer up to 200% + Vocal De-Noising Equalizer)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_BOOSTER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setBoostLevel" -> {
                    val level = call.argument<Double>("level") ?: 1.0
                    val deNoise = call.argument<Boolean>("deNoise") ?: isDeNoiseEnabled
                    isDeNoiseEnabled = deNoise
                    applyBoost(level, deNoise)
                    result.success(true)
                }
                "setDeNoise" -> {
                    val deNoise = call.argument<Boolean>("enabled") ?: true
                    isDeNoiseEnabled = deNoise
                    applyBoost(currentBoostLevel, deNoise)
                    result.success(true)
                }
                "getBoostLevel" -> {
                    result.success(currentBoostLevel)
                }
                "isDeNoiseEnabled" -> {
                    result.success(isDeNoiseEnabled)
                }
                "isSupported" -> {
                    result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun applyBoost(level: Double, deNoise: Boolean = isDeNoiseEnabled) {
        try {
            currentBoostLevel = level
            isDeNoiseEnabled = deNoise

            // 1. Loudness Enhancer for clean overall gain up to +16 dB
            if (level <= 1.0 && !deNoise) {
                loudnessEnhancer?.enabled = false
                loudnessEnhancer?.release()
                loudnessEnhancer = null

                equalizer?.enabled = false
                equalizer?.release()
                equalizer = null
            } else {
                if (level > 1.0) {
                    if (loudnessEnhancer == null) {
                        loudnessEnhancer = LoudnessEnhancer(0)
                    }
                    val gainMb = ((level - 1.0) * 1600).toInt().coerceIn(0, 2000)
                    loudnessEnhancer?.setTargetGain(gainMb)
                    loudnessEnhancer?.enabled = true
                } else {
                    loudnessEnhancer?.enabled = false
                }

                // 2. Equalizer Notch Filtering for De-Noising & Vocal Intelligibility
                if (deNoise) {
                    applyEqualizerDeNoise(true)
                } else {
                    equalizer?.enabled = false
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error applying audio boost and de-noise: ${e.message}")
        }
    }

    private fun applyEqualizerDeNoise(enable: Boolean) {
        try {
            if (!enable) {
                equalizer?.enabled = false
                return
            }
            if (equalizer == null) {
                equalizer = Equalizer(0, 0)
            }
            val eq = equalizer ?: return
            eq.enabled = true
            val numBands = eq.numberOfBands.toInt()
            val minEqLevel = eq.bandLevelRange[0] // e.g. -1500 mB (-15 dB)
            val maxEqLevel = eq.bandLevelRange[1] // e.g. +1500 mB (+15 dB)

            for (band in 0 until numBands) {
                val centerFreqHz = eq.getCenterFreq(band.toShort()) / 1000 // In Hz
                when {
                    // Cut low-frequency rumble & mains power hum (< 200 Hz)
                    centerFreqHz < 200 -> {
                        val level = (minEqLevel * 0.8).toInt().toShort()
                        eq.setBandLevel(band.toShort(), level)
                    }
                    // Speech body resonance (200 Hz - 600 Hz) - slight warm stabilization
                    centerFreqHz in 200..600 -> {
                        eq.setBandLevel(band.toShort(), 0.toShort())
                    }
                    // Speech clarity, consonants & Tajweed presence (800 Hz - 4000 Hz)
                    centerFreqHz in 601..4500 -> {
                        val level = (maxEqLevel * 0.45).toInt().toShort()
                        eq.setBandLevel(band.toShort(), level)
                    }
                    // Cut high tape hiss, static, white noise (> 5000 Hz)
                    else -> {
                        val level = (minEqLevel * 0.75).toInt().toShort()
                        eq.setBandLevel(band.toShort(), level)
                    }
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error applying equalizer de-noise: ${e.message}")
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

