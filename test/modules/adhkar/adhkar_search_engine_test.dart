import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/search/adhkar_search_engine.dart';
import 'package:siraj/modules/adhkar/search/adhkar_text_normalizer.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 Adhkar Search Engine & Normalization Isolation Tests (§12, §23)', () {
    test('AdhkarTextNormalizer strips Tashkeel and unifies Alef without mutating input', () {
      const original = 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ';
      final normalized = AdhkarTextNormalizer.normalize(original);

      expect(normalized, equals('اصبحنا واصبح الملك لله'));
      expect(original.contains('أ'), isTrue); // Input string untouched
    });

    test('Searches by plain un-diacritized keyword and returns original canonical DhikrItem', () {
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      const engine = AdhkarSearchEngine();

      // Search for "اصبحنا" matches "أَصْبَحْنَا..."
      final results = engine.search(query: 'اصبحنا', items: package.items);
      expect(results.length, equals(1));
      expect(results.first.id, equals('dhikr_morning_001'));
      expect(results.first.textArabic.contains('أَصْبَحْنَا'), isTrue);

      // Search by source title "مسلم"
      final muslimResults = engine.search(query: 'مسلم', items: package.items);
      expect(muslimResults.length, equals(3));

      // Search by author "البخاري"
      final bukhariResults = engine.search(query: 'البخاري', items: package.items);
      expect(bukhariResults.length, equals(1));
      expect(bukhariResults.first.id, equals('dhikr_sleep_001'));
    });

    test('Empty or whitespace query returns empty list immediately', () {
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      const engine = AdhkarSearchEngine();

      expect(engine.search(query: '', items: package.items), isEmpty);
      expect(engine.search(query: '   ', items: package.items), isEmpty);
    });
  });
}
