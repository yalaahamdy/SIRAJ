import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// جسر الربط بين فلاتر ونظام أندرويد لإيقاظ الشاشة وعرض النوافذ فوق شاشة القفل (§17, §32)
class SirajNativeOverlayBridge {
  static const MethodChannel _channel = MethodChannel('com.siraj.app/native_overlay');

  /// يطلب من النظام إيقاظ الشاشة وعرض واجهة التطبيق فوق شاشة القفل فوراً
  static Future<bool> wakeScreenAndShowOverLockscreen() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('wakeScreenAndShowOverLockscreen');
      return res ?? false;
    } catch (e) {
      debugPrint('Error waking screen over lockscreen: $e');
      return false;
    }
  }

  /// يفحص ما إذا كانت شاشة الهاتف مقفلة حالياً
  static Future<bool> isScreenLocked() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('isScreenLocked');
      return res ?? false;
    } catch (e) {
      debugPrint('Error checking if screen is locked: $e');
      return false;
    }
  }

  /// يفحص إذن الظهور فوق التطبيقات الأخرى (System Alert Window / Draw Over Other Apps)
  static Future<bool> checkOverlayPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('checkOverlayPermission');
      return res ?? true;
    } catch (e) {
      debugPrint('Error checking overlay permission: $e');
      return false;
    }
  }

  /// يفتح إعدادات النظام للمستخدم لمنح إذن الظهور فوق التطبيقات
  static Future<bool> requestOverlayPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('requestOverlayPermission');
      return res ?? false;
    } catch (e) {
      debugPrint('Error requesting overlay permission: $e');
      return false;
    }
  }

  /// يطلب إذن الشاشة الكاملة فوق القفل في أندرويد 14 فما فوق (USE_FULL_SCREEN_INTENT)
  static Future<bool> requestFullScreenIntentPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('requestFullScreenIntentPermission');
      return res ?? false;
    } catch (e) {
      debugPrint('Error requesting full screen intent permission: $e');
      return false;
    }
  }

  /// يجلب التطبيق إلى الواجهة الأمامية ويوقظ الشاشة
  static Future<bool> bringAppToForeground() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('bringAppToForeground');
      return res ?? false;
    } catch (e) {
      debugPrint('Error bringing app to foreground: $e');
      return false;
    }
  }

  /// يفحص ما إذا كان التطبيق مستثنى من قيود توفير الطاقة والبطارية
  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return res ?? true;
    } catch (e) {
      debugPrint('Error checking battery optimization status: $e');
      return false;
    }
  }

  /// يطلب من النظام استثناء التطبيق من قيود توفير الطاقة لضمان عمل منبه الأذان في الخلفية
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('requestIgnoreBatteryOptimizations');
      return res ?? false;
    } catch (e) {
      debugPrint('Error requesting ignore battery optimization: $e');
      return false;
    }
  }

  /// يستعلم عن المعرف الحقيقي لمنطقة الجهاز الزمنية من نظام أندرويد النواة
  static Future<String?> getDeviceTimeZone() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<String>('getDeviceTimeZone');
    } catch (e) {
      debugPrint('Error getting device timezone from native: $e');
      return null;
    }
  }

  /// يتحقق مما إذا كان مسموحاً للتطبيق بجدولة المنبهات الدقيقة في أندرويد 12 فما فوق
  static Future<bool> canScheduleExactAlarms() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('canScheduleExactAlarms');
      return res ?? true;
    } catch (e) {
      debugPrint('Error checking exact alarms capability: $e');
      return true;
    }
  }

  /// يطلب إذن جدولة المنبهات الدقيقة بفتح شاشة المنبهات والتذكيرات في أندرويد 12+
  static Future<bool> requestExactAlarmsPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('requestExactAlarmsPermission');
      return res ?? false;
    } catch (e) {
      debugPrint('Error requesting exact alarms permission: $e');
      return false;
    }
  }

  /// جدولة منبه دقيق بأعلى أولوية في نظام أندرويد (AlarmClock) عبر الكود الأصلي للتحرر من أي قيود
  static Future<bool> scheduleNativeAlarm({
    required int id,
    required String title,
    required String body,
    required int triggerAtMillis,
    String sound = 'athan_abdulbasit',
  }) async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('scheduleNativeAlarm', {
        'id': id,
        'title': title,
        'body': body,
        'triggerAtMillis': triggerAtMillis,
        'sound': sound,
      });
      return res ?? false;
    } catch (e) {
      debugPrint('Error scheduling native alarm: $e');
      return false;
    }
  }

  /// إلغاء منبه أصلي مجدول
  static Future<bool> cancelNativeAlarm(int id) async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('cancelNativeAlarm', {'id': id});
      return res ?? false;
    } catch (e) {
      debugPrint('Error canceling native alarm: $e');
      return false;
    }
  }

  /// إطلاق إشعار وصوت أذان فوري عبر النظام الأصلي (بدون أي تأخير للتأكد من خروج الصوت فورا)
  static Future<bool> showNativeNotificationNow({
    int id = 99999,
    String title = 'تجربة أذان سِراج الفورية 🔔',
    String body = 'الله أكبر — التنبيهات والصوت تعمل بنجاح فوري وبنقاء تام!',
    String sound = 'athan_abdulbasit',
  }) async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('showNativeNotificationNow', {
        'id': id,
        'title': title,
        'body': body,
        'sound': sound,
      });
      return res ?? false;
    } catch (e) {
      debugPrint('Error showing native notification now: $e');
      return false;
    }
  }

  /// إيقاف صوت المنبه أو الأذان الشغال حالياً
  static Future<bool> stopActiveSound() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('stopActiveSound');
      return res ?? false;
    } catch (e) {
      debugPrint('Error stopping active sound: $e');
      return false;
    }
  }

  /// فتح شاشة إعدادات إشعارات التطبيق في إعدادات النظام مباشرة
  static Future<bool> openNotificationSettings() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('openNotificationSettings');
      return res ?? false;
    } catch (e) {
      debugPrint('Error opening notification settings: $e');
      return false;
    }
  }

  /// فتح شاشة إعدادات التشغيل التلقائي (Auto-start) لهواتف شاومي، هواوي، أوبو، سامسونج
  static Future<bool> openAutoStartSettings() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      final res = await _channel.invokeMethod<bool>('openAutoStartSettings');
      return res ?? false;
    } catch (e) {
      debugPrint('Error opening auto-start settings: $e');
      return false;
    }
  }
}

