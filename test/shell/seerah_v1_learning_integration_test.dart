import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah & Learning Integration Suite (§51, §107)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Learning Integration 1: Seerah module and Learning module operate harmoniously on common storage', () async {
      await seerahModule.markEventViewed('evt_badr_major');
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);

      final seerahProg = await seerahModule.getUserProgress();
      final learningProg = await learningModule.getUserProgress();

      expect(seerahProg.valueOrNull!.viewedEventIds, contains('evt_badr_major'));
      expect(learningProg.valueOrNull!.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
    });

    test('Learning Integration 2: Canonical Seerah curriculum links directly to canonical Seerah events without redundancy', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final canonicalSeerahPkg = DefaultCanonicalSeedProvider.getSeerahSeedPackage();

      // 1. Verify Seerah paths are registered
      final seerahPath = canonicalLearningPkg.paths.firstWhere((p) => p.pathId == 'path_seerah_history_curriculum');
      expect(seerahPath.title, contains('السيرة النبوية'));
      expect(seerahPath.courseIds.length, equals(3));

      // 2. Verify all 3 courses exist
      final makkanCourse = canonicalLearningPkg.courses.firstWhere((c) => c.courseId == 'course_seerah_makkan_study');
      final medinanCourse = canonicalLearningPkg.courses.firstWhere((c) => c.courseId == 'course_seerah_medinan_study');
      final shamailCourse = canonicalLearningPkg.courses.firstWhere((c) => c.courseId == 'course_seerah_shamail_study');
      expect(makkanCourse, isNotNull);
      expect(medinanCourse, isNotNull);
      expect(shamailCourse, isNotNull);

      // 3. Collect all canonical Seerah event, place, and person IDs
      final validSeerahIds = <String>{
        ...canonicalSeerahPkg.events.map((e) => e.eventId),
        ...canonicalSeerahPkg.places.map((p) => p.placeId),
        ...canonicalSeerahPkg.persons.map((p) => p.personId),
      };

      // 4. Verify that every Seerah evidence citation links to an existing entity in the Seerah package
      final seerahLessons = canonicalLearningPkg.lessons.where(
        (l) => l.courseId.startsWith('course_seerah_'),
      ).toList();

      expect(seerahLessons.length, equals(16));

      int totalSeerahLinksChecked = 0;
      for (final lesson in seerahLessons) {
        for (final section in lesson.sections) {
          for (final link in section.evidenceLinks) {
            if (link.sourceId == 'src_seerah_canonical') {
              expect(
                validSeerahIds.contains(link.evidenceKey),
                isTrue,
                reason: 'Lesson ${lesson.lessonId} references non-existent Seerah entity: ${link.evidenceKey}',
              );
              totalSeerahLinksChecked++;
            }
          }
        }
      }

      // Ensure robust linkage across the curriculum
      expect(totalSeerahLinksChecked, greaterThanOrEqualTo(25));
    });

    test('Learning Integration 3: Seerah formative quizzes are present and valid', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final seerahQuizzes = canonicalLearningPkg.quizzes.where(
        (q) => q.quizId.startsWith('quiz_seerah_'),
      ).toList();

      expect(seerahQuizzes.length, equals(6));
      for (final quiz in seerahQuizzes) {
        expect(quiz.questions.length, greaterThanOrEqualTo(1));
        for (final question in quiz.questions) {
          expect(question.correctOptionIndices.isNotEmpty, isTrue);
          expect(question.options.length, greaterThanOrEqualTo(3));
          expect(question.verifyHash(), isTrue);
        }
      }
    });
  });
}
