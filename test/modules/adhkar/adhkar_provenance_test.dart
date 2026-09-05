import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/shell/seed/data/canonical_adhkar_data.dart';

void main() {
  group('M03.0 — Adhkar Provenance & Source Hierarchy Audit (§2, §3, §7, §8)', () {
    late List<DhikrItem> items;

    setUp(() {
      items = CanonicalAdhkarData.getAllAdhkar();
    });

    test('All items reference recognized canonical hadith collections', () {
      final recognizedKeywords = [
        'بخاري',
        'مسلم',
        'داود',
        'ترمذي',
        'نسائي',
        'ماجه',
        'أحمد',
        'حاكم',
        'حبان',
        'بيهقي',
        'شيبة',
        'دارمي',
      ];

      for (final item in items) {
        final matchesSource = recognizedKeywords.any((kw) => item.sourceTitle.contains(kw));
        expect(matchesSource, isTrue,
            reason: 'Dhikr ${item.id} has unrecognized source title: ${item.sourceTitle}');
      }
    });

    test('Every item attribution documents authentic provenance chain', () {
      for (final item in items) {
        expect(item.attribution.trim().isNotEmpty, isTrue,
            reason: 'Dhikr ${item.id} must have non-empty attribution');
        expect(item.attribution.length, greaterThanOrEqualTo(5),
            reason: 'Dhikr ${item.id} attribution must be descriptive');
      }
    });

    test('No item contains unverified or placeholder indicators', () {
      for (final item in items) {
        expect(item.textArabic.toLowerCase(), isNot(contains('placeholder')));
        expect(item.textArabic.toLowerCase(), isNot(contains('synthetic')));
        expect(item.textArabic.toLowerCase(), isNot(contains('dummy')));
        expect(item.reference.toLowerCase(), isNot(contains('unknown')));
      }
    });
  });
}
