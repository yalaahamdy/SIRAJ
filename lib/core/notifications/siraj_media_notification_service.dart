import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'siraj_notification_manager.dart';

/// Supported types of audio streams managed by SIRAJ media notifications.
enum SirajMediaType {
  cairoRadio,
  tawasheeh,
  quranRecitation,
  sharawyKhawatir,
}

/// Dedicated media playback notification service (§14, §20, §32).
/// Displays sticky MediaStyle notifications with transport controls (Play, Pause, Next, Prev, Stop).
class SirajMediaNotificationService {
  static SirajMediaNotificationService instance = SirajMediaNotificationService();

  static const int mediaNotificationId = 88888;
  static const String mediaChannelId = 'siraj_media_playback_channel_v1';
  static const String mediaChannelName = 'مشغل صوتيات سِراج الشريف';
  static const String mediaChannelDescription =
      'إشعار تفاعلي للتحكم في إذاعة القرآن الكريم والتواشيح والتلاوات القرآنية';

  static const String actionPlayPause = 'siraj_media_play_pause';
  static const String actionNext = 'siraj_media_next';
  static const String actionPrevious = 'siraj_media_prev';
  static const String actionStop = 'siraj_media_stop';

  // Action listeners
  VoidCallback? onPlayPause;
  VoidCallback? onNext;
  VoidCallback? onPrevious;
  VoidCallback? onStop;

  bool _isShowing = false;
  bool get isShowing => _isShowing;

  String? _lastTitle;
  String? _lastSubtitle;
  bool? _lastIsPlaying;
  SirajMediaType? _lastType;

  String? get lastTitle => _lastTitle;
  String? get lastSubtitle => _lastSubtitle;
  bool? get lastIsPlaying => _lastIsPlaying;
  SirajMediaType? get lastType => _lastType;

  /// Shows or updates active media notification with current playback state and metadata.
  Future<void> showMediaNotification({
    required String title,
    required String subtitle,
    required bool isPlaying,
    required SirajMediaType type,
    bool hasNext = true,
    bool hasPrevious = true,
  }) async {
    _lastTitle = title;
    _lastSubtitle = subtitle;
    _lastIsPlaying = isPlaying;
    _lastType = type;
    _isShowing = true;

    if (kIsWeb) return;
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return;
      }
    } catch (_) {}

    final notificationsPlugin = SirajNotificationManager.instance.notificationsPlugin;

    // Build interactive action buttons based on media type
    final actions = <AndroidNotificationAction>[];

    if (type == SirajMediaType.cairoRadio) {
      // Live Radio: Play/Pause and Stop
      actions.add(
        AndroidNotificationAction(
          actionPlayPause,
          isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
          showsUserInterface: false,
          cancelNotification: false,
        ),
      );
      actions.add(
        const AndroidNotificationAction(
          actionStop,
          'إغلاق',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      );
    } else {
      // Tawasheeh or Quran Recitation: Prev, Play/Pause, Next, Stop
      if (hasPrevious) {
        actions.add(
          const AndroidNotificationAction(
            actionPrevious,
            'السابق',
            showsUserInterface: false,
            cancelNotification: false,
          ),
        );
      }
      actions.add(
        AndroidNotificationAction(
          actionPlayPause,
          isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
          showsUserInterface: false,
          cancelNotification: false,
        ),
      );
      if (hasNext) {
        actions.add(
          const AndroidNotificationAction(
            actionNext,
            'التالي',
            showsUserInterface: false,
            cancelNotification: false,
          ),
        );
      }
      actions.add(
        const AndroidNotificationAction(
          actionStop,
          'إغلاق',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      );
    }

    final androidDetails = AndroidNotificationDetails(
      mediaChannelId,
      mediaChannelName,
      channelDescription: mediaChannelDescription,
      importance: Importance.low, // Silent update without sound buzz
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: isPlaying,
      autoCancel: !isPlaying,
      showWhen: false,
      color: const Color(0xFFC29B38),
      colorized: true,
      category: AndroidNotificationCategory.transport,
      visibility: NotificationVisibility.public,
      styleInformation: const MediaStyleInformation(),
      actions: actions,
      subText: _getCategoryLabel(type),
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await notificationsPlugin.show(
        id: mediaNotificationId,
        title: title,
        body: subtitle,
        notificationDetails: details,
        payload: 'siraj_media_playback',
      );
    } catch (e) {
      debugPrint('Error showing media notification: $e');
    }
  }

  /// Cancels and removes active media playback notification.
  Future<void> cancelMediaNotification() async {
    _isShowing = false;
    _lastTitle = null;
    _lastSubtitle = null;
    _lastIsPlaying = null;
    _lastType = null;

    if (kIsWeb) return;
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return;
      }
    } catch (_) {}

    try {
      await SirajNotificationManager.instance.notificationsPlugin.cancel(
        id: mediaNotificationId,
      );
    } catch (_) {}
  }

  /// Dispatches incoming notification action to registered listener.
  void handleAction(String actionId) {
    switch (actionId) {
      case actionPlayPause:
        onPlayPause?.call();
        break;
      case actionNext:
        onNext?.call();
        break;
      case actionPrevious:
        onPrevious?.call();
        break;
      case actionStop:
        onStop?.call();
        cancelMediaNotification();
        break;
    }
  }

  String _getCategoryLabel(SirajMediaType type) {
    switch (type) {
      case SirajMediaType.cairoRadio:
        return 'إذاعة القرآن الكريم';
      case SirajMediaType.tawasheeh:
        return 'تواشيح وابتهالات';
      case SirajMediaType.quranRecitation:
        return 'القرآن الكريم';
      case SirajMediaType.sharawyKhawatir:
        return 'خواطر الشيخ الشعراوي';
    }
  }
}
