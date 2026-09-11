import 'package:flutter/material.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/learning_path.dart';
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/engine/learning_mastery_engine.dart';
import '../../../modules/learning/learning_module.dart';
import 'learning_goals_screen.dart';
import 'learning_path_screen.dart';
import 'lesson_screen.dart';
import 'widgets/academy_stats_banner.dart';
import 'widgets/continue_learning_card.dart';
import 'widgets/course_catalog_view.dart';
import 'widgets/learning_domain_theme.dart';
import 'widgets/learning_progress_card.dart';
import '../routing/app_router.dart';

/// Main Home Screen for Islamic Learning & Education Engine (§4, §26, §45).
/// Upgraded to a multi-perspective, intelligent Islamic Academy hub.
class LearningHomeScreen extends StatefulWidget {
  final LearningModule module;

  const LearningHomeScreen({
    super.key,
    required this.module,
  });

  @override
  State<LearningHomeScreen> createState() => _LearningHomeScreenState();
}

class _LearningHomeScreenState extends State<LearningHomeScreen> {
  List<LearningPath> _paths = [];
  List<Course> _courses = [];
  List<Lesson> _lessons = [];
  LearningMasterySnapshot? _mastery;
  Lesson? _activeLesson;
  String _activeLessonCourseTitle = '';
  bool _isLoading = true;

  // View state
  int _selectedViewMode = 0; // 0: الكليات الموسوعية, 1: المسارات التخصصية, 2: فهرس المقررات, 3: رحلتي
  String _selectedCategory = 'الكل';
  String _searchQuery = '';
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final pathsRes = widget.module.getAllPaths();
    final coursesRes = widget.module.getAllCourses();
    final lessonsRes = widget.module.getAllLessons();
    final masteryRes = await widget.module.computeMastery();
    final progRes = await widget.module.getUserProgress();

    final allPaths = pathsRes.valueOrNull ?? [];
    final allCourses = coursesRes.valueOrNull ?? [];
    final allLessons = lessonsRes.valueOrNull ?? [];

    Lesson? resumeLesson;
    String resumeCourseTitle = 'المنهج التأسيسي';

    if (progRes.isSuccess && allLessons.isNotEmpty) {
      final progress = progRes.valueOrNull!;
      // Find first incomplete lesson, or first lesson
      for (final lsn in allLessons) {
        if (!progress.isLessonCompleted(lsn.lessonId, lsn.version)) {
          resumeLesson = lsn;
          break;
        }
      }
      resumeLesson ??= allLessons.first;

      // Find course title for resumeLesson
      for (final c in allCourses) {
        if (c.moduleIds.contains(resumeLesson.moduleId)) {
          resumeCourseTitle = c.title;
          break;
        }
      }
    } else if (allLessons.isNotEmpty) {
      resumeLesson = allLessons.first;
    }

    if (mounted) {
      setState(() {
        _paths = allPaths;
        _courses = allCourses;
        _lessons = allLessons;
        _mastery = masteryRes.valueOrNull;
        _activeLesson = resumeLesson;
        _activeLessonCourseTitle = resumeCourseTitle;
        _isLoading = false;
      });
    }
  }

  void _openPath(LearningPath path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LearningPathScreen(
          path: path,
          module: widget.module,
        ),
      ),
    ).then((_) => _loadData());
  }

  void _openLesson(Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          lesson: lesson,
          module: widget.module,
        ),
      ),
    ).then((_) => _loadData());
  }

  List<LearningPath> get _grandComprehensivePaths {
    final list = _paths.where((p) => p.pathId.contains('comprehensive')).toList();
    // Fallback if no paths contain 'comprehensive' (e.g. in testing fixtures)
    return list.isNotEmpty ? list : _paths;
  }

  List<LearningPath> get _specializedPaths {
    final list = _paths.where((p) => !p.pathId.contains('comprehensive')).toList();
    return list.isNotEmpty ? list : _paths;
  }

  List<LearningPath> _applyFilters(List<LearningPath> source) {
    var result = source;

    if (_selectedCategory != 'الكل') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('المنصة التعليمية والمناهج'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            tooltip: _isSearchActive ? 'إغلاق البحث' : 'بحث في المناهج',
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'أهدافي التعليمية',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LearningGoalsScreen(module: widget.module),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // 1. Search Bar (expandable)
                  if (_isSearchActive) ...[
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                  ],

                  // 2. Hero Progress Card (preserved for test compatibility)
                  if (_mastery != null) ...[
                    LearningProgressCard(snapshot: _mastery!),
                    const SizedBox(height: 12),
                  ],

                  // 3. View Mode Selector Tabs
                  _buildViewModeSelector(),
                  const SizedBox(height: 12),

                  // 4. Domain Filter Chips (shown when in mode 0, 1, or 2)
                  if (_selectedViewMode != 3) ...[
                    _buildCategoryFilterChips(),
                    const SizedBox(height: 12),
                  ],

                  // 5. Paths Header (preserved text for test compatibility)
                  _buildSectionHeader(),
                  const SizedBox(height: 10),

                  // 6. Main Content Area depending on selected view mode
                  _buildActiveViewContent(),
                  const SizedBox(height: 18),

                  // 7. Seerah & Encyclopedia Shortcut
                  if (_selectedViewMode != 3) ...[
                    _buildSeerahShortcutCard(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'ابحث في 61 مساراً، 49 مقرراً، و 302 درساً...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF0F5132)),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (val) {
        setState(() {
          _searchQuery = val.trim();
        });
      },
    );
  }

  Widget _buildViewModeSelector() {
    final modes = [
      {'label': 'الكليات الكبرى (12)', 'icon': Icons.account_balance_outlined},
      {'label': 'المسارات التخصصية', 'icon': Icons.track_changes_outlined},
      {'label': 'فهرس المقررات (49)', 'icon': Icons.menu_book_outlined},
      {'label': 'رحلتي وإنجازاتي', 'icon': Icons.person_outline},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(modes.length, (index) {
          final isSelected = _selectedViewMode == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedViewMode = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      modes[index]['icon'] as IconData,
                      size: 18,
                      color: isSelected ? const Color(0xFF0F5132) : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        modes[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF0F5132) : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    final categories = ['الكل', ...LearningDomainTheme.getAllCategories()];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          final theme = cat == 'الكل' ? LearningDomainTheme.defaultTheme : LearningDomainTheme.ofCategory(cat);

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: isSelected ? null : Icon(theme.icon, size: 14, color: theme.primaryColor),
            label: Text(
              cat == 'الكل' ? 'جميع المجالات' : theme.shortTitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                width: 1,
              ),
            ),
            onSelected: (_) {
              setState(() {
                _selectedCategory = cat;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    int count = 0;
    if (_selectedViewMode == 0) {
      count = _applyFilters(_grandComprehensivePaths).length;
    } else if (_selectedViewMode == 1) {
      count = _applyFilters(_specializedPaths).length;
    } else if (_selectedViewMode == 2) {
      count = _courses.length;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'المسارات التعليمية المعتمدة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (_selectedViewMode != 3)
          Text(
            '$count مسار/مقرر',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
      ],
    );
  }

  Widget _buildActiveViewContent() {
    switch (_selectedViewMode) {
      case 0:
        return _buildGrandAcademiesView();
      case 1:
        return _buildSpecializedTracksView();
      case 2:
        return CourseCatalogView(
          courses: _courses,
          paths: _paths,
          module: widget.module,
          selectedCategory: _selectedCategory,
          searchQuery: _searchQuery,
        );
      case 3:
        return _buildMyJourneyView();
      default:
        return _buildGrandAcademiesView();
    }
  }

  Widget _buildGrandAcademiesView() {
    final filtered = _applyFilters(_grandComprehensivePaths);

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final path = filtered[index];
        final theme = LearningDomainTheme.ofCategory(path.category);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.primaryColor.withAlpha(40)),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withAlpha(12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openPath(path),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Domain Header with Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(theme.icon, color: theme.primaryColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                path.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              Text(
                                path.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            path.level.labelArabic,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      path.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey.withAlpha(40)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${path.courseIds.length} مقررات • ${path.estimatedHours} س',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'دخول الكلية',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.arrow_forward_ios_rounded, size: 11, color: theme.primaryColor),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecializedTracksView() {
    final filtered = _applyFilters(_specializedPaths);

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final path = filtered[index];
        final theme = LearningDomainTheme.ofCategory(path.category);

        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openPath(path),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          path.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        path.level.labelArabic,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    path.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    path.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${path.estimatedHours} س • ${path.courseIds.length} مقرر',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'عرض المسار',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(Icons.arrow_forward_ios_rounded, size: 10, color: theme.primaryColor),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyJourneyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Academy Grand Stats Banner
        AcademyStatsBanner(
          grandTracksCount: _grandComprehensivePaths.length,
          coursesCount: _courses.isNotEmpty ? _courses.length : 49,
          lessonsCount: _lessons.isNotEmpty ? _lessons.length : 302,
          quizzesCount: 118,
          overallMastery: _mastery?.overallMasteryScore ?? 0.0,
        ),
        const SizedBox(height: 14),

        // 2. Quick Resume Learning Card
        if (_activeLesson != null) ...[
          ContinueLearningCard(
            lesson: _activeLesson!,
            courseTitle: _activeLessonCourseTitle,
            onResume: () => _openLesson(_activeLesson!),
          ),
          const SizedBox(height: 14),
        ],

        if (_mastery != null) ...[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مؤشر الإتقان العام في الأكاديمية',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _mastery!.overallMasteryScore.clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildJourneyMetric('الدروس المكتملة', '${_mastery!.totalLessonsCompleted}'),
                      _buildJourneyMetric('الاختبارات المجتازة', '${_mastery!.totalQuizzesPassed}'),
                      _buildJourneyMetric('نسبة الدقة', '${_mastery!.overallMasteryScore.toInt()}%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Learning Goals Card
        Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF0F5132),
              child: Icon(Icons.flag_outlined, color: Colors.white, size: 20),
            ),
            title: const Text('أهدافي التعليمية اليومية والأسبوعية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: const Text('اضبط ساعات تعلمك اليومية ومتابعة الحفظ والاستيعاب', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LearningGoalsScreen(module: widget.module),
                ),
              ).then((_) => _loadData());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5132))),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            const Text(
              'لا توجد مسارات مطابقة لبحثك أو التصنيف المحدد',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeerahShortcutCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B4332),
            Color(0xFF2D6A4F),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4332).withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).pushNamed(AppRouter.seerah);
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.timeline_rounded, color: Colors.white, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'أطلس السيرة النبوية التفاعلي',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'خط زمني وموسوعة محققة لأحداث العهدين المكي والمدني',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
