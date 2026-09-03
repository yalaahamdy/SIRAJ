import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/domain/evidence_link.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import 'package:siraj/modules/learning/domain/quiz_question.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('M8 Learning Adversarial Security & Cryptographic Attack Tests (§48)', () {
    late MemoryStorageRegistry registry;
    late LearningModule learningModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: registry);
      final pkg = SyntheticLearningFixtures.createPackage();
      learningModule.mountPackage(pkg);
    });

    test('Attack 1: Mutating a single word in a Lesson section causes hash invalidation', () {
      final lesson = SyntheticLearningFixtures.createLesson();
      expect(lesson.verifyHash(), isTrue);

      final tamperedSection = LessonSection(
        sectionId: lesson.sections.first.sectionId,
        title: lesson.sections.first.title,
        contentType: lesson.sections.first.contentType,
        content: 'نص ديني محرف وغير معتمد',
        evidenceLinks: lesson.sections.first.evidenceLinks,
        sourceAttribution: lesson.sections.first.sourceAttribution,
        integrityHash: lesson.sections.first.integrityHash, // Stale
      );

      expect(tamperedSection.verifyHash(), isFalse);
    });

    test('Attack 2: Modifying quiz correct options or explanation invalidates question hash', () {
      final quiz = SyntheticLearningFixtures.createQuiz();
      final q = quiz.questions.first;
      expect(q.verifyHash(), isTrue);

      final tamperedQ = QuizQuestion(
        questionId: q.questionId,
        lessonId: q.lessonId,
        questionText: q.questionText,
        questionType: q.questionType,
        options: q.options,
        correctOptionIndices: const [1], // Swapped correct answer
        explanation: q.explanation,
        evidenceLink: q.evidenceLink,
        sourceId: q.sourceId,
        integrityHash: q.integrityHash, // Stale
      );

      expect(tamperedQ.verifyHash(), isFalse);
    });

    test('Attack 3: Altering evidence citation text invalidates evidence link hash', () {
      final ev = EvidenceLink.create(
        evidenceId: 'ev_1',
        evidenceKey: '5:6',
        citation: 'آية الوضوء',
        sourceId: 'src_quran',
      );
      expect(ev.verifyHash(), isTrue);

      final tamperedEv = EvidenceLink(
        evidenceId: ev.evidenceId,
        evidenceKey: ev.evidenceKey,
        citation: 'آية مزورة محرفة',
        sourceId: ev.sourceId,
        context: ev.context,
        integrityHash: ev.integrityHash, // Stale
      );

      expect(tamperedEv.verifyHash(), isFalse);
    });

    test('Attack 4: Privacy Isolation: Learning user records reside exclusively in mod_learning namespace', () async {
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);

      final learnStore = registry.getStoreForModule('mod_learning');
      final prayerStore = registry.getStoreForModule('mod_prayer');
      final knowStore = registry.getStoreForModule('mod_knowledge');

      expect((await learnStore.getString('user_learning_progress')).valueOrNull, isNotNull);
      expect((await prayerStore.getString('user_learning_progress')).valueOrNull, isNull);
      expect((await knowStore.getString('user_learning_progress')).valueOrNull, isNull);
    });
  });
}
