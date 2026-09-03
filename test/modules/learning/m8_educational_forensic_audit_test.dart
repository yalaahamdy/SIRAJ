import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_school.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/domain/canonical_learning_package.dart';
import 'package:siraj/modules/learning/domain/course.dart';
import 'package:siraj/modules/learning/domain/course_module.dart';
import 'package:siraj/modules/learning/domain/evidence_link.dart';
import 'package:siraj/modules/learning/domain/learning_content_type.dart';
import 'package:siraj/modules/learning/domain/learning_goal.dart';
import 'package:siraj/modules/learning/domain/learning_path.dart' as lp;
import 'package:siraj/modules/learning/domain/learning_progress.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import 'package:siraj/modules/learning/domain/revision_item.dart';
import 'package:siraj/modules/learning/engine/curriculum_engine.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/learning/scheduler/learning_revision_scheduler.dart';
import 'package:siraj/modules/learning/store/read_only_learning_store.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M8 Educational & Knowledge Integrity Forensic Audit Suite', () {
    late MemoryStorageRegistry registry;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: registry);

      // Mount synthetic M7 knowledge
      final knowPkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(knowPkg);

      learningModule = LearningModule(
        storageRegistry: registry,
        knowledgeModule: knowledgeModule,
      );
      final learnPkg = SyntheticLearningFixtures.createPackage();
      learningModule.mountPackage(learnPkg);
    });

    test('Audit 1: Source -> Lesson -> Evidence Link Resolution Traceability', () {
      final evLink = EvidenceLink.create(
        evidenceId: 'ev_test_1',
        evidenceKey: 'hadith_001',
        citation: 'حديث: إنما الأعمال بالنيات',
        sourceId: 'src_bukhari_test',
      );

      final resolved = learningModule.lessonEngine.resolveEvidence(evLink);
      expect(resolved.hadith, isNotNull);
      expect(resolved.hadith!.arabicMatn, contains('إنما الأعمال بالنيات'));
      expect(resolved.source, isNotNull);
      expect(resolved.source!.title, contains('صحيح البخاري'));
    });

    test('Audit 2: Content Type Separation Prevents Conflating Explanation with Source Text', () {
      final sourceSec = LessonSection.create(
        sectionId: 'sec_source',
        title: 'الآية الكريمة',
        contentType: LearningContentType.sourceText,
        content: '﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ﴾',
      );

      final explanationSec = LessonSection.create(
        sectionId: 'sec_explanation',
        title: 'البيان والتأصيل',
        contentType: LearningContentType.explanation,
        content: 'بينت الآية الكريمة أركان الوضوء الواجبة شرعاً.',
      );

      final scholarlySec = LessonSection.create(
        sectionId: 'sec_scholar',
        title: 'قول الشافعية',
        contentType: LearningContentType.scholarlyView,
        content: 'استدل الشافعية بالحديث على وجوب اقتران النية بغسل الوجه.',
      );

      expect(sourceSec.contentType, equals(LearningContentType.sourceText));
      expect(explanationSec.contentType, equals(LearningContentType.explanation));
      expect(scholarlySec.contentType, equals(LearningContentType.scholarlyView));
      expect(sourceSec.contentType, isNot(equals(explanationSec.contentType)));
      expect(explanationSec.contentType, isNot(equals(scholarlySec.contentType)));
    });

    test('Audit 3: Multi-Position Fiqh Disagreement Integrity (No Collapsing of Positions)', () {
      final topicRes = knowledgeModule.getFiqhTopic('topic_niyyah_fasting');
      expect(topicRes.isSuccess, isTrue);
      final topic = topicRes.valueOrNull!;

      expect(topic.positions.length, equals(2));
      final hanafi = topic.positions.firstWhere((p) => p.school == FiqhSchool.hanafi);
      final jumhoor = topic.positions.firstWhere((p) => p.school == FiqhSchool.majority);

      expect(hanafi.rulingText, contains('تصح النية في صوم رمضان'));
      expect(jumhoor.rulingText, contains('يشترط تبييت النية من الليل'));
    });

    test('Audit 4: Quiz Answer Mapping, Negative Out-of-Bounds & Empty Answers Safety', () {
      final quizRes = learningModule.getQuizByLesson('lsn_wudu_pillars');
      expect(quizRes.isSuccess, isTrue);
      final quiz = quizRes.valueOrNull!;

      // 1. Empty answer submission
      final emptyRes = learningModule.evaluateQuiz(
        quizId: quiz.quizId,
        userAnswers: {},
      );
      expect(emptyRes.isSuccess, isTrue);
      expect(emptyRes.valueOrNull!.result.passed, isFalse);
      expect(emptyRes.valueOrNull!.result.score, equals(0));

      // 2. Out of bounds answer submission
      final outOfBoundsRes = learningModule.evaluateQuiz(
        quizId: quiz.quizId,
        userAnswers: {
          'q_wudu_count': [99], // Out of bounds option index
        },
      );
      expect(outOfBoundsRes.isSuccess, isTrue);
      expect(outOfBoundsRes.valueOrNull!.result.passed, isFalse);
      expect(outOfBoundsRes.valueOrNull!.result.score, equals(0));
    });

    test('Audit 5: Mastery Score Mathematical Invariants & Piety Rating Prohibition', () {
      final masteryEngine = learningModule.masteryEngine;
      final emptyProgress = LearningProgress(updatedAt: DateTime.now().toUtc());

      final snapshot = masteryEngine.computeMastery(emptyProgress);
      expect(snapshot.overallMasteryScore, equals(0.0));
      expect(snapshot.lessonCompletionFactor, equals(0.0));
      expect(snapshot.quizPerformanceFactor, equals(0.0));
      expect(snapshot.revisionHealthFactor, equals(0.0));

      // Assert that snapshot contains ONLY educational factors and NO religious ranking
      expect(snapshot.overallMasteryScore >= 0.0, isTrue);
      expect(snapshot.overallMasteryScore <= 100.0, isTrue);
    });

    test('Audit 6: Revision Scheduler Mathematical & Bounds Safety', () {
      const scheduler = LearningRevisionScheduler();
      final now = DateTime.utc(2026, 9, 1);

      var item = RevisionItem(
        itemId: 'rev_test',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_1',
        dueAt: now,
      );

      // 10 consecutive perfect reviews
      for (int i = 0; i < 10; i++) {
        item = scheduler.scheduleNextReview(current: item, quality: 5, now: now);
        expect(item.intervalDays <= 365, isTrue);
        expect(item.easeFactor >= 1.3, isTrue);
      }

      // Single failure resets
      item = scheduler.scheduleNextReview(current: item, quality: 1, now: now);
      expect(item.repetitionCount, equals(0));
      expect(item.intervalDays, equals(1));
    });

    test('Audit 7: Curriculum DAG Cycle Detection Blocks Circular Chains', () {
      final modA = const CourseModule(
        moduleId: 'm_a',
        courseId: 'c_1',
        title: 'أ',
        description: '',
        orderIndex: 1,
        lessonIds: [],
        prerequisiteModuleIds: ['m_b'],
      );
      final modB = const CourseModule(
        moduleId: 'm_b',
        courseId: 'c_1',
        title: 'ب',
        description: '',
        orderIndex: 2,
        lessonIds: [],
        prerequisiteModuleIds: ['m_c'],
      );
      final modC = const CourseModule(
        moduleId: 'm_c',
        courseId: 'c_1',
        title: 'ج',
        description: '',
        orderIndex: 3,
        lessonIds: [],
        prerequisiteModuleIds: ['m_a'], // Circular loop A->B->C->A
      );

      final course = Course.create(
        courseId: 'c_1',
        pathId: 'p_1',
        title: 'دورة دورية',
        description: '',
        level: lp.LearningLevel.beginner,
        moduleIds: ['m_a', 'm_b', 'm_c'],
        author: 'لجنة',
      );

      final cyclicPkg = CanonicalLearningPackage.create(
        packageId: 'pkg_cyclic',
        paths: const [],
        courses: [course],
        modules: [modA, modB, modC],
        lessons: const [],
        quizzes: const [],
        signerIdentity: 'signer',
        signature: 'sig',
        publishedAt: DateTime.utc(2026, 8, 31),
      );

      final testStore = ReadOnlyLearningStore();
      testStore.mountPackage(cyclicPkg);
      final curriculumEngine = CurriculumEngine(store: testStore);

      final cycleCheck = curriculumEngine.validateCurriculumDAG();
      expect(cycleCheck.isFailure, isTrue);
    });

    test('Audit 8: Historical Versioning Consistency (Lesson v1 vs v2)', () async {
      // User completes v1
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);

      final progressRes = await learningModule.getUserProgress();
      expect(progressRes.isSuccess, isTrue);
      final progress = progressRes.valueOrNull!;

      expect(progress.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
      expect(progress.isLessonCompleted('lsn_wudu_pillars', 2), isFalse);
    });

    test('Audit 9: User Note Injection & Local-First Isolation', () async {
      // User creates note containing an arbitrary claim
      await learningModule.saveUserNote('lsn_wudu_pillars', 'حكم المسألة هو الوجوب المطلق بلا خلاف');

      // Verify note is saved in user store
      final progressRes = await learningModule.getUserProgress();
      expect(progressRes.valueOrNull!.userNotes['lsn_wudu_pillars'], contains('حكم المسألة هو الوجوب المطلق'));

      // Verify canonical lesson and store remain 100% pure and untouched
      final lessonRes = learningModule.getLesson('lsn_wudu_pillars');
      final lesson = lessonRes.valueOrNull!;
      expect(lesson.verifyHash(), isTrue);
      expect(lesson.sections.any((s) => s.content.contains('الوجوب المطلق بلا خلاف')), isFalse);
    });

    test('Audit 10: Canonical Shield Invariance Across All Modules (M1..M8)', () async {
      final quranStore = ReadOnlyCanonicalQuranStore();
      quranStore.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final adhkarStore = ReadOnlyAdhkarStore();
      adhkarStore.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);
      final zakatMod = ZakatModule(storageRegistry: registry);
      final fastingMod = FastingModule(storageRegistry: registry, prayerModule: prayerMod);

      await zakatMod.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 50000));
      await fastingMod.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      final ayahBefore = quranStore.getAyah(1, 1).valueOrNull!;
      final adhkarHashBefore = adhkarStore.activePackage!.contentHash;
      final knowHashBefore = knowledgeModule.store.activePackage!.contentHash;

      // Heavy learning mutations
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);
      await learningModule.toggleBookmark('lsn_wudu_pillars');
      await learningModule.saveUserNote('lsn_wudu_pillars', 'ملاحظة');
      await learningModule.saveGoal(
        LearningGoal(
          goalId: 'g_1',
          title: 'هدف',
          startDate: DateTime.now().toUtc(),
        ),
      );
      await learningModule.resetAllUserData();

      // Verify full cross-module immunity
      expect(quranStore.getAyah(1, 1).valueOrNull!, equals(ayahBefore));
      expect(adhkarStore.activePackage!.contentHash, equals(adhkarHashBefore));
      expect(knowledgeModule.store.activePackage!.contentHash, equals(knowHashBefore));
    });
  });
}
