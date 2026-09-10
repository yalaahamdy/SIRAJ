import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/governance_and_judiciary/learning_judiciary_evidence_data.dart';
import 'package:siraj/shell/seed/data/learning/governance_and_judiciary/learning_siyasah_shariyyah_governance_data.dart';
import 'package:siraj/shell/seed/data/learning/governance_and_judiciary/learning_international_relations_treaties_data.dart';
import 'package:siraj/shell/seed/data/learning/governance_and_judiciary/learning_human_rights_liberties_data.dart';

void main() {
  group('SIRAJ Phase 8 — Judiciary, Governance, International Relations & Human Rights Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 8 Integration 1: Canonical package contains all Phase 8 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId.startsWith('pkg_learning_canonical_seed_'), isTrue);
      expect(canonicalLearningPkg.paths.length, greaterThanOrEqualTo(41));
      expect(canonicalLearningPkg.courses.length, greaterThanOrEqualTo(33));
      expect(canonicalLearningPkg.modules.length, greaterThanOrEqualTo(66));
      expect(canonicalLearningPkg.lessons.length, greaterThanOrEqualTo(206));
      expect(canonicalLearningPkg.quizzes.length, greaterThanOrEqualTo(86));

      // Verify Phase 8 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_governance_judiciary_rights_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_fiqh_judiciary_evidence'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_siyasah_shariyyah_governance'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_international_relations_treaties'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_human_rights_liberties'), isTrue);

      // Verify Phase 8 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningJudiciaryEvidenceData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningSiyasahShariyyahGovernanceData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningInternationalRelationsTreatiesData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningHumanRightsLibertiesData.courseId), isTrue);

      // Verify Phase 8 Modules (8 modules)
      final phase8Modules = canonicalLearningPkg.modules.where(
        (m) => m.moduleId.startsWith('mod_judiciary_') ||
            m.moduleId.startsWith('mod_governance_') ||
            m.moduleId.startsWith('mod_international_') ||
            m.moduleId.startsWith('mod_human_rights_'),
      ).toList();
      expect(phase8Modules.length, equals(8));

      // Verify Phase 8 Lessons (24 lessons)
      final phase8Lessons = canonicalLearningPkg.lessons.where(
        (l) => l.lessonId.startsWith('lsn_judiciary_') ||
            l.lessonId.startsWith('lsn_governance_') ||
            l.lessonId.startsWith('lsn_international_') ||
            l.lessonId.startsWith('lsn_human_rights_'),
      ).toList();
      expect(phase8Lessons.length, equals(24));

      for (final lsn in phase8Lessons) {
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

      // Verify Phase 8 Quizzes (8 quizzes)
      final phase8Quizzes = canonicalLearningPkg.quizzes.where(
        (q) => q.quizId.startsWith('quiz_judiciary_') ||
            q.quizId.startsWith('quiz_governance_') ||
            q.quizId.startsWith('quiz_international_') ||
            q.quizId.startsWith('quiz_human_rights_'),
      ).toList();
      expect(phase8Quizzes.length, equals(8));

      for (final quiz in phase8Quizzes) {
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

    test('Phase 8 Integration 2: LearningModule mounts v10 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_judiciary_pillars_court_office');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('القضاء في الإسلام'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_judiciary_pillars_court_office', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_judiciary_pillars_court_office', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
