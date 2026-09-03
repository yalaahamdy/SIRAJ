import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/canonical_learning_package.dart';
import 'package:siraj/modules/learning/domain/lesson.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import 'package:siraj/modules/learning/store/read_only_learning_store.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L2 Learning Package Cryptographic Integrity & Fail-Closed Tests (§33, §34)', () {
    late ReadOnlyLearningStore store;

    setUp(() {
      store = ReadOnlyLearningStore();
    });

    test('Valid synthetic package passes all integrity and cryptographic checks', () {
      final pkg = SyntheticLearningFixtures.createPackage();
      expect(pkg.verifyPackageIntegrity(), isTrue);

      final mountRes = store.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
      expect(store.verifyIntegrity(), isTrue);
    });

    test('Rejects package if any individual Lesson section text is tampered', () {
      final validPkg = SyntheticLearningFixtures.createPackage();
      final originalLesson = validPkg.lessons.first;

      final tamperedSection = LessonSection.create(
        sectionId: originalLesson.sections.first.sectionId,
        title: originalLesson.sections.first.title,
        contentType: originalLesson.sections.first.contentType,
        content: 'نص محرف بطريقة غير مصرح بها', // Tampered text
      );

      final tamperedLesson = Lesson(
        lessonId: originalLesson.lessonId,
        title: originalLesson.title,
        courseId: originalLesson.courseId,
        moduleId: originalLesson.moduleId,
        orderIndex: originalLesson.orderIndex,
        objectives: originalLesson.objectives,
        sections: [tamperedSection, originalLesson.sections[1]],
        sources: originalLesson.sources,
        authorOrEditor: originalLesson.authorOrEditor,
        version: originalLesson.version,
        reviewState: originalLesson.reviewState,
        integrityHash: originalLesson.integrityHash, // Stale
      );

      final tamperedPkg = CanonicalLearningPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        paths: validPkg.paths,
        courses: validPkg.courses,
        modules: validPkg.modules,
        lessons: [tamperedLesson],
        quizzes: validPkg.quizzes,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      expect(tamperedPkg.verifyPackageIntegrity(), isFalse);
      final mountRes = store.mountPackage(tamperedPkg);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse); // Fail-Closed
    });

    test('Rejects package with empty signature or signer identity', () {
      final validPkg = SyntheticLearningFixtures.createPackage();
      final unsignedPkg = CanonicalLearningPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        paths: validPkg.paths,
        courses: validPkg.courses,
        modules: validPkg.modules,
        lessons: validPkg.lessons,
        quizzes: validPkg.quizzes,
        contentHash: validPkg.contentHash,
        signerIdentity: '', // Empty
        signature: '',
        publishedAt: validPkg.publishedAt,
      );

      expect(unsignedPkg.verifyPackageIntegrity(), isFalse);
      final mountRes = store.mountPackage(unsignedPkg);
      expect(mountRes.isFailure, isTrue);
    });
  });
}
