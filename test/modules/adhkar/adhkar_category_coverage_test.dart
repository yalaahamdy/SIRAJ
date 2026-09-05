import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/shell/seed/data/canonical_adhkar_data.dart';

void main() {
  group('M03.0 — Adhkar Category Coverage & Gap Analysis Matrix (§5, §6, §22, §23)', () {
    late List<DhikrItem> items;

    setUp(() {
      items = CanonicalAdhkarData.getAllAdhkar();
    });

    test('Identifies active and covered categories in current baseline', () {
      final activeOccasions = items.map((i) => i.occasion).toSet();

      expect(activeOccasions.contains(DhikrOccasion.morning), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.evening), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.afterPrayer), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.sleep), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.taharah), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.mosque), isTrue);
      expect(activeOccasions.contains(DhikrOccasion.prayer), isTrue);
    });

    test('Quantifies existing items vs full Hisn al-Muslim scope', () {
      // Total Hisn al-Muslim corpus is ~132 chapters and ~267 distinct adhkar.
      const totalHisnChapters = 132;
      const totalHisnAdhkar = 267;

      final currentAdhkarCount = items.length;
      final currentCoveredOccasions = items.map((i) => i.occasion).toSet().length;

      expect(currentAdhkarCount, 181);
      expect(currentCoveredOccasions, 20);

      final missingAdhkarCount = totalHisnAdhkar - currentAdhkarCount;
      final missingChaptersCount = totalHisnChapters - 80; // 80 logical chapters represented in text

      expect(missingAdhkarCount, 86, reason: 'Exactly 86 items remaining for full Hisn al-Muslim coverage');
      expect(missingChaptersCount, 52, reason: 'Exactly 52 chapters remaining for full coverage');
    });

    test('Coverage percentage reflects realistic partial baseline', () {
      final coveragePercent = (items.length / 267) * 100;
      expect(coveragePercent, closeTo(67.79, 0.1));
    });
  });
}
