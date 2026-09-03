import '../domain/companion_preferences.dart';
import '../domain/companion_reminder.dart';

/// Orchestrator for collecting, deduplicating, and filtering daily reminders (§27, §28, §29).
class ReminderOrchestrator {
  const ReminderOrchestrator();

  /// Filters out duplicates, respects quiet hours, and orders reminders by priority and time.
  List<CompanionReminder> processReminders({
    required List<CompanionReminder> rawReminders,
    required CompanionPreferences preferences,
    required DateTime currentTime,
  }) {
    if (rawReminders.isEmpty) return const [];

    // 1. Deduplicate by unique key: sourceModule + titleArabic
    final seenKeys = <String>{};
    final deduplicated = <CompanionReminder>[];

    for (final r in rawReminders) {
      if (r.isDismissed) continue;
      final key = '${r.sourceModule}:${r.titleArabic.trim()}';
      if (seenKeys.add(key)) {
        deduplicated.add(r);
      }
    }

    // 2. Check Quiet Hours
    final currentHour = currentTime.hour;
    final isQuietHour = _isInQuietHours(
      currentHour,
      preferences.quietHoursStartHour,
      preferences.quietHoursEndHour,
    );

    final filtered = deduplicated.where((r) {
      if (preferences.enableQuietHours && isQuietHour) {
        // In quiet hours, only High priority (e.g. Prayer / Fajr) are allowed if not disabled
        return r.priority == ReminderPriority.high;
      }
      return true;
    }).toList();

    // 3. Sort deterministically: High priority first, then chronologically
    filtered.sort((a, b) {
      final pComp = a.priority.index.compareTo(b.priority.index);
      if (pComp != 0) return pComp;
      return a.scheduledTime.compareTo(b.scheduledTime);
    });

    return List.unmodifiable(filtered);
  }

  static bool _isInQuietHours(int currentHour, int startHour, int endHour) {
    if (startHour > endHour) {
      // Overnight (e.g., 23 to 5)
      return currentHour >= startHour || currentHour < endHour;
    } else {
      return currentHour >= startHour && currentHour < endHour;
    }
  }
}
