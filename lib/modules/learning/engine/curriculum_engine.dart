import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/course.dart';
import '../domain/course_module.dart';
import '../domain/learning_progress.dart';
import '../domain/lesson.dart';
import '../store/read_only_learning_store.dart';

/// Engine responsible for pedagogical ordering, prerequisite resolution, and DAG cycle prevention (§37, §38, §39).
class CurriculumEngine {
  final ReadOnlyLearningStore _store;

  const CurriculumEngine({required ReadOnlyLearningStore store}) : _store = store;

  /// Verifies that there are NO circular dependencies among modules in the entire curriculum.
  Result<bool, Failure> validateCurriculumDAG() {
    final coursesRes = _store.getAllCourses();
    if (coursesRes.isFailure) return Result.ok(true);

    final courses = coursesRes.valueOrNull!;
    for (final course in courses) {
      final visited = <String>{};
      final recStack = <String>{};

      for (final modId in course.moduleIds) {
        if (_hasCycle(modId, visited, recStack)) {
          return Result.err(
            ConfigFailure(message: 'Circular prerequisite dependency detected in module: $modId'),
          );
        }
      }
    }
    return Result.ok(true);
  }

  bool _hasCycle(String moduleId, Set<String> visited, Set<String> recStack) {
    if (recStack.contains(moduleId)) return true;
    if (visited.contains(moduleId)) return false;

    visited.add(moduleId);
    recStack.add(moduleId);

    final modRes = _store.getModule(moduleId);
    if (modRes.isSuccess) {
      final mod = modRes.valueOrNull!;
      for (final prereqId in mod.prerequisiteModuleIds) {
        if (_hasCycle(prereqId, visited, recStack)) return true;
      }
    }

    recStack.remove(moduleId);
    return false;
  }

  /// Determines if a specific module is unlocked for the user based on prerequisite module completions.
  bool isModuleUnlocked(CourseModule module, LearningProgress progress) {
    if (module.prerequisiteModuleIds.isEmpty) return true;

    for (final prereqId in module.prerequisiteModuleIds) {
      final prereqRes = _store.getModule(prereqId);
      if (prereqRes.isFailure) return false;
      final prereqMod = prereqRes.valueOrNull!;

      // All lessons in prerequisite module must be completed
      for (final lsnId in prereqMod.lessonIds) {
        if (!progress.isLessonCompleted(lsnId)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Finds the next uncompleted lesson in the pedagogical sequence for a given course.
  Result<Lesson?, Failure> getNextLessonInCourse(String courseId, LearningProgress progress) {
    final courseRes = _store.getCourse(courseId);
    if (courseRes.isFailure) return Result.err(courseRes.failureOrNull!);

    final course = courseRes.valueOrNull!;
    for (final modId in course.moduleIds) {
      final modRes = _store.getModule(modId);
      if (modRes.isFailure) continue;
      final mod = modRes.valueOrNull!;

      if (!isModuleUnlocked(mod, progress)) continue;

      for (final lsnId in mod.lessonIds) {
        if (!progress.isLessonCompleted(lsnId)) {
          final lsnRes = _store.getLesson(lsnId);
          if (lsnRes.isSuccess) return Result.ok(lsnRes.valueOrNull);
        }
      }
    }
    return Result.ok(null); // Course fully completed
  }

  /// Computes completion percentage for a course.
  double getCourseProgressPercentage(Course course, LearningProgress progress) {
    int totalLessons = 0;
    int completedLessons = 0;

    for (final modId in course.moduleIds) {
      final modRes = _store.getModule(modId);
      if (modRes.isFailure) continue;
      final mod = modRes.valueOrNull!;
      for (final lsnId in mod.lessonIds) {
        totalLessons++;
        if (progress.isLessonCompleted(lsnId)) {
          completedLessons++;
        }
      }
    }

    if (totalLessons == 0) return 0.0;
    return (completedLessons / totalLessons) * 100.0;
  }
}
