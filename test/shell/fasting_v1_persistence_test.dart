import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_policy.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting User Data Persistence Suite (§19..§25, §68..§76, §98, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
    });

    test('Persistence 1: Records, Qada plan, policies, and snapshots persist faithfully across instances', () async {
      await fastingModule.markTodayStatus(
        type: FastingType.qada,
        status: FastingStatus.fasted,
        note: 'قضاء يوم من رمضان السابق',
      );

      await fastingModule.updateQadaPlan(QadaPlan(
        totalDays: 10,
        completedDays: 1,
        preferredWeekdays: const [1, 4],
        updatedAt: DateTime.utc(2026, 9, 1),
      ));

      await fastingModule.setActivePolicy(FastingPolicy.precautionaryImsak.policyId);

      // Create snapshot
      final snapRes = await fastingModule.saveSnapshot();
      expect(snapRes.isSuccess, isTrue);

      // Spin up a new FastingModule on the same storage
      final restoredModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);

      final recordsRes = await restoredModule.getDayRecords();
      expect(recordsRes.isSuccess, isTrue);
      expect(recordsRes.valueOrNull!.length, equals(1));
      expect(recordsRes.valueOrNull!.first.type, equals(FastingType.qada));

      final planRes = await restoredModule.getQadaPlan();
      expect(planRes.isSuccess, isTrue);
      expect(planRes.valueOrNull!.totalDays, equals(10));

      final policy = await restoredModule.getActivePolicy();
      expect(policy.policyId, equals(FastingPolicy.precautionaryImsak.policyId));

      final snapsRes = await restoredModule.getSnapshots();
      expect(snapsRes.isSuccess, isTrue);
      expect(snapsRes.valueOrNull!.length, equals(1));
    });
  });
}
