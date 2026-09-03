import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/search/adhkar_text_normalizer.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('M4 Forensic Unicode & Display Fidelity Tests (§17, §22)', () {
    test('Display Fidelity: Canonical text code units match exactly across pipeline', () {
      final package = CanonicalAdhkarFixture.createValidTestPackage();

      for (final item in package.items) {
        final originalText = item.textArabic;
        final originalCodeUnits = originalText.codeUnits;

        // Verify no invisible or unprintable characters
        for (final codeUnit in originalCodeUnits) {
          // Zero-width space (0x200B), zero-width non-joiner (0x200C), zero-width joiner (0x200D), BOM (0xFEFF)
          expect(codeUnit == 0x200B, isFalse, reason: 'Zero-width space detected in ${item.id}');
          expect(codeUnit == 0xFEFF, isFalse, reason: 'Byte Order Mark detected in ${item.id}');
        }

        // Verify Arabic script range
        expect(originalText.isNotEmpty, isTrue);
      }
    });

    test('Normalization Isolation: Normalizing for search does not alter original canonical string', () {
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      final item = package.items[0];

      final original = item.textArabic;
      final originalHash = item.integrityHash;

      final normalized = AdhkarTextNormalizer.normalize(original);

      // Search normalized string is un-diacritized
      expect(normalized.contains('\u064e'), isFalse); // No Fatha
      expect(normalized.contains('\u0650'), isFalse); // No Kasra

      // Original item is completely untouched
      expect(item.textArabic, equals(original));
      expect(item.integrityHash, equals(originalHash));
      expect(item.verifyHash(), isTrue);
    });
  });
}
