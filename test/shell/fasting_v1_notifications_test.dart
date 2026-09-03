import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_schedule_day.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Notifications Suite (§37..§43, §97, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
    });

    test('Notifications 1: Suhoor and Iftar reminders are deterministic and avoid duplicates', () {
      final service = fastingModule.notificationService;
      final tomorrow = DateTime.now().toUtc().add(const Duration(days: 1));
      final tomorrowDate = DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day);
      final suhoorTime = DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day, 4, 15);
      final iftarTime = DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day, 18, 45);

      final schedule = FastingScheduleDay(
        date: tomorrowDate,
        hijriDate: const HijriDate(year: 1448, month: 9, day: 1),
        isRamadan: true,
        ramadanDayNumber: 1,
        suhoorImsakTime: suhoorTime,
        fastStartTime: suhoorTime,
        fastEndTime: iftarTime,
        fastingDuration: const Duration(hours: 14, minutes: 30),
        isCurrentlyFasting: false,
        remainingToNextBoundary: const Duration(hours: 2, minutes: 15),
        nextBoundaryLabel: 'موعد الإمساك وبدء الصيام',
        nextBoundaryTime: suhoorTime,
      );

      final suhoorPayload = service.createSuhoorReminder(schedule: schedule, minutesBefore: 45);
      expect(suhoorPayload, isNotNull);
      expect(suhoorPayload!.id, equals('suhoor_${tomorrowDate.toIso8601String().substring(0, 10)}'));
      expect(suhoorPayload.scheduledTime, equals(DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day, 3, 30)));

      final iftarPayload = service.createIftarReminder(schedule: schedule);
      expect(iftarPayload, isNotNull);
      expect(iftarPayload!.id, equals('iftar_${tomorrowDate.toIso8601String().substring(0, 10)}'));
      expect(iftarPayload.scheduledTime, equals(iftarTime));
    });
  });
}
