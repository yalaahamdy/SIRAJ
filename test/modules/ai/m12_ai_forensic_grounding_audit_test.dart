import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/ai/domain/citation.dart';
import 'package:siraj/modules/ai/domain/grounding_status.dart';
import 'package:siraj/modules/ai/engine/output_validator.dart';
import '../../fixtures/ai/synthetic_ai_fixtures.dart';

void main() {
  group('M12 Forensic Grounding & Citation Attacks (§5-§14)', () {
    const validator = OutputValidator();

    test('§5 Grounding Attack: Output contains Fact A (supported) + Fact B (unsupported) -> marked partiallyGrounded', () {
      final evidence = [
        SyntheticAIFixtures.createValidHadithEvidence(text: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى'),
      ];
      final citations = [
        const Citation(
          citationId: 'cite_1',
          sourceId: 'src_bukhari',
          contentId: 'hadith_001',
          displayTitleArabic: 'صحيح البخاري',
          referenceLocation: 'صحيح البخاري - كتاب بدء الوحي - رقم 1',
        ),
      ];

      // Answer contains supported sentence and completely alien unsupported sentence
      const answer = 'الأعمال بالنيات ولكل امرئ ما نوى.\nوهناك كواكب تدور في مجرة بعيدة جداً.';
      final res = validator.validate(
        answerText: answer,
        rawCitations: citations,
        availableEvidence: evidence,
      );

      expect(res.groundingStatus, equals(GroundingStatus.partiallyGrounded));
    });

    test('§6 Claim Decomposition Attack: Supported + Unsupported claims must not be marked FULLY_GROUNDED', () {
      final evidence = [SyntheticAIFixtures.createValidQuranEvidence()];
      final citations = [
        const Citation(
          citationId: 'c1',
          sourceId: 'src_quran_hafs',
          contentId: 'ayah_1_1',
          displayTitleArabic: 'البسملة',
          referenceLocation: 'سورة الفاتحة - آية 1',
        ),
      ];

      const answer = 'بسم الله الرحمن الرحيم.\nمعلومة غير مسندة إطلاقاً في أي كتاب.';
      final res = validator.validate(
        answerText: answer,
        rawCitations: citations,
        availableEvidence: evidence,
      );

      expect(res.groundingStatus, isNot(equals(GroundingStatus.fullyGrounded)));
    });

    test('§7 & §8 Fabricated Source Attack: Non-existent source ID is detected and rejected', () {
      final evidence = [SyntheticAIFixtures.createValidHadithEvidence()];
      final fakeCitations = [
        const Citation(
          citationId: 'fake_1',
          sourceId: 'fabricated_book_xyz',
          contentId: 'fake_001',
          displayTitleArabic: 'كتاب من الخيال',
          referenceLocation: 'صفحة 999',
        ),
      ];

      final res = validator.validate(
        answerText: 'نص الحديث صحيح.',
        rawCitations: fakeCitations,
        availableEvidence: evidence,
      );

      expect(res.isValid, isFalse);
      expect(res.verifiedCitations.first.status, equals(CitationVerificationStatus.fabricated));
    });

    test('§9 & §10 Wrong-Reference Attack: Location mismatch is detected and rejected', () {
      final evidence = [
        SyntheticAIFixtures.createValidHadithEvidence(
          referenceLocation: 'صحيح البخاري - كتاب بدء الوحي - رقم 1',
        ),
      ];
      final mismatchedCitation = [
        const Citation(
          citationId: 'mismatch_1',
          sourceId: 'src_bukhari',
          contentId: 'hadith_001',
          displayTitleArabic: 'صحيح البخاري',
          referenceLocation: 'كتاب الصيد والذبائح - صفحة 500', // Wrong reference
        ),
      ];

      final res = validator.validate(
        answerText: 'الأعمال بالنيات.',
        rawCitations: mismatchedCitation,
        availableEvidence: evidence,
      );

      expect(res.isValid, isFalse);
      expect(res.rejectionReasonArabic, contains('عدم تطابق بين موضع الاستشهاد'));
    });

    test('§11 Source-Deletion Attack: Empty evidence pool fails closed immediately', () {
      final res = validator.validate(
        answerText: 'أي جواب.',
        rawCitations: const [],
        availableEvidence: const [],
      );

      expect(res.isValid, isFalse);
      expect(res.groundingStatus, equals(GroundingStatus.insufficientEvidence));
    });

    test('§13 & §14 Source-Conflict & Fiqh Collapse Attack: Multiple differing schools trigger CONFLICTING_SOURCES', () {
      final conflictEvidence = [
        SyntheticAIFixtures.createValidHadithEvidence(
          contentId: 'h1',
          text: 'ذهب الحنفية إلى وجوب قراءة الفاتحة في الصلاة كواجب وليس كفرض.',
        ),
        SyntheticAIFixtures.createValidHadithEvidence(
          contentId: 'h2',
          text: 'وقال الشافعية إن قراءة الفاتحة ركن وفرض تبطل الصلاة بتركه عمداً وسهواً وفيه خلاف.',
        ).copyWith(sourceId: 'src_shafii'),
      ];

      final citations = [
        const Citation(
          citationId: 'c1',
          sourceId: 'src_bukhari',
          contentId: 'h1',
          displayTitleArabic: 'مذهب الحنفية',
          referenceLocation: 'صحيح البخاري - كتاب بدء الوحي - رقم 1',
        ),
        const Citation(
          citationId: 'c2',
          sourceId: 'src_shafii',
          contentId: 'h2',
          displayTitleArabic: 'مذهب الشافعية',
          referenceLocation: 'صحيح البخاري - كتاب بدء الوحي - رقم 1',
        ),
      ];

      final res = validator.validate(
        answerText: 'ذهب الحنفية إلى وجوب الفاتحة وقال الشافعية إنها ركن وفيه خلاف.',
        rawCitations: citations,
        availableEvidence: conflictEvidence,
      );

      expect(res.groundingStatus, equals(GroundingStatus.conflictingSources));
    });
  });
}
