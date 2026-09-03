import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_day_record.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Performance Suite (§65..§67, §100, §110)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
    });

    test('Performance 1: Qada calculation for 1000 days completes in < 50ms', () {
      final plan = QadaPlan(
        totalDays: 1000,
        completedDays: 0,
        preferredWeekdays: const [1, 4],
        updatedAt: DateTime.utc(2026, 9, 1),
      );

      final stopwatch = Stopwatch()..start();
      final projected = fastingModule.qadaPlannerService.projectCompletionDate(
        plan: plan,
        startDate: DateTime.utc(2026, 9, 1),
      );
      stopwatch.stop();

      expect(projected, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 2: Saving and retrieving 100 fasting records completes efficiently', () async {
      final now = DateTime.utc(2026, 1, 1);
      final stopwatch = Stopwatch()..start();

      for (var i = 0; i < 100; i++) {
        final d = now.add(Duration(days: i));
        await fastingModule.userDataStore.saveDayRecord(
          FastingDayRecord(
            recordId: 'rec_$i',
            date: d,
            hijriDate: const HijriDate(year: 1448, month: 9, day: 1),
            type: FastingType.voluntary,
            status: FastingStatus.fasted,
            createdAt: d,
          ),
        );
      }

      final recordsRes = await fastingModule.getDayRecords();
      stopwatch.stop();

      expect(recordsRes.isSuccess, isTrue);
      expect(recordsRes.valueOrNull!.length, equals(100));
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });
  });
}
