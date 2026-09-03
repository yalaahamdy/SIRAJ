import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../store/read_only_learning_store.dart';

/// Provenance-preserving learning search result (§27).
class LearningSearchResult {
  final String id;
  final String title;
  final String snippet;
  final String type; // 'path', 'course', 'lesson'
  final String levelLabel;
  final String authorOrSource;

  const LearningSearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.type,
    required this.levelLabel,
    required this.authorOrSource,
  });
}

/// Service providing Arabic search across learning catalog (§27).
class LearningSearchService {
  final ReadOnlyLearningStore _store;

  const LearningSearchService({required ReadOnlyLearningStore store}) : _store = store;

  static String normalize(String text) {
    var s = text;
    s = s.replaceAll(RegExp(r'[\u064B-\u0652\u0670]'), '');
    s = s.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
    s = s.replaceAll('ة', 'ه');
    s = s.replaceAll('ى', 'ي');
    return s.trim().toLowerCase();
  }

  Result<List<LearningSearchResult>, Failure> search(String query) {
    final cleanQuery = normalize(query);
    if (cleanQuery.isEmpty) return Result.ok(const []);

    final results = <LearningSearchResult>[];

    // 1. Search Paths
    final pathsRes = _store.getAllPaths();
    if (pathsRes.isSuccess) {
      for (final p in pathsRes.valueOrNull!) {
        if (normalize(p.title).contains(cleanQuery) || normalize(p.description).contains(cleanQuery)) {
          results.add(
            LearningSearchResult(
              id: p.pathId,
              title: p.title,
              snippet: p.description,
              type: 'path',
              levelLabel: p.level.labelArabic,
              authorOrSource: p.category,
            ),
          );
        }
      }
    }

    // 2. Search Courses
    final coursesRes = _store.getAllCourses();
    if (coursesRes.isSuccess) {
      for (final c in coursesRes.valueOrNull!) {
        if (normalize(c.title).contains(cleanQuery) || normalize(c.description).contains(cleanQuery)) {
          results.add(
            LearningSearchResult(
              id: c.courseId,
              title: c.title,
              snippet: c.description,
              type: 'course',
              levelLabel: c.level.labelArabic,
              authorOrSource: c.author,
            ),
          );
        }
      }
    }

    // 3. Search Lessons
    final lessonsRes = _store.getAllLessons();
    if (lessonsRes.isSuccess) {
      for (final l in lessonsRes.valueOrNull!) {
        final titleMatch = normalize(l.title).contains(cleanQuery);
        final sectionMatch = l.sections.any((s) => normalize(s.content).contains(cleanQuery));

        if (titleMatch || sectionMatch) {
          final firstSectionContent = l.sections.isNotEmpty ? l.sections.first.content : '';
          final snippet = firstSectionContent.length > 120 ? '${firstSectionContent.substring(0, 120)}...' : firstSectionContent;

          results.add(
            LearningSearchResult(
              id: l.lessonId,
              title: l.title,
              snippet: snippet,
              type: 'lesson',
              levelLabel: 'درس تعليمي (v${l.version})',
              authorOrSource: l.authorOrEditor,
            ),
          );
        }
      }
    }

    return Result.ok(results);
  }
}
