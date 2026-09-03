import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_day_record.dart';
import 'package:siraj/modules/fasting/domain/fasting_policy.dart';
import 'package:siraj/modules/fasting/domain/fasting_record_snapshot.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import '../../fixtures/fasting/synthetic_fasting_fixtures.dart';

void main() {
  group('M6 Fasting Adversarial & Hardening Tests (§35, §36, §48)', () {
    late MemoryStorageRegistry registry;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: registry);
      fastingModule = FastingModule(storageRegistry: registry, prayerModule: prayerModule);
    });

    test('Adversarial 1: Historical snapshot tampering fails cryptographic verification', () {
      final record = SyntheticFastingFixtures.createDayRecord(status: FastingStatus.fasted);
      final snapshot = FastingRecordSnapshot.create(
        snapshotId: 'snap_adv_001',
        records: [record],
        policy: FastingPolicy.standard,
        createdAt: DateTime.utc(2026, 8, 31),
      );

      expect(snapshot.verifyHash(), isTrue);

      // Tamper status from fasted to missed
      final tamperedRecord = record.copyWith(status: FastingStatus.missed);
      final tamperedSnapshot = FastingRecordSnapshot(
        snapshotId: snapshot.snapshotId,
        records: [tamperedRecord],
        qadaPlan: snapshot.qadaPlan,
        policy: snapshot.policy,
        createdAt: snapshot.createdAt,
        integrityHash: snapshot.integrityHash, // Stale hash
      );

      expect(tamperedSnapshot.verifyHash(), isFalse);
    });

    test('Adversarial 2: Calendar offset adjustment NEVER modifies recorded historical user entries', () async {
      final initialRecord = FastingDayRecord(
        recordId: 'fast_hist_001',
        date: DateTime.utc(2026, 3, 1),
        hijriDate: const HijriDate(year: 1447, month: 9, day: 11),
        type: FastingType.ramadan,
        status: FastingStatus.fasted,
        createdAt: DateTime.utc(2026, 3, 1),
      );
      await fastingModule.userDataStore.saveDayRecord(initialRecord);

      // User changes calendar offset by +2 days
      await fastingModule.userDataStore.setCalendarOffsetDays(2);

      final retrieved = await fastingModule.userDataStore.getDayRecords();
      expect(retrieved.valueOrNull!.first.hijriDate.day, equals(11)); // Remains 11th of Ramadan
      expect(retrieved.valueOrNull!.first.status, equals(FastingStatus.fasted));
    });

    test('Adversarial 3: Marking Qada as fasted automatically increments completed Qada balance', () async {
      final initialPlan = QadaPlan(
        totalDays: 5,
        completedDays: 1,
        updatedAt: DateTime.utc(2026, 8, 31),
      );
      await fastingModule.updateQadaPlan(initialPlan);

      await fastingModule.markTodayStatus(
        type: FastingType.qada,
        status: FastingStatus.fasted,
      );

      final planAfter = await fastingModule.getQadaPlan();
      expect(planAfter.valueOrNull!.completedDays, equals(2));
      expect(planAfter.valueOrNull!.remainingDays, equals(3));
    });

    test('Adversarial 4: Privacy Isolation: Fasting records reside exclusively in mod_fasting namespace', () async {
      await fastingModule.markTodayStatus(
        type: FastingType.ramadan,
        status: FastingStatus.fasted,
      );

      final fastingStore = registry.getStoreForModule('mod_fasting');
      final prayerStore = registry.getStoreForModule('mod_prayer');
      final quranStore = registry.getStoreForModule('mod_quran');

      expect((await fastingStore.getString('fasting_records')).valueOrNull, isNotNull);
      expect((await prayerStore.getString('fasting_records')).valueOrNull, isNull);
      expect((await quranStore.getString('fasting_records')).valueOrNull, isNull);
    });
  });
}
