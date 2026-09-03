import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/storage/storage_contract.dart';
import '../knowledge/knowledge_module.dart';
import 'domain/assessment_result.dart';
import 'domain/canonical_learning_package.dart';
import 'domain/course.dart';
import 'domain/learning_goal.dart';
import 'domain/learning_path.dart';
import 'domain/learning_progress.dart';
import 'domain/lesson.dart';
import 'domain/quiz.dart';
import 'domain/revision_item.dart';
import 'engine/assessment_engine.dart';
import 'engine/curriculum_engine.dart';
import 'engine/learning_mastery_engine.dart';
import 'engine/lesson_engine.dart';
import 'scheduler/learning_revision_scheduler.dart';
import 'search/learning_search_service.dart';
import 'store/learning_user_data_store.dart';
import 'store/read_only_learning_store.dart';

/// Unified Facade for the Islamic Learning & Education subsystem (Layer 2).
class LearningModule {
  final ReadOnlyLearningStore store;
  final CurriculumEngine curriculumEngine;
  final LessonEngine lessonEngine;
  final AssessmentEngine assessmentEngine;
  final LearningMasteryEngine masteryEngine;
  final LearningRevisionScheduler revisionScheduler;
  final LearningSearchService searchService;
  final LearningUserDataStore userDataStore;

  LearningModule({
    required StorageRegistry storageRegistry,
    EventBus? eventBus,
    ReadOnlyLearningStore? learningStore,
    KnowledgeModule? knowledgeModule,
  }) : this._(
          storageRegistry: storageRegistry,
          store: learningStore ?? ReadOnlyLearningStore(eventBus: eventBus),
          knowledgeModule: knowledgeModule,
        );

  LearningModule._({
    required StorageRegistry storageRegistry,
    required this.store,
    KnowledgeModule? knowledgeModule,
  })  : curriculumEngine = CurriculumEngine(store: store),
        lessonEngine = LessonEngine(learningStore: store, knowledgeModule: knowledgeModule),
        assessmentEngine = AssessmentEngine(store: store),
        masteryEngine = LearningMasteryEngine(store: store),
        revisionScheduler = const LearningRevisionScheduler(),
        searchService = LearningSearchService(store: store),
        userDataStore = LearningUserDataStore(storageRegistry: storageRegistry);

  Result<void, Failure> mountPackage(CanonicalLearningPackage package) {
    return store.mountPackage(package);
  }

  Result<List<LearningPath>, Failure> getAllPaths() {
    return store.getAllPaths();
  }

  Result<LearningPath, Failure> getPath(String pathId) {
    return store.getPath(pathId);
  }

  Result<Course, Failure> getCourse(String courseId) {
    return store.getCourse(courseId);
  }

  Result<Lesson, Failure> getLesson(String lessonId) {
    return lessonEngine.getLesson(lessonId);
  }

  Result<Quiz, Failure> getQuizByLesson(String lessonId) {
    return store.getQuizByLesson(lessonId);
  }

  Result<QuizEvaluationReport, Failure> evaluateQuiz({
    required String quizId,
    required Map<String, List<int>> userAnswers,
  }) {
    return assessmentEngine.evaluateQuiz(quizId: quizId, userAnswers: userAnswers);
  }

  Future<Result<void, Failure>> recordAssessmentResult(AssessmentResult result) {
    return userDataStore.recordAssessmentResult(result);
  }

  Future<Result<void, Failure>> markLessonCompleted(String lessonId, int version) {
    return userDataStore.markLessonCompleted(lessonId, version);
  }

  Future<Result<void, Failure>> submitRevision(RevisionItem item, int quality) {
    final updatedItem = revisionScheduler.scheduleNextReview(current: item, quality: quality);
    return userDataStore.addOrUpdateRevisionItem(updatedItem);
  }

  Future<Result<LearningMasterySnapshot, Failure>> computeMastery() async {
    final progRes = await userDataStore.getProgress();
    if (progRes.isFailure) return Result.err(progRes.failureOrNull!);
    return Result.ok(masteryEngine.computeMastery(progRes.valueOrNull!));
  }

  Future<Result<LearningProgress, Failure>> getUserProgress() {
    return userDataStore.getProgress();
  }

  Future<Result<void, Failure>> toggleBookmark(String lessonId) {
    return userDataStore.toggleBookmark(lessonId);
  }

  Future<Result<void, Failure>> saveUserNote(String lessonId, String note) {
    return userDataStore.saveUserNote(lessonId, note);
  }

  Future<Result<void, Failure>> saveGoal(LearningGoal goal) {
    return userDataStore.saveGoal(goal);
  }

  Result<List<LearningSearchResult>, Failure> search(String query) {
    return searchService.search(query);
  }

  Future<Result<void, Failure>> resetAllUserData() {
    return userDataStore.resetAllUserData();
  }
}
