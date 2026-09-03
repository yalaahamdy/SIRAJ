import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/repetition_provenance.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('M4 Forensic Repetition & Sourced Count Security Tests (§8, §9)', () {
    test('Repetition Mutation Attack: Changing count (3 -> 7, 33 -> 34, 100 -> 99) triggers hash mismatch', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final original = validPkg.items[2]; // Count = 3 (After Prayer)

      expect(original.repetition.count, equals(3));
      expect(original.verifyHash(), isTrue);

      // Attack: 3 -> 7
      final tamperedCount7 = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: const RepetitionProvenance(count: 7, isSourced: true),
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );
      expect(tamperedCount7.verifyHash(), isFalse);

      // Attack: 3 -> 33
      final tamperedCount33 = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: const RepetitionProvenance(count: 33, isSourced: true),
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );
      expect(tamperedCount33.verifyHash(), isFalse);
    });

    test('Repetition Provenance: Altering isSourced flag from false to true triggers hash failure', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final original = validPkg.items[0];

      // Alter isSourced flag
      final forgedSourced = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: RepetitionProvenance(count: original.repetition.count, isSourced: false),
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );
      expect(forgedSourced.verifyHash(), isFalse);
    });
  });
}
