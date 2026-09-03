import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/ai/domain/citation.dart';
import 'package:siraj/modules/ai/domain/grounding_status.dart';
import 'package:siraj/modules/ai/engine/output_validator.dart';
import '../../fixtures/ai/synthetic_ai_fixtures.dart';

void main() {
  group('L2 Output & Citation Validator Tests (§13, §18, §58)', () {
    const validator = OutputValidator();

    test('Validates legitimate citations matching available evidence pool', () {
      final evidence = [SyntheticAIFixtures.createValidHadithEvidence()];
      final citations = [
        const Citation(
          citationId: 'cite_1',
          sourceId: 'src_bukhari',
          contentId: 'hadith_001',
          displayTitleArabic: 'صحيح البخاري',
          referenceLocation: 'كتاب بدء الوحي',
        ),
      ];

      final res = validator.validate(
        answerText: 'الأعمال بالنيات.',
        rawCitations: citations,
        availableEvidence: evidence,
      );

      expect(res.isValid, isTrue);
      expect(res.groundingStatus, equals(GroundingStatus.fullyGrounded));
    });

    test('Rejects output containing fabricated citation not found in evidence pool', () {
      final evidence = [SyntheticAIFixtures.createValidHadithEvidence()];
      final citations = [
        const Citation(
          citationId: 'cite_fake',
          sourceId: 'non_existent_source', // Fabricated source ID
          contentId: 'hadith_999',
          displayTitleArabic: 'كتاب وهمي',
          referenceLocation: 'صفحة 999',
        ),
      ];

      final res = validator.validate(
        answerText: 'معلومة ملفقة.',
        rawCitations: citations,
        availableEvidence: evidence,
      );

      expect(res.isValid, isFalse);
      expect(res.rejectionReasonArabic, contains('استشهاد غير مطابق'));
    });
  });
}
