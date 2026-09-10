import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/family_and_society/learning_family_inheritance_data.dart';
import 'package:siraj/shell/seed/data/learning/family_and_society/learning_ethics_adab_tarbiyah_data.dart';
import 'package:siraj/shell/seed/data/learning/family_and_society/learning_dawah_hisbah_dialogue_data.dart';
import 'package:siraj/shell/seed/data/learning/family_and_society/learning_thought_awareness_data.dart';

void main() {
  group('SIRAJ Phase 7 — Family Fiqh, Islamic Ethics, Dawah & Contemporary Thought Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 7 Integration 1: Canonical package contains all Phase 7 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId.startsWith('pkg_learning_canonical_seed_'), isTrue);
      expect(canonicalLearningPkg.paths.length, greaterThanOrEqualTo(36));
      expect(canonicalLearningPkg.courses.length, greaterThanOrEqualTo(29));
      expect(canonicalLearningPkg.modules.length, greaterThanOrEqualTo(58));
      expect(canonicalLearningPkg.lessons.length, greaterThanOrEqualTo(182));
      expect(canonicalLearningPkg.quizzes.length, greaterThanOrEqualTo(78));

      // Verify Phase 7 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_family_ethics_society_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_fiqh_family_inheritance'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_ethics_adab_tarbiyah'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_dawah_hisbah_dialogue'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_thought_awareness'), isTrue);

      // Verify Phase 7 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningFamilyInheritanceData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningEthicsAdabTarbiyahData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningDawahHisbahDialogueData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningThoughtAwarenessData.courseId), isTrue);

      // Verify Phase 7 Modules (8 modules)
      final phase7Modules = canonicalLearningPkg.modules.where(
        (m) => m.moduleId.startsWith('mod_family_') ||
            m.moduleId.startsWith('mod_ethics_') ||
            m.moduleId.startsWith('mod_dawah_') ||
            m.moduleId.startsWith('mod_thought_'),
      ).toList();
      expect(phase7Modules.length, equals(8));

      // Verify Phase 7 Lessons (24 lessons)
      final phase7Lessons = canonicalLearningPkg.lessons.where(
        (l) => l.lessonId.startsWith('lsn_family_') ||
            l.lessonId.startsWith('lsn_ethics_') ||
            l.lessonId.startsWith('lsn_dawah_') ||
            l.lessonId.startsWith('lsn_thought_'),
      ).toList();
      expect(phase7Lessons.length, equals(24));

      for (final lsn in phase7Lessons) {
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

      // Verify Phase 7 Quizzes (8 quizzes)
      final phase7Quizzes = canonicalLearningPkg.quizzes.where(
        (q) => q.quizId.startsWith('quiz_family_') ||
            q.quizId.startsWith('quiz_ethics_') ||
            q.quizId.startsWith('quiz_dawah_') ||
            q.quizId.startsWith('quiz_thought_'),
      ).toList();
      expect(phase7Quizzes.length, equals(8));

      for (final quiz in phase7Quizzes) {
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

    test('Phase 7 Integration 2: LearningModule mounts v9 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_family_marriage_pillars');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('الخطبة وأركان عقد النكاح'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_family_marriage_pillars', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_family_marriage_pillars', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
