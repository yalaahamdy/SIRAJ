import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/ai/domain/evidence_item.dart';
import 'package:siraj/modules/ai/engine/evidence_validator.dart';
import '../../fixtures/ai/synthetic_ai_fixtures.dart';

void main() {
  group('L2 Evidence Validator Tests (§11, §14)', () {
    const validator = EvidenceValidator();

    test('Validates approved and canonical evidence items', () {
      final validItems = [
        SyntheticAIFixtures.createValidHadithEvidence(),
        SyntheticAIFixtures.createValidQuranEvidence(),
      ];

      final res = validator.validateEvidence(validItems);
      expect(res.length, equals(2));
    });

    test('Filters out unverified or malformed evidence items', () {
      final malformedItems = [
        SyntheticAIFixtures.createValidHadithEvidence(),
        const EvidenceItem(
          sourceId: 'unverified_src',
          contentId: 'bad_001',
          contentType: 'hadith',
          title: 'حديث غير موثق',
          textExcerpt: '', // Empty excerpt
          referenceLocation: 'مجهول',
          verificationState: VerificationState.unverified,
        ),
      ];

      final res = validator.validateEvidence(malformedItems);
      expect(res.length, equals(1));
      expect(res.first.contentId, equals('hadith_001'));
    });
  });
}
