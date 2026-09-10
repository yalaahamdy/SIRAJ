import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/madhahib_and_history/learning_four_madhahib_history_data.dart';
import 'package:siraj/shell/seed/data/learning/madhahib_and_history/learning_ikhtilaf_causes_adab_data.dart';
import 'package:siraj/shell/seed/data/learning/madhahib_and_history/learning_imams_biographies_data.dart';
import 'package:siraj/shell/seed/data/learning/madhahib_and_history/learning_fiqh_codification_encyclopedias_data.dart';

void main() {
  group('SIRAJ Phase 10 — Major Madhahib, Ijtihad, Ikhtilaf, Imams Biographies & Fiqh Codification Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 10 Integration 1: Canonical package contains all Phase 10 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId.startsWith('pkg_learning_canonical_seed_'), isTrue);
      expect(canonicalLearningPkg.paths.length, greaterThanOrEqualTo(51));
      expect(canonicalLearningPkg.courses.length, greaterThanOrEqualTo(41));
      expect(canonicalLearningPkg.modules.length, greaterThanOrEqualTo(82));
      expect(canonicalLearningPkg.lessons.length, greaterThanOrEqualTo(254));
      expect(canonicalLearningPkg.quizzes.length, greaterThanOrEqualTo(102));

      // Verify Phase 10 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_madhahib_history_ijtihad_imams_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_four_madhahib_history'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_ikhtilaf_causes_adab'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_imams_biographies'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_fiqh_codification_encyclopedias'), isTrue);

      // Verify Phase 10 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningFourMadhahibHistoryData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningIkhtilafCausesAdabData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningImamsBiographiesData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningFiqhCodificationEncyclopediasData.courseId), isTrue);

      // Verify Phase 10 Modules (8 modules)
      final phase10ModuleIds = [
        'mod_hanafi_maliki_foundations',
        'mod_shafii_hanbali_foundations',
        'mod_ikhtilaf_linguistic_hadith_causes',
        'mod_adab_ikhtilaf_inssaf',
        'mod_imams_biographies_classical',
        'mod_imams_reformers_scholars',
        'mod_fiqh_codification_stages',
        'mod_contemporary_codification_councils',
      ];
      for (final modId in phase10ModuleIds) {
        expect(canonicalLearningPkg.modules.any((m) => m.moduleId == modId), isTrue, reason: 'Module $modId should be present');
      }

      // Verify Phase 10 Lessons (24 lessons)
      final phase10Lessons = [
        ...LearningFourMadhahibHistoryData.getLessons(),
        ...LearningIkhtilafCausesAdabData.getLessons(),
        ...LearningImamsBiographiesData.getLessons(),
        ...LearningFiqhCodificationEncyclopediasData.getLessons(),
      ];
      expect(phase10Lessons.length, equals(24));

      for (final lsn in phase10Lessons) {
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

      // Verify Phase 10 Quizzes (8 quizzes)
      final phase10Quizzes = [
        ...LearningFourMadhahibHistoryData.getQuizzes(),
        ...LearningIkhtilafCausesAdabData.getQuizzes(),
        ...LearningImamsBiographiesData.getQuizzes(),
        ...LearningFiqhCodificationEncyclopediasData.getQuizzes(),
      ];
      expect(phase10Quizzes.length, equals(8));

      for (final quiz in phase10Quizzes) {
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

    test('Phase 10 Integration 2: LearningModule mounts v12 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_madhahib_hanafi_school_foundations');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('المذهب الحنفي'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_madhahib_hanafi_school_foundations', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_madhahib_hanafi_school_foundations', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
