package com.siraj.app.siraj

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat

class SirajAlarmReceiver : BroadcastReceiver() {

    companion object {
        const val CHANNEL_ID = "siraj_athan_channel_v6"
        const val CHANNEL_NAME = "صوت وأذان الصلاة الشريف"
        const val EXTRA_ID = "siraj_alarm_id"
        const val EXTRA_TITLE = "siraj_alarm_title"
        const val EXTRA_BODY = "siraj_alarm_body"
        const val EXTRA_SOUND = "siraj_alarm_sound"

        private var activeMediaPlayer: MediaPlayer? = null

        fun stopActiveSound() {
            try {
                activeMediaPlayer?.stop()
                activeMediaPlayer?.release()
                activeMediaPlayer = null
            } catch (_: Exception) {}
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getIntExtra(EXTRA_ID, 99998)
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "أذان سِراج — الله أكبر"
        val body = intent.getStringExtra(EXTRA_BODY) ?: "حي على الصلاة، حي على الفلاح"
        val soundResName = intent.getStringExtra(EXTRA_SOUND) ?: "athan_abdulbasit"

        Log.d("SirajAlarmReceiver", "Alarm received: id=$id, title=$title, sound=$soundResName")

        // 1. Acquire WakeLock to wake CPU and turn screen on
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
        val wakeLock = powerManager?.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "siraj:alarm_receiver"
        )
        wakeLock?.acquire(20000) // 20 seconds maximum

        // 2. Ensure Notification Channel with Alarm priority
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val soundUri = Uri.parse("android.resource://${context.packageName}/raw/$soundResName")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val audioAttr = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "تنبيهات الأذان الشريف في مواقيت الصلاة"
                enableVibration(true)
                if (soundResName.isNotEmpty()) {
                    setSound(soundUri, audioAttr)
                }
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            notificationManager.createNotificationChannel(channel)
        }

        // 3. Launch intent for clicking or full screen
        val launchIntent = (context.packageManager.getLaunchIntentForPackage(context.packageName) ?: Intent(context, MainActivity::class.java)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("payload", "siraj_athan_alarm")
        }

        val pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT or
                (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)

        val pendingIntent = PendingIntent.getActivity(context, id, launchIntent, pendingFlags)

        // Stop Action Intent
        val stopIntent = Intent(context, SirajAlarmStopReceiver::class.java)
        val stopPendingIntent = PendingIntent.getBroadcast(
            context,
            id + 1000,
            stopIntent,
            pendingFlags
        )

        val smallIconResId = context.resources.getIdentifier("ic_notification", "drawable", context.packageName).let {
            if (it != 0) it else context.applicationInfo.icon
        }

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(smallIconResId)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .setFullScreenIntent(pendingIntent, true)
            .addAction(android.R.drawable.ic_media_pause, "إيقاف الأذان", stopPendingIntent)

        if (soundResName.isNotEmpty()) {
            builder.setSound(soundUri, AudioManager.STREAM_ALARM)
        }

        try {
            notificationManager.notify(id, builder.build())
        } catch (e: Exception) {
            Log.e("SirajAlarmReceiver", "Error posting notification: ${e.message}")
        }

        // 4. Guaranteed Audio playback via MediaPlayer directly
        if (soundResName.isNotEmpty()) {
            val soundId = context.resources.getIdentifier(soundResName, "raw", context.packageName)
            if (soundId != 0) {
                try {
                    stopActiveSound()
                    activeMediaPlayer = MediaPlayer().apply {
                        setAudioAttributes(
                            AudioAttributes.Builder()
                                .setUsage(AudioAttributes.USAGE_ALARM)
                                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                .build()
                        )
                        setDataSource(context, soundUri)
                        prepare()
                        start()
                        setOnCompletionListener { mp ->
                            try {
                                mp.release()
                            } catch (_: Exception) {}
                            activeMediaPlayer = null
                            try {
                                if (wakeLock?.isHeld == true) {
                                    wakeLock.release()
                                }
                            } catch (_: Exception) {}
                        }
                    }
                } catch (e: Exception) {
                    Log.e("SirajAlarmReceiver", "Error playing media player: ${e.message}")
                    try {
                        if (wakeLock?.isHeld == true) {
                            wakeLock.release()
                        }
                    } catch (_: Exception) {}
                }
            } else {
                try {
                    if (wakeLock?.isHeld == true) {
                        wakeLock.release()
                    }
                } catch (_: Exception) {}
            }
        } else {
            try {
                if (wakeLock?.isHeld == true) {
                    wakeLock.release()
                }
            } catch (_: Exception) {}
        }
    }
}

class SirajAlarmStopReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        SirajAlarmReceiver.stopActiveSound()
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }
}
