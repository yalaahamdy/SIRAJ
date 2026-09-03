import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';

/// Contract definition for centralized Notifications service (L3).
abstract class NotificationsServiceContract {
  /// Schedules a notification with explicit text received from the owning module.
  Future<Result<void, Failure>> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  });

  /// Cancels a scheduled notification.
  Future<Result<void, Failure>> cancelNotification(String id);
}
