import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_type.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('M4 Forensic Attribution & Provenance Security Tests (§5, §6, §7)', () {
    test('Forensic 1: Changing narrator in attribution invalidates hash and fails verification', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final items = List<DhikrItem>.from(validPkg.items);

      final original = items[0];
      // Alter attribution from 'عن عبد الله بن مسعود...' to 'عن أبي هريرة...'
      final tampered = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: 'عن أبي هريرة رضي الله عنه', // Altered attribution!
        occasion: original.occasion,
        repetition: original.repetition,
        benefit: original.benefit,
        integrityHash: original.integrityHash, // Stale hash
      );

      expect(tampered.verifyHash(), isFalse);
    });

    test('Forensic 2: Modifying source book title or author triggers hash invalidation', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final original = validPkg.items[0];

      // Alter source book title
      final tamperedSource = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: 'سنن الترمذي', // Changed from صحيح مسلم
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: original.repetition,
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );
      expect(tamperedSource.verifyHash(), isFalse);

      // Alter author
      final tamperedAuthor = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: 'الإمام أحمد بن حنبل', // Changed from مسلم بن الحجاج
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: original.repetition,
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );
      expect(tamperedAuthor.verifyHash(), isFalse);
    });

    test('Forensic 3: Altering authenticity grade from authenticated to weak fails verification', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final original = validPkg.items[0];

      final alteredGrade = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: original.textArabic,
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: AuthenticityGrade.weak, // Modified grade
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: original.repetition,
        benefit: original.benefit,
        integrityHash: original.integrityHash,
      );

      expect(alteredGrade.verifyHash(), isFalse);
    });

    test('Forensic 4: Distinct semantic classification of DhikrType without conflation', () {
      expect(DhikrType.transmittedDhikr.name, equals('transmittedDhikr'));
      expect(DhikrType.transmittedDua.name, equals('transmittedDua'));
      expect(DhikrType.generalDua.name, equals('generalDua'));
      expect(DhikrType.scholarlyRecommendation.name, equals('scholarlyRecommendation'));
      expect(DhikrType.unverified.name, equals('unverified'));

      // Ensure General Dua has distinct Arabic label from Transmitted Dhikr
      expect(DhikrType.generalDua.labelArabic, isNot(equals(DhikrType.transmittedDhikr.labelArabic)));
    });

    test('Forensic 5: AuthenticityGrade display gate prevents unverified and weak content display', () {
      expect(AuthenticityGrade.authenticated.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.acceptedWithNote.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.disputed.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.weak.isApprovedForDisplay, isFalse);
      expect(AuthenticityGrade.unverified.isApprovedForDisplay, isFalse);
      expect(AuthenticityGrade.rejected.isApprovedForDisplay, isFalse);
    });
  });
}
