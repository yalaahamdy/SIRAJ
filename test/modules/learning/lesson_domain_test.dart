import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/evidence_link.dart';
import 'package:siraj/modules/learning/domain/learning_content_type.dart';
import 'package:siraj/modules/learning/domain/lesson.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L2 Lesson Domain, Content Type Separation & Hashes Tests (§6, §7, §11, §12)', () {
    test('EvidenceLink computes and verifies SHA-256 integrity hash', () {
      final ev = EvidenceLink.create(
        evidenceId: 'ev_1',
        evidenceKey: '2:183',
        citation: 'آية كتب عليكم الصيام',
        sourceId: 'src_quran',
      );
      expect(ev.verifyHash(), isTrue);
      expect(ev.integrityHash.startsWith('sha256:'), isTrue);

      final map = ev.toMap();
      final revived = EvidenceLink.fromMap(map);
      expect(revived, equals(ev));
    });

    test('LessonSection and Lesson compute and verify cryptographic hashes', () {
      final lesson = SyntheticLearningFixtures.createLesson();
      expect(lesson.verifyHash(), isTrue);

      final map = lesson.toMap();
      final revived = Lesson.fromMap(map);
      expect(revived, equals(lesson));
      expect(revived.verifyHash(), isTrue);
    });

    test('Strict semantic separation: SourceText is segregated from Explanation and ScholarlyView', () {
      final s1 = LessonSection.create(
        sectionId: 's1',
        title: 'نص',
        contentType: LearningContentType.sourceText,
        content: 'متن الحديث',
      );

      final s2 = LessonSection.create(
        sectionId: 's2',
        title: 'شرح',
        contentType: LearningContentType.explanation,
        content: 'شرح الحديث',
      );

      expect(s1.contentType, isNot(equals(s2.contentType)));
      expect(s1.contentType.labelArabic, equals('نص مصدري أصيل'));
      expect(s2.contentType.labelArabic, equals('شرح وبيان تأصيلي'));
    });
  });
}
