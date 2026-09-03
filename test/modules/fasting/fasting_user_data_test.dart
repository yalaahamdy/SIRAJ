import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_policy.dart';
import 'package:siraj/modules/fasting/domain/fasting_record_snapshot.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/store/fasting_user_data_store.dart';
import '../../fixtures/fasting/synthetic_fasting_fixtures.dart';

void main() {
  group('L2 FastingUserDataStore Local-First & Snapshot Integrity Tests (§21, §22, §31)', () {
    late MemoryStorageRegistry registry;
    late FastingUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = FastingUserDataStore(storageRegistry: registry);
    });

    test('Saves, retrieves, and updates fasting day records in mod_fasting namespace', () async {
      final record1 = SyntheticFastingFixtures.createDayRecord(
        id: 'fast_2026_03_15',
        date: DateTime.utc(2026, 3, 15),
        status: FastingStatus.fasted,
      );

      await store.saveDayRecord(record1);

      final listRes = await store.getDayRecords();
      expect(listRes.isSuccess, isTrue);
      expect(listRes.valueOrNull!.length, equals(1));
      expect(listRes.valueOrNull!.first.status, equals(FastingStatus.fasted));

      // Update record to missed
      final updated = record1.copyWith(status: FastingStatus.missed);
      await store.saveDayRecord(updated);

      final afterUpdate = await store.getDayRecords();
      expect(afterUpdate.valueOrNull!.length, equals(1));
      expect(afterUpdate.valueOrNull!.first.status, equals(FastingStatus.missed));
    });

    test('Saves and retrieves Qada plan accurately', () async {
      final plan = SyntheticFastingFixtures.createQadaPlan(totalDays: 14, completedDays: 4);
      await store.saveQadaPlan(plan);

      final res = await store.getQadaPlan();
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.totalDays, equals(14));
      expect(res.valueOrNull!.completedDays, equals(4));
      expect(res.valueOrNull!.remainingDays, equals(10));
    });

    test('Saves historical audit snapshot and verifies SHA-256 cryptographic integrity', () async {
      final record = SyntheticFastingFixtures.createDayRecord();
      final plan = SyntheticFastingFixtures.createQadaPlan();

      final snapshot = FastingRecordSnapshot.create(
        snapshotId: 'snap_fast_001',
        records: [record],
        qadaPlan: plan,
        policy: FastingPolicy.standard,
        createdAt: DateTime.utc(2026, 8, 31),
      );

      expect(snapshot.verifyHash(), isTrue);
      expect(snapshot.integrityHash.startsWith('sha256:'), isTrue);

      await store.saveSnapshot(snapshot);

      final snapsRes = await store.getSnapshots();
      expect(snapsRes.isSuccess, isTrue);
      expect(snapsRes.valueOrNull!.length, equals(1));
      expect(snapsRes.valueOrNull!.first.verifyHash(), isTrue);
    });

    test('Reset clears all user fasting records and plans from local storage', () async {
      await store.saveDayRecord(SyntheticFastingFixtures.createDayRecord());
      await store.saveQadaPlan(SyntheticFastingFixtures.createQadaPlan());

      final resetRes = await store.resetAllUserData();
      expect(resetRes.isSuccess, isTrue);

      final records = await store.getDayRecords();
      expect(records.valueOrNull!, isEmpty);

      final plan = await store.getQadaPlan();
      expect(plan.valueOrNull!.totalDays, equals(0));
    });
  });
}
