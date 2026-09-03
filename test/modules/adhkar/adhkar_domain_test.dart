import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_type.dart';
import 'package:siraj/modules/adhkar/domain/repetition_provenance.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 Adhkar Domain Model & Provenance Tests (§4, §5, §6, §13)', () {
    test('DhikrItem computes and verifies SHA-256 integrity hash deterministically', () {
      final item = CanonicalAdhkarFixture.createItem(
        id: 'dhikr_test_001',
        textArabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        sourceTitle: 'صحيح مسلم',
        sourceAuthor: 'الإمام مسلم',
        reference: 'كتاب الذكر، رقم 2691',
        authenticityGrade: AuthenticityGrade.authenticated,
        attribution: 'عن أبي هريرة رضي الله عنه',
        occasion: DhikrOccasion.morning,
        repetition: const RepetitionProvenance(count: 100, isSourced: true, note: '100 مرة'),
        benefit: 'حُطت خطاياه وإن كانت مثل زبد البحر',
      );

      expect(item.verifyHash(), isTrue);
      expect(item.integrityHash.startsWith('sha256:'), isTrue);

      // Single character tampering causes hash mismatch
      final tampered = DhikrItem(
        id: item.id,
        type: item.type,
        textArabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.', // added dot
        sourceTitle: item.sourceTitle,
        sourceAuthor: item.sourceAuthor,
        reference: item.reference,
        authenticityGrade: item.authenticityGrade,
        attribution: item.attribution,
        occasion: item.occasion,
        repetition: item.repetition,
        benefit: item.benefit,
        integrityHash: item.integrityHash,
      );
      expect(tampered.verifyHash(), isFalse);
    });

    test('DhikrItem serializes and deserializes to/from JSON map flawlessly', () {
      final item = CanonicalAdhkarFixture.createItem(
        id: 'dhikr_test_002',
        textArabic: 'لا إِلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ',
        sourceTitle: 'صحيح البخاري',
        sourceAuthor: 'الإمام البخاري',
        reference: 'رقم 3293',
        authenticityGrade: AuthenticityGrade.authenticated,
        attribution: 'عن أبي هريرة رضي الله عنه',
        occasion: DhikrOccasion.morning,
        repetition: const RepetitionProvenance(count: 10, isSourced: true),
        benefit: 'كانت له عدل عشر رقاب',
      );

      final map = item.toMap();
      final restored = DhikrItem.fromMap(map);

      expect(restored, equals(item));
      expect(restored.verifyHash(), isTrue);
    });

    test('AuthenticityGrade and DhikrType expose correct Arabic labels and approval states', () {
      expect(AuthenticityGrade.authenticated.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.acceptedWithNote.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.disputed.isApprovedForDisplay, isTrue);
      expect(AuthenticityGrade.weak.isApprovedForDisplay, isFalse);
      expect(AuthenticityGrade.unverified.isApprovedForDisplay, isFalse);
      expect(AuthenticityGrade.rejected.isApprovedForDisplay, isFalse);

      expect(DhikrType.transmittedDhikr.labelArabic, equals('ذكر مأثور'));
      expect(DhikrType.transmittedDua.labelArabic, equals('دعاء مأثور'));
    });
  });
}
