import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/medical_and_environment/learning_medical_surgeries_transplants_data.dart';
import 'package:siraj/shell/seed/data/learning/medical_and_environment/learning_genetics_assisted_reproduction_data.dart';
import 'package:siraj/shell/seed/data/learning/medical_and_environment/learning_epidemics_public_health_dispensations_data.dart';
import 'package:siraj/shell/seed/data/learning/medical_and_environment/learning_environment_earth_stewardship_data.dart';

void main() {
  group('SIRAJ Phase 9 — Contemporary Medical Fiqh, Bioethics & Environmental Stewardship Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 9 Integration 1: Canonical package contains all Phase 9 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId.startsWith('pkg_learning_canonical_seed_'), isTrue);
      expect(canonicalLearningPkg.paths.length, greaterThanOrEqualTo(46));
      expect(canonicalLearningPkg.courses.length, greaterThanOrEqualTo(37));
      expect(canonicalLearningPkg.modules.length, greaterThanOrEqualTo(74));
      expect(canonicalLearningPkg.lessons.length, greaterThanOrEqualTo(230));
      expect(canonicalLearningPkg.quizzes.length, greaterThanOrEqualTo(94));

      // Verify Phase 9 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_medical_bioethics_environment_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_medical_surgeries_transplants'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_genetics_assisted_reproduction'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_epidemics_public_health_dispensations'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_environment_earth_stewardship'), isTrue);

      // Verify Phase 9 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningMedicalSurgeriesTransplantsData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningGeneticsAssistedReproductionData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningEpidemicsPublicHealthDispensationsData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningEnvironmentEarthStewardshipData.courseId), isTrue);

      // Verify Phase 9 Modules (8 modules)
      final phase9Modules = canonicalLearningPkg.modules.where(
        (m) => m.moduleId.startsWith('mod_medical_') ||
            m.moduleId.startsWith('mod_organ_') ||
            m.moduleId.startsWith('mod_assisted_') ||
            m.moduleId.startsWith('mod_genetic_') ||
            m.moduleId.startsWith('mod_epidemics_') ||
            m.moduleId.startsWith('mod_dispensations_') ||
            m.moduleId.startsWith('mod_environment_') ||
            m.moduleId.startsWith('mod_animal_'),
      ).toList();
      expect(phase9Modules.length, equals(8));

      // Verify Phase 9 Lessons (24 lessons)
      final phase9Lessons = canonicalLearningPkg.lessons.where(
        (l) => l.lessonId.startsWith('lsn_medical_') ||
            l.lessonId.startsWith('lsn_assisted_') ||
            l.lessonId.startsWith('lsn_genetics_') ||
            l.lessonId.startsWith('lsn_epidemics_') ||
            l.lessonId.startsWith('lsn_dispensations_') ||
            l.lessonId.startsWith('lsn_environment_'),
      ).toList();
      expect(phase9Lessons.length, equals(24));

      for (final lsn in phase9Lessons) {
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

      // Verify Phase 9 Quizzes (8 quizzes)
      final phase9Quizzes = canonicalLearningPkg.quizzes.where(
        (q) => q.quizId.startsWith('quiz_medical_') ||
            q.quizId.startsWith('quiz_organ_') ||
            q.quizId.startsWith('quiz_assisted_') ||
            q.quizId.startsWith('quiz_genetic_') ||
            q.quizId.startsWith('quiz_epidemics_') ||
            q.quizId.startsWith('quiz_environment_') ||
            q.quizId.startsWith('quiz_animal_'),
      ).toList();
      expect(phase9Quizzes.length, equals(8));

      for (final quiz in phase9Quizzes) {
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

    test('Phase 9 Integration 2: LearningModule mounts v11 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_medical_treatment_necessity_rules');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('حكم التداوي'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_medical_treatment_necessity_rules', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_medical_treatment_necessity_rules', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
