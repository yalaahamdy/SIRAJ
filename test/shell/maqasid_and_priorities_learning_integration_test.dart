import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/maqasid_and_priorities/learning_maqasid_theory_history_data.dart';
import 'package:siraj/shell/seed/data/learning/maqasid_and_priorities/learning_kulliyyat_khams_rankings_data.dart';
import 'package:siraj/shell/seed/data/learning/maqasid_and_priorities/learning_fiqh_maal_zaraee_data.dart';
import 'package:siraj/shell/seed/data/learning/maqasid_and_priorities/learning_priorities_muwazanat_crises_data.dart';

void main() {
  group('SIRAJ Phase 12 — Maqasid al-Shari\'ah, Philosophy of Legislation, Fiqh of Outcomes & Priorities Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 12 Integration 1: Canonical package contains all Phase 12 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId, equals('pkg_learning_canonical_seed_v14'));
      expect(canonicalLearningPkg.paths.length, equals(61));
      expect(canonicalLearningPkg.courses.length, equals(49));
      expect(canonicalLearningPkg.modules.length, equals(98));
      expect(canonicalLearningPkg.lessons.length, equals(302));
      expect(canonicalLearningPkg.quizzes.length, equals(118));

      // Verify Phase 12 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_maqasid_shariah_philosophy_priorities_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_maqasid_theory_history_detection'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_kulliyyat_khams_rankings_omran'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_fiqh_maal_zaraee_heeyal'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_priorities_muwazanat_crises_applications'), isTrue);

      // Verify Phase 12 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningMaqasidTheoryHistoryData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningKulliyyatKhamsRankingsData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningFiqhMaalZaraeeData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningPrioritiesMuwazanatCrisesData.courseId), isTrue);

      // Verify Phase 12 Modules (8 modules)
      final phase12ModuleIds = [
        'mod_maqasid_origins_imams',
        'mod_maqasid_detection_methods',
        'mod_kulliyyat_khams_preservation',
        'mod_maqasid_rankings_classification',
        'mod_maal_zaraee_sad_fath',
        'mod_mukallaf_qasd_heeyal_fiqhiyyah',
        'mod_priorities_muwazanat_rules',
        'mod_maqasid_crises_contemporary',
      ];
      for (final modId in phase12ModuleIds) {
        expect(canonicalLearningPkg.modules.any((m) => m.moduleId == modId), isTrue, reason: 'Module $modId should be present');
      }

      // Verify Phase 12 Lessons (24 lessons)
      final phase12Lessons = [
        ...LearningMaqasidTheoryHistoryData.getLessons(),
        ...LearningKulliyyatKhamsRankingsData.getLessons(),
        ...LearningFiqhMaalZaraeeData.getLessons(),
        ...LearningPrioritiesMuwazanatCrisesData.getLessons(),
      ];
      expect(phase12Lessons.length, equals(24));

      for (final lsn in phase12Lessons) {
        expect(canonicalLearningPkg.lessons.any((l) => l.lessonId == lsn.lessonId), isTrue);
        expect(lsn.verifyHash(), isTrue);
        expect(lsn.objectives.isNotEmpty, isTrue);
        expect(lsn.sections.isNotEmpty, isTrue);
        for (final sec in lsn.sections) {
          expect(sec.verifyHash(), isTrue);
          expect(sec.content.isNotEmpty, isTrue);
          for (final ev in sec.evidenceLinks) {
            expect(ev.verifyHash(), isTrue);
            expect(ev.citation.isNotEmpty, isTrue);
          }
        }
      }

      // Verify Phase 12 Quizzes (8 quizzes)
      final phase12Quizzes = [
        ...LearningMaqasidTheoryHistoryData.getQuizzes(),
        ...LearningKulliyyatKhamsRankingsData.getQuizzes(),
        ...LearningFiqhMaalZaraeeData.getQuizzes(),
        ...LearningPrioritiesMuwazanatCrisesData.getQuizzes(),
      ];
      expect(phase12Quizzes.length, equals(8));

      for (final quiz in phase12Quizzes) {
        expect(canonicalLearningPkg.quizzes.any((q) => q.quizId == quiz.quizId), isTrue);
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

    test('Phase 12 Integration 2: LearningModule mounts v14 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_maqasid_history_origins_sahaba');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('الجذور المقاصدية'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_maqasid_history_origins_sahaba', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_maqasid_history_origins_sahaba', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
