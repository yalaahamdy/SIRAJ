import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/learning_progress.dart';

void main() {
  group('L2 Learning Versioning & Historical Consistency Tests (§35, §36)', () {
    test('Completing Lesson v1 is tracked with version 1 and does not automatically complete v2', () {
      final progressV1 = LearningProgress(
        completedLessonVersions: const {'lsn_wudu_pillars': 1},
        updatedAt: DateTime.now().toUtc(),
      );

      expect(progressV1.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
      expect(progressV1.isLessonCompleted('lsn_wudu_pillars', 2), isFalse);
      expect(progressV1.getCompletedVersion('lsn_wudu_pillars'), equals(1));
    });

    test('Upgrading completed lesson records version 2 explicitly', () {
      var progress = LearningProgress(
        completedLessonVersions: const {'lsn_wudu_pillars': 1},
        updatedAt: DateTime.now().toUtc(),
      );

      final updatedVersions = Map<String, int>.from(progress.completedLessonVersions);
      updatedVersions['lsn_wudu_pillars'] = 2; // Upgraded to v2
      progress = progress.copyWith(completedLessonVersions: updatedVersions);

      expect(progress.isLessonCompleted('lsn_wudu_pillars', 2), isTrue);
      expect(progress.getCompletedVersion('lsn_wudu_pillars'), equals(2));
    });
  });
}
