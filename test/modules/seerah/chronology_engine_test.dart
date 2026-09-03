import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/seerah/domain/date_precision.dart';
import 'package:siraj/modules/seerah/domain/historical_date.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';
import 'package:siraj/modules/seerah/engine/chronology_engine.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Seerah Chronology Engine Tests (§6, §22)', () {
    late ReadOnlySeerahStore store;
    late ChronologyEngine engine;

    setUp(() {
      store = ReadOnlySeerahStore();
      final pkg = SyntheticSeerahFixtures.createPackage();
      store.mountPackage(pkg);
      engine = ChronologyEngine(store: store);
    });

    test('Valid event chronology passes verification', () {
      final res = engine.validateAllChronology();
      expect(res.isSuccess, isTrue);
    });

    test('Detects contradiction when event occurs before participant birth', () {
      // Abu Bakr born ~51 Before Hijrah. Event set to 60 Before Hijrah.
      final impossibleEvent = SeerahEvent.create(
        eventId: 'evt_impossible_birth',
        title: 'حدث مستحيل قبل الميلاد',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 60,
          isBeforeHijrah: true,
          precision: DatePrecision.yearOnly,
          dateDisplay: '60 ق.هـ',
        ),
        participantIds: const ['person_abu_bakr'],
        summary: 'حدث تاريخي',
        sourceIds: const ['src_1'],
      );

      final res = engine.validateEventChronology(impossibleEvent);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull!.message, contains('occurred before birth'));
    });

    test('Detects contradiction when event occurs after participant death', () {
      // Abu Bakr died 13 AH. Event set to 20 AH.
      final impossibleEvent = SeerahEvent.create(
        eventId: 'evt_impossible_death',
        title: 'حدث مستحيل بعد الوفاة',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 20,
          isBeforeHijrah: false,
          precision: DatePrecision.yearOnly,
          dateDisplay: '20 هـ',
        ),
        participantIds: const ['person_abu_bakr'],
        summary: 'حدث تاريخي',
        sourceIds: const ['src_1'],
      );

      final res = engine.validateEventChronology(impossibleEvent);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull!.message, contains('occurred after death'));
    });
  });
}
