import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../domain/canonical_learning_package.dart';
import '../domain/course.dart';
import '../domain/course_module.dart';
import '../domain/learning_path.dart';
import '../domain/lesson.dart';
import '../domain/quiz.dart';

/// Read-only in-memory canonical learning repository with Fail-Closed security (§33, §34).
class ReadOnlyLearningStore {
  CanonicalLearningPackage? _activePackage;

  final Map<String, LearningPath> _pathsById = {};
  final Map<String, Course> _coursesById = {};
  final Map<String, CourseModule> _modulesById = {};
  final Map<String, Lesson> _lessonsById = {};
  final Map<String, List<Lesson>> _lessonsByModule = {};
  final Map<String, Quiz> _quizzesById = {};
  final Map<String, Quiz> _quizzesByLesson = {};

  final EventBus? _eventBus;

  ReadOnlyLearningStore({EventBus? eventBus}) : _eventBus = eventBus;

  CanonicalLearningPackage? get activePackage => _activePackage;
  bool get isMounted => _activePackage != null;

  /// Mounts a new [CanonicalLearningPackage] with strict cryptographic validation.
  Result<void, Failure> mountPackage(CanonicalLearningPackage package) {
    if (!package.verifyPackageIntegrity()) {
      _eventBus?.publish(
        PackageRejectedEvent(
          packageId: package.packageId,
          reason: 'Cryptographic integrity verification failed for Learning Package',
        ),
      );
      return Result.err(
        const ContentIntegrityFailure(message: 'Learning package verification failed: Hash mismatch or untrusted signature'),
      );
    }

    _pathsById.clear();
    _coursesById.clear();
    _modulesById.clear();
    _lessonsById.clear();
    _lessonsByModule.clear();
    _quizzesById.clear();
    _quizzesByLesson.clear();

    for (final p in package.paths) {
      _pathsById[p.pathId] = p;
    }

    for (final c in package.courses) {
      _coursesById[c.courseId] = c;
    }

    for (final m in package.modules) {
      _modulesById[m.moduleId] = m;
    }

    for (final l in package.lessons) {
      _lessonsById[l.lessonId] = l;
      _lessonsByModule.putIfAbsent(l.moduleId, () => []).add(l);
    }

    for (final q in package.quizzes) {
      _quizzesById[q.quizId] = q;
      _quizzesByLesson[q.lessonId] = q;
    }

    _activePackage = package;
    return Result.ok(null);
  }

  Result<LearningPath, Failure> getPath(String pathId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _pathsById[pathId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Learning path not found: $pathId'));
    return Result.ok(item);
  }

  Result<List<LearningPath>, Failure> getAllPaths() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_pathsById.values.toList());
  }

  Result<Course, Failure> getCourse(String courseId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _coursesById[courseId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Course not found: $courseId'));
    return Result.ok(item);
  }

  Result<List<Course>, Failure> getAllCourses() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_coursesById.values.toList());
  }

  Result<CourseModule, Failure> getModule(String moduleId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _modulesById[moduleId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Module not found: $moduleId'));
    return Result.ok(item);
  }

  Result<Lesson, Failure> getLesson(String lessonId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _lessonsById[lessonId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Lesson not found: $lessonId'));
    return Result.ok(item);
  }

  Result<List<Lesson>, Failure> getAllLessons() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_lessonsById.values.toList());
  }

  Result<List<Lesson>, Failure> getLessonsByModule(String moduleId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_lessonsByModule[moduleId] ?? const []);
  }

  Result<Quiz, Failure> getQuiz(String quizId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _quizzesById[quizId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Quiz not found: $quizId'));
    return Result.ok(item);
  }

  Result<Quiz, Failure> getQuizByLesson(String lessonId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _quizzesByLesson[lessonId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'No quiz for lesson: $lessonId'));
    return Result.ok(item);
  }

  bool verifyIntegrity() {
    if (_activePackage == null) return false;
    return _activePackage!.verifyPackageIntegrity();
  }
}
