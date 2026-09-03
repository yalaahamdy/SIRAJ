import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/prayer_tracking_status.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/prayer_tracker_service.dart';

void main() {
  group('L2 Local-First Prayer Tracker Service Tests (§14, §15)', () {
    late MemoryStorageRegistry storage;
    late EventBus bus;
    late TestClock clock;
    late PrayerTrackerService tracker;

    setUp(() {
      storage = MemoryStorageRegistry();
      bus = EventBus(sync: true);
      clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0, 0));
      tracker = PrayerTrackerService(
        storageRegistry: storage,
        clock: clock,
        eventBus: bus,
      );
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Logs prayer status locally and emits PrayerLoggedEvent', () async {
      final loggedEvents = <PrayerLoggedEvent>[];
      bus.on<PrayerLoggedEvent>().listen(loggedEvents.add);

      final date = DateTime.utc(2026, 8, 31);
      final res = await tracker.logPrayer(
        date: date,
        prayerType: PrayerType.fajr,
        status: PrayerTrackingStatus.prayed,
        notes: 'In congregation',
      );

      expect(res.isSuccess, isTrue);
      expect(loggedEvents.length, equals(1));
      expect(loggedEvents.first.prayerName, equals('fajr'));
      expect(loggedEvents.first.status, equals('prayed'));

      // Retrieve single log
      final getRes = await tracker.getLogForPrayer(date: date, prayerType: PrayerType.fajr);
      expect(getRes.isSuccess, isTrue);
      final log = getRes.valueOrNull!;
      expect(log.status, equals(PrayerTrackingStatus.prayed));
      expect(log.notes, equals('In congregation'));
    });

    test('Retrieves full day tracking logs', () async {
      final date = DateTime.utc(2026, 8, 31);

      await tracker.logPrayer(
        date: date,
        prayerType: PrayerType.fajr,
        status: PrayerTrackingStatus.prayed,
      );
      await tracker.logPrayer(
        date: date,
        prayerType: PrayerType.dhuhr,
        status: PrayerTrackingStatus.prayed,
      );
      await tracker.logPrayer(
        date: date,
        prayerType: PrayerType.asr,
        status: PrayerTrackingStatus.missed,
      );

      final dayLogsRes = await tracker.getLogsForDate(date);
      expect(dayLogsRes.isSuccess, isTrue);
      final logs = dayLogsRes.valueOrNull!;

      expect(logs.length, equals(3));
      expect(logs[PrayerType.fajr]?.status, equals(PrayerTrackingStatus.prayed));
      expect(logs[PrayerType.dhuhr]?.status, equals(PrayerTrackingStatus.prayed));
      expect(logs[PrayerType.asr]?.status, equals(PrayerTrackingStatus.missed));
    });
  });
}
