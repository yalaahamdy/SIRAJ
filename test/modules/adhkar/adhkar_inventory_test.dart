import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/shell/seed/data/canonical_adhkar_data.dart';

void main() {
  group('M03.0 — Adhkar Forensic Inventory Audit (§4, §5, §10)', () {
    late List<DhikrItem> items;

    setUp(() {
      items = CanonicalAdhkarData.getAllAdhkar();
    });

    test('Inventory count matches current baseline exactly', () {
      expect(items.length, 181, reason: 'Current Batch 3 contains exactly 181 seeded canonical items');
    });

    test('All items have unique IDs with standard naming scheme', () {
      final ids = items.map((i) => i.id).toSet();
      expect(ids.length, items.length, reason: 'Every Dhikr item must possess a unique ID');

      for (final id in ids) {
        expect(id.startsWith('dhikr_'), isTrue, reason: 'ID $id must start with dhikr_ prefix');
      }
    });

    test('All items contain authenticated non-empty Arabic text and references', () {
      for (final item in items) {
        expect(item.textArabic.trim().isNotEmpty, isTrue, reason: 'Dhikr ${item.id} has empty Arabic text');
        expect(item.sourceTitle.trim().isNotEmpty, isTrue, reason: 'Dhikr ${item.id} has empty sourceTitle');
        expect(item.reference.trim().isNotEmpty, isTrue, reason: 'Dhikr ${item.id} has empty reference');
        expect(item.attribution.trim().isNotEmpty, isTrue, reason: 'Dhikr ${item.id} has empty attribution');
      }
    });

    test('All items satisfy cryptographic integrity hash verification', () {
      for (final item in items) {
        expect(item.verifyHash(), isTrue, reason: 'Dhikr ${item.id} integrity hash failed');
      }
    });

    test('Inventory classification status audit: all current items are GOVERNED/CANONICAL', () {
      for (final item in items) {
        expect(item.authenticityGrade, AuthenticityGrade.authenticated,
            reason: 'Item ${item.id} must have authenticated grade in canonical dataset');
        expect(item.repetition.isSourced, isTrue,
            reason: 'Item ${item.id} repetition count must be marked as sourced from Sunnah');
      }
    });

    test('Distribution across current active occasions', () {
      final morning = items.where((i) => i.occasion == DhikrOccasion.morning).toList();
      final evening = items.where((i) => i.occasion == DhikrOccasion.evening).toList();
      final afterPrayer = items.where((i) => i.occasion == DhikrOccasion.afterPrayer).toList();
      final sleep = items.where((i) => i.occasion == DhikrOccasion.sleep).toList();
      final taharah = items.where((i) => i.occasion == DhikrOccasion.taharah).toList();
      final mosque = items.where((i) => i.occasion == DhikrOccasion.mosque).toList();
      final prayer = items.where((i) => i.occasion == DhikrOccasion.prayer).toList();
      final clothing = items.where((i) => i.occasion == DhikrOccasion.clothing).toList();
      final waking = items.where((i) => i.occasion == DhikrOccasion.waking).toList();
      final difficulty = items.where((i) => i.occasion == DhikrOccasion.difficulty).toList();
      final illness = items.where((i) => i.occasion == DhikrOccasion.illness).toList();
      final weather = items.where((i) => i.occasion == DhikrOccasion.weather).toList();
      final travel = items.where((i) => i.occasion == DhikrOccasion.travel).toList();
      final food = items.where((i) => i.occasion == DhikrOccasion.food).toList();
      final funerals = items.where((i) => i.occasion == DhikrOccasion.funerals).toList();
      final fasting = items.where((i) => i.occasion == DhikrOccasion.fasting).toList();
      final gatherings = items.where((i) => i.occasion == DhikrOccasion.gatherings).toList();
      final general = items.where((i) => i.occasion == DhikrOccasion.general).toList();

      expect(morning.length, 19);
      expect(evening.length, 17);
      expect(afterPrayer.length, 9);
      expect(sleep.length, 15);
      expect(taharah.length, 6);
      expect(mosque.length, 8);
      expect(prayer.length, 24);
      expect(clothing.length, 5);
      expect(waking.length, 4);
      expect(difficulty.length, 14);
      expect(illness.length, 3);
      expect(weather.length, 4);
      expect(travel.length, 8);
      expect(food.length, 5);
      expect(funerals.length, 7);
      expect(fasting.length, 5);
      expect(gatherings.length, 7);
      expect(general.length, 19);
    });
  });
}
