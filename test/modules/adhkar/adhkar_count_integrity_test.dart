import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/shell/seed/data/canonical_adhkar_data.dart';

void main() {
  group('M03.0 — Adhkar Target Count & Repetition Provenance Audit (§9, §11, §12)', () {
    late List<DhikrItem> items;

    setUp(() {
      items = CanonicalAdhkarData.getAllAdhkar();
    });

    test('All target counts are positive canonical numbers conforming to Sunnah', () {
      final validSunnahCounts = {1, 3, 4, 7, 10, 33, 34, 100};

      for (final item in items) {
        final count = item.repetition.count;
        expect(count, greaterThan(0), reason: 'Item ${item.id} has invalid non-positive count');
        expect(validSunnahCounts.contains(count), isTrue,
            reason: 'Item ${item.id} has non-standard count: $count');
      }
    });

    test('Specific benchmark adhkar target counts match exact seed baseline', () {
      final ayatAlKursiMorning = items.firstWhere((i) => i.id == 'dhikr_morning_004');
      expect(ayatAlKursiMorning.repetition.count, 1);

      final tasbihMorning = items.firstWhere((i) => i.id == 'dhikr_morning_008');
      expect(tasbihMorning.repetition.count, 100);

      final radituMorning = items.firstWhere((i) => i.id == 'dhikr_morning_006');
      expect(radituMorning.repetition.count, 3);

      final postPrayerSubhanallah = items.firstWhere((i) => i.id == 'dhikr_after_prayer_004_a');
      expect(postPrayerSubhanallah.repetition.count, 33);

      final postPrayerAlhamdulillah = items.firstWhere((i) => i.id == 'dhikr_after_prayer_004_b');
      expect(postPrayerAlhamdulillah.repetition.count, 33);

      final postPrayerAllahuAkbar = items.firstWhere((i) => i.id == 'dhikr_after_prayer_004_c');
      expect(postPrayerAllahuAkbar.repetition.count, 33);

      final postPrayerDua = items.firstWhere((i) => i.id == 'dhikr_after_prayer_006');
      expect(postPrayerDua.repetition.count, 1);
    });

    test('Audit repetition notes availability across baseline', () {
      final itemsWithNotes = items.where((i) => i.repetition.note != null && i.repetition.note!.isNotEmpty).toList();
      expect(itemsWithNotes.length, greaterThanOrEqualTo(20));
    });
  });
}
