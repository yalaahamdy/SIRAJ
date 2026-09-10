import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('SIRAJ Phase 6 — Contemporary Financial Fiqh & Usul al-Fiqh Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 6 Integration 1: Canonical package contains all Muamalat & Usul paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId.startsWith('pkg_learning_canonical_seed_'), isTrue);
      expect(canonicalLearningPkg.paths.length, greaterThanOrEqualTo(31));
      expect(canonicalLearningPkg.courses.length, greaterThanOrEqualTo(25));
      expect(canonicalLearningPkg.modules.length, greaterThanOrEqualTo(50));
      expect(canonicalLearningPkg.lessons.length, greaterThanOrEqualTo(158));
      expect(canonicalLearningPkg.quizzes.length, greaterThanOrEqualTo(70));

      // Verify Paths
      final muamalatPath = canonicalLearningPkg.paths.firstWhere(
        (p) => p.pathId == 'path_fiqh_muamalat_comprehensive',
      );
      expect(muamalatPath.title, contains('المعاملات المالية'));
      expect(muamalatPath.courseIds.length, equals(4));

      final pathBuyu = canonicalLearningPkg.paths.firstWhere((p) => p.pathId == 'path_fiqh_buyu');
      final pathBanking = canonicalLearningPkg.paths.firstWhere((p) => p.pathId == 'path_fiqh_banking');
      final pathUsul = canonicalLearningPkg.paths.firstWhere((p) => p.pathId == 'path_fiqh_usul');
      final pathQawaid = canonicalLearningPkg.paths.firstWhere((p) => p.pathId == 'path_fiqh_qawaid');
      expect(pathBuyu, isNotNull);
      expect(pathBanking, isNotNull);
      expect(pathUsul, isNotNull);
      expect(pathQawaid, isNotNull);

      // Verify Courses
      final expectedCourseIds = [
        'course_fiqh_buyu_contracts',
        'course_fiqh_banking_contemporary',
        'course_fiqh_usul_intro',
        'course_fiqh_qawaid_maqasid',
      ];
      for (final cid in expectedCourseIds) {
        expect(
          canonicalLearningPkg.courses.any((c) => c.courseId == cid),
          isTrue,
          reason: 'Course $cid must be registered',
        );
      }

      // Verify Lessons
      final muamalatLessons = canonicalLearningPkg.lessons.where(
        (l) => expectedCourseIds.contains(l.courseId),
      ).toList();
      expect(muamalatLessons.length, equals(24));

      for (final lesson in muamalatLessons) {
        expect(lesson.verifyHash(), isTrue);
        expect(lesson.objectives.length, greaterThanOrEqualTo(3));
        expect(lesson.sections.length, greaterThanOrEqualTo(1));
        for (final sec in lesson.sections) {
          expect(sec.verifyHash(), isTrue);
          expect(sec.content.isNotEmpty, isTrue);
          for (final ev in sec.evidenceLinks) {
            expect(ev.verifyHash(), isTrue);
            expect(ev.citation.isNotEmpty, isTrue);
          }
        }
      }

      // Verify Quizzes
      final muamalatQuizzes = canonicalLearningPkg.quizzes.where(
        (q) => q.quizId.startsWith('quiz_buyu_') ||
            q.quizId.startsWith('quiz_banking_') ||
            q.quizId.startsWith('quiz_usul_') ||
            q.quizId.startsWith('quiz_qawaid_') ||
            q.quizId.startsWith('quiz_maqasid_'),
      ).toList();
      expect(muamalatQuizzes.length, equals(8));

      for (final quiz in muamalatQuizzes) {
        expect(quiz.questions.isNotEmpty, isTrue);
        for (final q in quiz.questions) {
          expect(q.verifyHash(), isTrue);
          expect(q.correctOptionIndices.isNotEmpty, isTrue);
          expect(q.options.length, greaterThanOrEqualTo(3));
        }
      }

      // Verify Full Package Cryptographic Integrity
      expect(canonicalLearningPkg.verifyPackageIntegrity(), isTrue);
    });

    test('Phase 6 Integration 2: LearningModule mounts v8 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_buyu_pillars_legality');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('مشروعية البيع'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_buyu_pillars_legality', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_buyu_pillars_legality', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
