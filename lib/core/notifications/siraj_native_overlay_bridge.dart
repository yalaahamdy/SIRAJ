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
}
