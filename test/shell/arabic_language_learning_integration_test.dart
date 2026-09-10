import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/shell/seed/data/learning/arabic_language_and_bayan/learning_nahw_wazifi_quran_data.dart';
import 'package:siraj/shell/seed/data/learning/arabic_language_and_bayan/learning_sarf_morphology_lexicon_data.dart';
import 'package:siraj/shell/seed/data/learning/arabic_language_and_bayan/learning_balaghah_quranic_bayan_data.dart';
import 'package:siraj/shell/seed/data/learning/arabic_language_and_bayan/learning_dalalat_alfaz_semantics_data.dart';

void main() {
  group('SIRAJ Phase 11 — Arabic Language Sciences, Quranic Rhetoric & Shari\'ah Semantics Integration Tests (§31..§35)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
    });

    test('Phase 11 Integration 1: Canonical package contains all Phase 11 paths, courses, modules, lessons, and quizzes', () {
      final canonicalLearningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();

      // Verify Package ID & Counts
      expect(canonicalLearningPkg.packageId, equals('pkg_learning_canonical_seed_v13'));
      expect(canonicalLearningPkg.paths.length, equals(56));
      expect(canonicalLearningPkg.courses.length, equals(45));
      expect(canonicalLearningPkg.modules.length, equals(90));
      expect(canonicalLearningPkg.lessons.length, equals(278));
      expect(canonicalLearningPkg.quizzes.length, equals(110));

      // Verify Phase 11 Paths
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_arabic_language_bayan_semantics_comprehensive'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_nahw_wazifi_quran'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_sarf_morphology_lexicon'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_balaghah_quranic_bayan'), isTrue);
      expect(canonicalLearningPkg.paths.any((p) => p.pathId == 'path_dalalat_alfaz_semantics'), isTrue);

      // Verify Phase 11 Courses
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningNahwWazifiQuranData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningSarfMorphologyLexiconData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningBalaghahQuranicBayanData.courseId), isTrue);
      expect(canonicalLearningPkg.courses.any((c) => c.courseId == LearningDalalatAlfazSemanticsData.courseId), isTrue);

      // Verify Phase 11 Modules (8 modules)
      final phase11ModuleIds = [
        'mod_nahw_syntax_marfuat',
        'mod_nahw_mansubat_majroorat_tawjih',
        'mod_sarf_mizan_awzan_ziyadah',
        'mod_sarf_mushtaqqat_ilal_ibdal',
        'mod_balaghah_ilm_al_maani',
        'mod_balaghah_bayan_badi_ijaz',
        'mod_fiqh_al_lughah_khasais',
        'mod_dalalat_usuliyyah_istinbat',
      ];
      for (final modId in phase11ModuleIds) {
        expect(canonicalLearningPkg.modules.any((m) => m.moduleId == modId), isTrue, reason: 'Module $modId should be present');
      }

      // Verify Phase 11 Lessons (24 lessons)
      final phase11Lessons = [
        ...LearningNahwWazifiQuranData.getLessons(),
        ...LearningSarfMorphologyLexiconData.getLessons(),
        ...LearningBalaghahQuranicBayanData.getLessons(),
        ...LearningDalalatAlfazSemanticsData.getLessons(),
      ];
      expect(phase11Lessons.length, equals(24));

      for (final lsn in phase11Lessons) {
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

      // Verify Phase 11 Quizzes (8 quizzes)
      final phase11Quizzes = [
        ...LearningNahwWazifiQuranData.getQuizzes(),
        ...LearningSarfMorphologyLexiconData.getQuizzes(),
        ...LearningBalaghahQuranicBayanData.getQuizzes(),
        ...LearningDalalatAlfazSemanticsData.getQuizzes(),
      ];
      expect(phase11Quizzes.length, equals(8));

      for (final quiz in phase11Quizzes) {
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

    test('Phase 11 Integration 2: LearningModule mounts v13 package and tracks lesson completion smoothly', () async {
      final pkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      final mountRes = learningModule.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);

      final lessonRes = learningModule.getLesson('lsn_nahw_irab_bina_foundations');
      expect(lessonRes.isSuccess, isTrue);
      expect(lessonRes.valueOrNull!.title, contains('الإعراب والبناء'));

      // Mark completed
      final completeRes = await learningModule.markLessonCompleted('lsn_nahw_irab_bina_foundations', 1);
      expect(completeRes.isSuccess, isTrue);

      final progress = await learningModule.getUserProgress();
      expect(progress.valueOrNull!.isLessonCompleted('lsn_nahw_irab_bina_foundations', 1), isTrue);

      final mastery = await learningModule.computeMastery();
      expect(mastery.valueOrNull!.overallMasteryScore, greaterThan(0));
    });
  });
}
