import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'siraj_media_notification_service.dart';
import 'siraj_native_overlay_bridge.dart';

/// معالج الإشعارات في الخلفية (يُشغَّل في Isolate منفصل عند إغلاق التطبيق)
/// REQUIRED annotation: يجب أن يكون خارج الكلاس وعلى مستوى الملف
@pragma('vm:entry-point')
void sirajNotificationBackgroundHandler(NotificationResponse response) {
  // هذه الدالة تُشغَّل حتى لو كان التطبيق مغلقاً كليًا
  // لا يمكن هنا استخدام BuildContext أو Navigator
  // يمكن هنا فقط تسجيل الحدث أو تنفيذ عمليات خفيفة
  debugPrint('[BGHandler] Notification received in background: id=${response.id}, payload=${response.payload}');
}

/// مدير إشعارات سِراج المحلية للصلوات والأذكار والوسائط (§17, §32)
class SirajNotificationManager {
  static final SirajNotificationManager instance = SirajNotificationManager._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin get notificationsPlugin => _notifications;
  bool _isInitialized = false;

  SirajNotificationManager._internal();

  // إجراءات الإشعارات التفاعلية للأذان
  static const String actionStopAthan = 'action_stop_athan';
  static const String actionSnoozeAthan = 'action_snooze_athan';
  static const String actionOpenPrayer = 'action_open_prayer';
  static const String actionOpenQiblah = 'action_open_qiblah';
  static const String actionOpenAdhkar = 'action_open_adhkar';

  // مستمعات الأحداث التفاعلية
  VoidCallback? onAthanStopRequested;
  VoidCallback? onAthanSnoozeRequested;
  void Function(String actionId, String? payload)? onActionReceived;
  void Function(String? payload)? onNotificationTapped;

  // 1. القناة المخصصة للأذان الصوتي الكامل ذو الأولوية القصوى (Alarm Priority)
  static const String athanChannelId = 'siraj_athan_channel_v6';
  static const String athanChannelName = 'صوت وأذان الصلاة الشريف';
  static const String athanChannelDescription = 'تنبيهات الأذان بصوت الشيخ عبد الباسط عبد الصمد في مواقيت الصلاة';

  // 2. قناة تنبيهات ما قبل الأذان (الاستعداد والوضوء)
  static const String preAthanChannelId = 'siraj_pre_athan_channel_v1';
  static const String preAthanChannelName = 'تنبيهات ما قبل الأذان (الاستعداد والوضوء)';
  static const String preAthanChannelDescription = 'تذكير هادئ قبل 15 دقيقة من دخول الوقت للتجهز للصلاة';

  // 3. قناة تنبيهات إقامة الصلاة
  static const String iqamaChannelId = 'siraj_iqama_channel_v1';
  static const String iqamaChannelName = 'تنبيهات إقامة الصلاة';
  static const String iqamaChannelDescription = 'إشعار تذكيري بحلول موعد إقامة الصلاة بعد الأذان';

  // 4. القناة القياسية للتنبيهات العامة
  static const String standardChannelId = 'siraj_standard_channel_v5';
  static const String standardChannelName = 'تنبيهات الصلوات العامة';
  static const String standardChannelDescription = 'إشعارات دخول الوقت والتذكيرات العامة';

  // 5. قناة أذكار الصباح والمساء والنوم
  static const String adhkarChannelId = 'siraj_adhkar_channel_v1';
  static const String adhkarChannelName = 'أذكار الصباح والمساء والنوم';
  static const String adhkarChannelDescription = 'تذكيرات يومية بأذكار الصباح والمساء والنوم والاستيقاظ';

  // 6. قناة قيام الليل والثلث الأخير
  static const String qiyamChannelId = 'siraj_qiyam_channel_v1';
  static const String qiyamChannelName = 'قيام الليل والثلث الأخير';
  static const String qiyamChannelDescription = 'تنبيه روحي في الثلث الأخير من الليل لصلاة الوتر والتهجد';

  // 7. قناة صلاة الضحى (صلاة الأوابين)
  static const String duhaChannelId = 'siraj_duha_channel_v1';
  static const String duhaChannelName = 'صلاة الضحى (صلاة الأوابين)';
  static const String duhaChannelDescription = 'تذكير يومي بعد الشروق لصلاة الضحى';

  // 8. قناة سنن الجمعة وصيام النوافل والورد القرآني
  static const String fridayFastingChannelId = 'siraj_friday_fasting_channel_v1';
  static const String fridayFastingChannelName = 'سنن الجمعة وصيام النوافل والورد';
  static const String fridayFastingChannelDescription = 'تذكيرات قراءة سورة الكهف، صيام الإثنين والخميس والأيام البيض، ومتابعة الورد';

  Future<void> init() async {
    if (_isInitialized) return;

    await _initTimeZone();

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        _isInitialized = true;
        return;
      }
    } catch (_) {}

    const androidSettings = AndroidInitializationSettings('ic_notification');
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
          debugPrint('Notification clicked: payload=${response.payload}, actionId=${response.actionId}');
          _handleNotificationResponse(response);
        },
        // CRITICAL: يُسجَّل هنا معالج الخلفية ليعمل حتى لو كان التطبيق مغلقاً كليًا
        onDidReceiveBackgroundNotificationResponse: sirajNotificationBackgroundHandler,
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
            'siraj_athan_channel_v4',
            'siraj_athan_channel_v5',
            'siraj_standard_channel_v3',
            'siraj_standard_channel_v4',
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

          // 2. قناة تنبيهات ما قبل الأذان
          const preAthanChannel = AndroidNotificationChannel(
            preAthanChannelId,
            preAthanChannelName,
            description: preAthanChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(preAthanChannel);

          // 3. قناة تنبيهات إقامة الصلاة
          const iqamaChannel = AndroidNotificationChannel(
            iqamaChannelId,
            iqamaChannelName,
            description: iqamaChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(iqamaChannel);

          // 4. قناة التنبيهات القياسية
          const standardChannel = AndroidNotificationChannel(
            standardChannelId,
            standardChannelName,
            description: standardChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(standardChannel);

          // 5. قناة أذكار الصباح والمساء والنوم
          const adhkarChannel = AndroidNotificationChannel(
            adhkarChannelId,
            adhkarChannelName,
            description: adhkarChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(adhkarChannel);

          // 6. قناة قيام الليل والثلث الأخير
          const qiyamChannel = AndroidNotificationChannel(
            qiyamChannelId,
            qiyamChannelName,
            description: qiyamChannelDescription,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          );
          await androidPlugin.createNotificationChannel(qiyamChannel);

          // 7. قناة صلاة الضحى
          const duhaChannel = AndroidNotificationChannel(
            duhaChannelId,
            duhaChannelName,
            description: duhaChannelDescription,
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: false,
          );
          await androidPlugin.createNotificationChannel(duhaChannel);

          // 8. قناة سنن الجمعة وصيام النوافل والورد القرآني
          const fridayFastingChannel = AndroidNotificationChannel(
            fridayFastingChannelId,
            fridayFastingChannelName,
            description: fridayFastingChannelDescription,
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: false,
          );
          await androidPlugin.createNotificationChannel(fridayFastingChannel);

          // 9. قناة وسائط التشغيل الصامتة (للتحكم في الراديو والتواشيح والقرآن)
          const mediaChannel = AndroidNotificationChannel(
            SirajMediaNotificationService.mediaChannelId,
            SirajMediaNotificationService.mediaChannelName,
            description: SirajMediaNotificationService.mediaChannelDescription,
            importance: Importance.low,
            playSound: false,
            enableVibration: false,
          );
          await androidPlugin.createNotificationChannel(mediaChannel);
        }
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing SirajNotificationManager: $e');
    }
  }

  Future<void> _initTimeZone() async {
    try {
      tz.initializeTimeZones();

      // 1. استعلام مباشر ودقيق من نظام أندرويد الأصلي عن المعرف الحقيقي لمنطقة الهاتف الزمنية
      String? nativeTz;
      if (!kIsWeb && Platform.isAndroid) {
        try {
          nativeTz = await SirajNativeOverlayBridge.getDeviceTimeZone();
        } catch (_) {}
      }

      if (nativeTz != null && tz.timeZoneDatabase.locations.containsKey(nativeTz)) {
        tz.setLocalLocation(tz.getLocation(nativeTz));
        debugPrint('SirajNotificationManager: Successfully set local timezone from native OS to: $nativeTz');
        return;
      }

      // 2. مطابقة ذكية حسابية متوافقة مع الفارق الزمني الحالي للهاتف
      final now = DateTime.now();
      final currentOffset = now.timeZoneOffset;
      tz.Location? matched;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == currentOffset) {
          matched = loc;
          break;
        }
      }

      if (matched != null) {
        tz.setLocalLocation(matched);
        debugPrint('SirajNotificationManager: Matched local timezone by offset: ${matched.name}');
      } else {
        // افتراض توقيت القاهرة أو مكة كأصل عربي بدلاً من تصفيره لـ UTC
        if (tz.timeZoneDatabase.locations.containsKey('Africa/Cairo')) {
          tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
        } else if (tz.timeZoneDatabase.locations.containsKey('Asia/Riyadh')) {
          tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
        } else {
          tz.setLocalLocation(tz.local);
        }
      }
    } catch (e) {
      debugPrint('Error setting up timezone: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          final granted = await androidPlugin.requestNotificationsPermission();
          try {
            final canSchedule = await SirajNativeOverlayBridge.canScheduleExactAlarms();
            if (!canSchedule) {
              await androidPlugin.requestExactAlarmsPermission();
            }
          } catch (_) {}
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

  /// يفحص ما إذا كانت الإشعارات مفعلة ومسموح بها حالياً في إعدادات النظام
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return true;
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return true;
    } catch (_) {}
    if (Platform.isAndroid) {
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.areNotificationsEnabled() ?? true;
    }
    return true;
  }

  /// يفحص تفاصيل إطلاق التطبيق وما إذا كان قد فُتح عبر إشعار أذان أو منبه
  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async {
    if (!_isInitialized) await init();
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return null;
    } catch (_) {}
    return await _notifications.getNotificationAppLaunchDetails();
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
      icon: 'ic_notification',
      fullScreenIntent: true,
      ticker: title,
      actions: _buildAthanActions(playAthanSound),
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
      await SirajNativeOverlayBridge.wakeScreenAndShowOverLockscreen();
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
        icon: 'ic_notification',
        fullScreenIntent: true,
        ticker: title,
        actions: _buildAthanActions(playAthanSound),
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

       await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzTime,
        notificationDetails: notificationDetails,
        payload: payload,
      );

      // جدولة متوازية في نظام أندرويد الأصلي عبر AlarmManager.setAlarmClock كشبكة أمان مطلقة
      try {
        await SirajNativeOverlayBridge.scheduleNativeAlarm(
          id: id,
          title: title,
          body: body,
          triggerAtMillis: scheduledTime.millisecondsSinceEpoch,
          sound: playAthanSound ? 'athan_abdulbasit' : '',
        );
      } catch (_) {}

      debugPrint('Successfully scheduled prayer alarm notification for: $scheduledTime (id: $id)');
    } catch (e) {
      debugPrint('Error scheduling prayer notification: $e');
    }
  }

  /// جدولة آمنة تطبق وضع AlarmClock بأعلى أولوية منبه في أندرويد، ثم exactAllowWhileIdle، ثم inexact
  Future<void> _safeZonedSchedule({
    required int id,
    required String? title,
    required String? body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    String? payload,
  }) async {
    try {
      // 1. تجربة AlarmClock أولاً (أعلى وأضمن وضع منبه في أندرويد لا يخضع لتوفير الطاقة)
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: payload,
      );
      return;
    } catch (alarmClockEx) {
      debugPrint('AlarmClock mode not supported or restricted, trying exactAllowWhileIdle: $alarmClockEx');
    }

    try {
      // 2. تجربة exactAllowWhileIdle
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (exactAlarmEx) {
      debugPrint('Exact alarm failed (permission/battery restrictions), fallback to inexact: $exactAlarmEx');
      try {
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      } catch (e) {
        debugPrint('Failed to schedule notification (id: $id): $e');
      }
    }
  }

  /// يجدول إشعاراً ومنبهاً اختبارياً خارجياً ينطلق بعد ثوانٍ محددة (افتراضياً 10 ثوانٍ)
  /// ليتسنى للمستخدم قفل الشاشة والتحقق من استيقاظ الهاتف وانطلاق الأذان خارجياً
  Future<bool> scheduleQuickTestNotification({int seconds = 10}) async {
    if (!_isInitialized) await init();
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return true;
    } catch (_) {}

    final now = DateTime.now();
    final targetTime = now.add(Duration(seconds: seconds));
    final tzTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

    final androidDetails = AndroidNotificationDetails(
      athanChannelId,
      athanChannelName,
      channelDescription: athanChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('athan_abdulbasit'),
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      icon: 'ic_notification',
      fullScreenIntent: true,
      ticker: 'تجربة إشعار سِراج الخارجي',
      actions: _buildAthanActions(true),
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'athan_abdulbasit.mp3',
    );

    // 1. جدولة عبر flutter_local_notifications (AlarmClock mode)
    await _safeZonedSchedule(
      id: 99998,
      title: 'تجربة إشعار سِراج الخارجي 🔔',
      body: 'الله أكبر — نجح انطلاق المنبه والصوت خارج التطبيق وفوق شاشة القفل بنجاح تام!',
      scheduledDate: tzTime,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: 'siraj_test_outside_notification',
    );

    // 2. جدولة متوازية أصلية مضمونة 100% عبر نظام أندرويد AlarmManager.setAlarmClock
    try {
      await SirajNativeOverlayBridge.scheduleNativeAlarm(
        id: 99998,
        title: 'تجربة منبه سِراج الخارجي 🔔',
        body: 'الله أكبر — المنبه الأصلي وصوت الأذان يعمل فوق شاشة القفل!',
        triggerAtMillis: targetTime.millisecondsSinceEpoch,
        sound: 'athan_abdulbasit',
      );
    } catch (_) {}

    return true;
  }

  /// إرسال إشعار وصوت تجريبي فوري حالاً (بدون أي انتظار) للتأكد من خروج الصوت وعمل القناة فوراً
  Future<bool> showImmediateTestNotification() async {
    if (!_isInitialized) await init();
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return true;
    } catch (_) {}

    // 1. عبر flutter_local_notifications
    await showPrayerNotification(
      id: 99997,
      title: 'تجربة إشعار فوري — سِراج 🔔',
      body: 'الله أكبر — الإشعارات وصوت الأذان تعمل بنجاح فوري وبنقاء تام!',
      playAthanSound: true,
      payload: 'siraj_test_immediate',
    );

    // 2. عبر النظام الأصلي المباشر
    try {
      await SirajNativeOverlayBridge.showNativeNotificationNow(
        id: 99997,
        title: 'تجربة إشعار فوري — سِراج 🔔',
        body: 'الله أكبر — الإشعارات وصوت الأذان تعمل بنجاح فوري وبنقاء تام!',
        sound: 'athan_abdulbasit',
      );
    } catch (_) {}

    return true;
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
      await SirajNativeOverlayBridge.cancelNativeAlarm(id);
    } catch (_) {}
  }

  Future<void> cancelAll() async {
    try {
      await _notifications.cancelAll();
    } catch (_) {}
  }

  /// يوزع إجراءات الأزرار المنبثقة من الإشعارات
  void _handleNotificationResponse(NotificationResponse response) {
    if (response.actionId == actionStopAthan) {
      onAthanStopRequested?.call();
    } else if (response.actionId == actionSnoozeAthan) {
      onAthanSnoozeRequested?.call();
    } else if (response.actionId != null && response.actionId!.startsWith('siraj_media_')) {
      SirajMediaNotificationService.instance.handleAction(response.actionId!);
    } else if (response.actionId == null || response.actionId!.isEmpty) {
      onNotificationTapped?.call(response.payload);
    }
    onActionReceived?.call(response.actionId ?? '', response.payload);
  }

  /// يبني أزرار الإجراءات التفاعلية للأذان
  List<AndroidNotificationAction> _buildAthanActions(bool isAthan) {
    if (!isAthan) return const [];
    return const [
      AndroidNotificationAction(
        actionStopAthan,
        'إيقاف الأذان',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      AndroidNotificationAction(
        actionSnoozeAthan,
        'تأجيل 5 دقائق',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      AndroidNotificationAction(
        actionOpenPrayer,
        'مواقيت الصلاة',
        showsUserInterface: true,
        cancelNotification: false,
      ),
      AndroidNotificationAction(
        actionOpenQiblah,
        'اتجاه القبلة',
        showsUserInterface: true,
        cancelNotification: false,
      ),
    ];
  }

  /// إرسال إشعار تذكير بالأذكار (صباح / مساء / نوم)
  Future<void> scheduleAdhkarNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        adhkarChannelId,
        adhkarChannelName,
        channelDescription: adhkarChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: payload ?? 'siraj_adhkar',
      );
    } catch (e) {
      debugPrint('Error scheduling adhkar notification: $e');
    }
  }

  /// إرسال إشعار تذكير بقيام الليل في الثلث الأخير
  Future<void> scheduleQiyamNotification({
    required int id,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        qiyamChannelId,
        qiyamChannelName,
        channelDescription: qiyamChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: 'قيام الليل — ركعة في جوف الليل',
        body: 'الوتر جنة القلوب ونور الظلمات، استثمر الثلث الأخير من الليل بالدعاء والمناجاة',
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: 'siraj_qiyam',
      );
    } catch (e) {
      debugPrint('Error scheduling qiyam notification: $e');
    }
  }

  /// إرسال إشعار تذكير بصلاة الضحى
  Future<void> scheduleDuhaNotification({
    required int id,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        duhaChannelId,
        duhaChannelName,
        channelDescription: duhaChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: 'صلاة الضحى — صلاة الأوابين',
        body: 'يصبح على كل سلامى من أحدكم صدقة، وتجزئ عن ذلك ركعتان يركعهما من الضحى',
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: 'siraj_duha',
      );
    } catch (e) {
      debugPrint('Error scheduling duha notification: $e');
    }
  }

  /// إرسال إشعار بسنن يوم الجمعة (سورة الكهف والصلاة على النبي ﷺ)
  Future<void> scheduleFridayReminder({
    required int id,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        fridayFastingChannelId,
        fridayFastingChannelName,
        channelDescription: fridayFastingChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: 'نور بين الجمعتين — سورة الكهف',
        body: 'من قرأ سورة الكهف في يوم الجمعة أضاء له من النور ما بين الجمعتين، وأكثروا من الصلاة على الحبيب ﷺ',
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: 'siraj_friday',
      );
    } catch (e) {
      debugPrint('Error scheduling Friday reminder: $e');
    }
  }

  /// إرسال إشعار تذكير بورد التحفيظ القرآني اليومي
  Future<void> scheduleQuranWirdNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        fridayFastingChannelId,
        fridayFastingChannelName,
        channelDescription: fridayFastingChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: payload ?? 'siraj_quran_wird',
      );
    } catch (e) {
      debugPrint('Error scheduling Quran wird notification: $e');
    }
  }

  /// إرسال إشعار تذكير بالصيام (سحور / إفطار)
  Future<void> scheduleFastingNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    final now = DateTime.now();
    if (!scheduledTime.isAfter(now)) return;

    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      final tzTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      const androidDetails = AndroidNotificationDetails(
        fridayFastingChannelId,
        fridayFastingChannelName,
        channelDescription: fridayFastingChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_notification',
      );
      await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        payload: payload ?? 'siraj_fasting',
      );
    } catch (e) {
      debugPrint('Error scheduling fasting notification: $e');
    }
  }
}
