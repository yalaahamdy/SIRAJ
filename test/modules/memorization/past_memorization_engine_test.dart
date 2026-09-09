import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/memorization/services/past_memorization_engine.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('PastMemorizationEngine Test Suite (§38, §50, §55)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;
    late PastMemorizationEngine engine;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
      engine = memorizationModule.pastMemorizationEngine;
    });

    test('getPastMasteryStats returns default 100% when no items exist', () async {
      final res = await engine.getPastMasteryStats();
      expect(res.isSuccess, isTrue);
      final stats = res.valueOrNull!;
      expect(stats.totalMasteredAyahs, equals(0));
      expect(stats.totalWeakAyahs, equals(0));
      expect(stats.masteryPercentage, equals(100.0));
    });

    test('generatePastExamQuestion produces valid question even on fresh start', () async {
      final res = await engine.generatePastExamQuestion(requestedPassageLength: 3);
      expect(res.isSuccess, isTrue);
      final q = res.valueOrNull!;
      expect(q.promptAyah, isNotNull);
      expect(q.promptText.isNotEmpty, isTrue);
      expect(q.expectedAyahs.isNotEmpty, isTrue);
      expect(q.surahNameArabic.isNotEmpty, isTrue);
    });

    test('submitPastExamResult with isMastered=true marks items as mastered with extended interval', () async {
      final qRes = await engine.generatePastExamQuestion(requestedPassageLength: 2);
      expect(qRes.isSuccess, isTrue);
      final q = qRes.valueOrNull!;

      final subRes = await engine.submitPastExamResult(question: q, isMastered: true);
      expect(subRes.isSuccess, isTrue);

      final statsRes = await engine.getPastMasteryStats();
      final stats = statsRes.valueOrNull!;
      expect(stats.totalMasteredAyahs, greaterThan(0));
      expect(stats.totalWeakAyahs, equals(0));
      expect(stats.masteryPercentage, equals(100.0));
    });

    test('submitPastExamResult with isMastered=false marks items as weak and schedules immediate review', () async {
      final qRes = await engine.generatePastExamQuestion(requestedPassageLength: 1);
      final q = qRes.valueOrNull!;

      final subRes = await engine.submitPastExamResult(question: q, isMastered: false);
      expect(subRes.isSuccess, isTrue);

      final statsRes = await engine.getPastMasteryStats();
      final stats = statsRes.valueOrNull!;
      expect(stats.totalWeakAyahs, greaterThan(0));
    });

    test('MemorizationPlan ready-made templates create valid predefined plans', () {
      final now = DateTime.utc(2026, 9, 9);
      final amma = MemorizationPlan.createDefaultJuzAmma(now);
      expect(amma.targetSurahs.length, equals(37));
      expect(amma.startAyah, equals(const AyahKey(surahNumber: 78, ayahNumber: 1)));

      final tabarak = MemorizationPlan.createDefaultJuzTabarak(now);
      expect(tabarak.targetSurahs.length, equals(11));
      expect(tabarak.startAyah, equals(const AyahKey(surahNumber: 67, ayahNumber: 1)));

      final baqarah = MemorizationPlan.createDefaultBaqarah(now);
      expect(baqarah.targetSurahs, equals([2]));

      final mufassal = MemorizationPlan.createDefaultMufassal(now);
      expect(mufassal.targetSurahs.first, equals(50));
      expect(mufassal.targetSurahs.last, equals(114));

      final fullQuran = MemorizationPlan.createDefaultFullQuran(now);
      expect(fullQuran.targetSurahs.length, equals(114));
    });
  });
}
