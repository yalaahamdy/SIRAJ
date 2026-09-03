import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/canonical_learning_package.dart';
import 'package:siraj/modules/learning/domain/course.dart';
import 'package:siraj/modules/learning/domain/course_module.dart';
import 'package:siraj/modules/learning/domain/learning_path.dart';
import 'package:siraj/modules/learning/domain/learning_progress.dart';
import 'package:siraj/modules/learning/engine/curriculum_engine.dart';
import 'package:siraj/modules/learning/store/read_only_learning_store.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L2 Curriculum Engine, Prerequisites & DAG Tests (§37, §38, §39)', () {
    late ReadOnlyLearningStore store;
    late CurriculumEngine engine;

    setUp(() {
      store = ReadOnlyLearningStore();
      engine = CurriculumEngine(store: store);
      final pkg = SyntheticLearningFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('validateCurriculumDAG returns true for acyclic valid curriculum', () {
      final res = engine.validateCurriculumDAG();
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull, isTrue);
    });

    test('Detects circular prerequisite dependencies in curriculum DAG', () {
      final mod1 = const CourseModule(
        moduleId: 'mod_a',
        courseId: 'course_test',
        title: 'الوحدة أ',
        description: 'وصف',
        orderIndex: 1,
        lessonIds: ['lsn_1'],
        prerequisiteModuleIds: ['mod_b'], // Circular
      );

      final mod2 = const CourseModule(
        moduleId: 'mod_b',
        courseId: 'course_test',
        title: 'الوحدة ب',
        description: 'وصف',
        orderIndex: 2,
        lessonIds: ['lsn_2'],
        prerequisiteModuleIds: ['mod_a'], // Circular back to mod_a
      );

      final course = Course.create(
        courseId: 'course_test',
        pathId: 'path_test',
        title: 'مقرر اختباري',
        description: 'وصف',
        level: LearningLevel.beginner,
        moduleIds: ['mod_a', 'mod_b'],
        author: 'لجنة الاختبار',
      );

      final brokenPkg = CanonicalLearningPackage.create(
        packageId: 'pkg_broken',
        paths: const [],
        courses: [course],
        modules: [mod1, mod2],
        lessons: const [],
        quizzes: const [],
        signerIdentity: 'signer',
        signature: 'sig',
        publishedAt: DateTime.utc(2026, 8, 31),
      );

      final brokenStore = ReadOnlyLearningStore();
      brokenStore.mountPackage(brokenPkg);
      final brokenEngine = CurriculumEngine(store: brokenStore);

      final cycleRes = brokenEngine.validateCurriculumDAG();
      expect(cycleRes.isFailure, isTrue);
      expect(cycleRes.failureOrNull!.message.contains('Circular prerequisite'), isTrue);
    });

    test('isModuleUnlocked requires all prerequisite module lessons to be completed', () {
      final mod1 = const CourseModule(
        moduleId: 'mod_1',
        courseId: 'course_101',
        title: 'الوحدة الأولى',
        description: '',
        orderIndex: 1,
        lessonIds: ['lsn_1'],
      );

      final mod2 = const CourseModule(
        moduleId: 'mod_2',
        courseId: 'course_101',
        title: 'الوحدة الثانية',
        description: '',
        orderIndex: 2,
        lessonIds: ['lsn_2'],
        prerequisiteModuleIds: ['mod_1'],
      );

      final emptyProgress = LearningProgress(updatedAt: DateTime.now().toUtc());
      expect(engine.isModuleUnlocked(mod1, emptyProgress), isTrue); // No prerequisites

      // Mod2 is locked before Mod1 is done
      expect(engine.isModuleUnlocked(mod2, emptyProgress), isFalse);

      // Complete Mod1 lesson
      final completedProgress = emptyProgress.copyWith(
        completedLessonVersions: {'lsn_1': 1},
      );
      // Wait, need mod1 in store
      final testStore = ReadOnlyLearningStore();
      final course = Course.create(
        courseId: 'course_101',
        pathId: 'path_1',
        title: 'مقرر',
        description: '',
        level: LearningLevel.beginner,
        moduleIds: ['mod_1', 'mod_2'],
        author: 'المؤلف',
      );
      final testPkg = CanonicalLearningPackage.create(
        packageId: 'pkg_test',
        paths: const [],
        courses: [course],
        modules: [mod1, mod2],
        lessons: const [],
        quizzes: const [],
        signerIdentity: 'signer',
        signature: 'sig',
        publishedAt: DateTime.utc(2026, 8, 31),
      );
      testStore.mountPackage(testPkg);
      final testEngine = CurriculumEngine(store: testStore);

      expect(testEngine.isModuleUnlocked(mod2, completedProgress), isTrue);
    });
  });
}
