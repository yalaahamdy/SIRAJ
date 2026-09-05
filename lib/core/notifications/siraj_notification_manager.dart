import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// مدير إشعارات سِراج المحلية للصلوات والأذكار (§17, §32)
class SirajNotificationManager {
  static final SirajNotificationManager instance = SirajNotificationManager._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  SirajNotificationManager._internal();

  // القناة المخصصة للأذان الصوتي الكامل ذو الأولوية القصوى
  static const String athanChannelId = 'siraj_athan_channel_v4';
  static const String athanChannelName = 'صوت وأذان الصلاة الشريف';
  static const String athanChannelDescription = 'تنبيهات الأذان بصوت الشيخ عبد الباسط عبد الصمد في مواقيت الصلاة';

  // القناة القياسية للتنبيهات الصامتة والمبكرة
  static const String standardChannelId = 'siraj_standard_channel_v4';
  static const String standardChannelName = 'تنبيهات الصلوات العامة';
  static const String standardChannelDescription = 'إشعارات دخول الوقت والإقامة والتذكير قبل الأذان';

  Future<void> init() async {
    if (_isInitialized) return;

    _initTimeZone();

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        _isInitialized = true;
        return;
      }
    } catch (_) {}

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const linuxSettings = LinuxInitializationSettings(defaultActionName: 'Open');

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    try {
      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      // إنشاء قنوات أندرويد الرسمية
      if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          // تنظيف القنوات السابقة لضمان تحديث إعدادات صوت المنبه على نظام أندرويد
          for (final oldId in [
            'siraj_athan_channel_v1',
            'siraj_athan_channel_v2',
            'siraj_athan_channel_v3',
            'siraj_standard_channel_v3',
          ]) {
            try {
              await androidPlugin.deleteNotificationChannel(channelId: oldId);
            } catch (_) {}
          }

          // 1. قناة الأذان الصوتي الكامل (تنبيه منبه بأقصى أولوية مع صوت raw/athan_abdulbasit)
          const athanChannel = AndroidNotificationChannel(
            athanChannelId,
            athanChannelName,
            description: athanChannelDescription,
            importance: Importance.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('athan_abdulbasit'),
            enableVibration: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
          );
          await androidPlugin.createNotificationChannel(athanChannel);

          // 2. قناة التنبيهات القياسية
          const standardChannel = AndroidNotificationChannel(
            standardChannelId,
            standardChannelName,
            description: standardChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(standardChannel);
        }
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing SirajNotificationManager: $e');
    }
  }

  void _initTimeZone() {
    try {
      tz.initializeTimeZones();
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      tz.Location? matched;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == offset) {
          matched = loc;
          break;
        }
      }
      if (matched != null) {
        tz.setLocalLocation(matched);
      } else {
        tz.setLocalLocation(tz.UTC);
      }
    } catch (e) {
      debugPrint('Error setting up timezone: $e');
      try {
        tz.setLocalLocation(tz.UTC);
      } catch (_) {}
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          final granted = await androidPlugin.requestNotificationsPermission();
          await androidPlugin.requestExactAlarmsPermission();
          return granted ?? false;
        }
      } else if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        if (iosPlugin != null) {
          final granted = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        }
      }
    } catch (_) {}
    return false;
  }

  /// إرسال إشعار فوري بحلول وقت الصلاة مع تشغيل صوت الأذان
  Future<void> showPrayerNotification({
    required int id,
    required String title,
    required String body,
    bool playAthanSound = true,
    String? payload,
  }) async {
    if (!_isInitialized) await init();

    final androidDetails = AndroidNotificationDetails(
      playAthanSound ? athanChannelId : standardChannelId,
      playAthanSound ? athanChannelName : standardChannelName,
      channelDescription: playAthanSound ? athanChannelDescription : standardChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: playAthanSound ? const RawResourceAndroidNotificationSound('athan_abdulbasit') : null,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/ic_launcher',
      fullScreenIntent: true,
      ticker: title,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'athan_abdulbasit.mp3',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing prayer notification: $e');
    }
  }

  /// جدولة إشعار ومنبه دقيق في موعد الصلاة في الخلفية (Exact Alarm)
  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool playAthanSound = true,
    String? payload,
  }) async {
    if (!_isInitialized) await init();

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return;
      }
    } catch (_) {}

    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      // بناء التوقيت المحلي بدقة بالغة وفق منطقة الجهاز الزمنية
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );

      final androidDetails = AndroidNotificationDetails(
        playAthanSound ? athanChannelId : standardChannelId,
        playAthanSound ? athanChannelName : standardChannelName,
        channelDescription: playAthanSound ? athanChannelDescription : standardChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: playAthanSound ? const RawResourceAndroidNotificationSound('athan_abdulbasit') : null,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher',
        fullScreenIntent: true,
        ticker: title,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'athan_abdulbasit.mp3',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      try {
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } catch (exactAlarmEx) {
        debugPrint('Exact alarm failed (permission/battery saver), fallback to inexact: $exactAlarmEx');
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      }
      debugPrint('Successfully scheduled prayer alarm notification for: $scheduledTime (id: $id)');
    } catch (e) {
      debugPrint('Error scheduling prayer notification: $e');
    }
  }

  /// إرسال إشعار تجريبي فوري للتأكد من خروج صوت الأذان على هاتف المستخدم
  Future<void> testAthanNotification() async {
    await showPrayerNotification(
      id: 99999,
      title: 'تجربة أذان سِراج — الله أكبر',
      body: 'هذا إشعار تجريبي للتأكد من انطلاق صوت الأذان الشريف بنقاء',
      playAthanSound: true,
    );
  }

  Future<void> cancel(int id) async {
    try {
      await _notifications.cancel(id: id);
    } catch (_) {}
  }

  Future<void> cancelAll() async {
    try {
      await _notifications.cancelAll();
    } catch (_) {}
  }
}
