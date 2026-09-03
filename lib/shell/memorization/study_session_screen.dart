import 'package:flutter/material.dart';
import '../../../modules/memorization/domain/review_quality.dart';
import '../../../modules/memorization/domain/review_session.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../../../modules/quran/domain/ayah.dart';
import '../../../modules/quran/domain/ayah_key.dart';
import '../routing/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';
import 'widgets/study_card_view.dart';

/// Screen managing the active study session walkthrough, self-rating flow, and Quran navigation (§10..§15, §37, §88..§91, §120..§122).
class StudySessionScreen extends StatefulWidget {
  final MemorizationModule memorizationModule;
  final VoidCallback onFinish;

  const StudySessionScreen({
    super.key,
    required this.memorizationModule,
    required this.onFinish,
  });

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  ReviewSession? _session;
  List<AyahKey> _sessionQueue = [];
  int _currentIndex = 0;
  Ayah? _currentAyah;
  String _currentSurahName = '';
  bool _isLoading = true;
  bool _isSessionFinished = false;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    setState(() => _isLoading = true);

    final sessionRes = await widget.memorizationModule.getOrCreateTodaySession();
    if (sessionRes.isFailure) {
      setState(() => _isLoading = false);
      return;
    }

    final session = sessionRes.valueOrNull!;
    // Priority Queue: Weak -> Due Reviews -> New Material
    final queue = <AyahKey>[
      ...session.weakAyahs,
      ...session.reviewAyahs,
      ...session.newAyahs,
    ];

    // Determine current index based on already completed results
    final completedCount = session.results.length;

    setState(() {
      _session = session;
      _sessionQueue = queue;
      _currentIndex = completedCount < queue.length ? completedCount : queue.length;
      _isSessionFinished = queue.isEmpty || completedCount >= queue.length;
    });

    if (!_isSessionFinished && queue.isNotEmpty) {
      await _loadCurrentAyah(queue[_currentIndex]);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadCurrentAyah(AyahKey key) async {
    final ayahRes = widget.memorizationModule.quranStore.getAyah(key.surahNumber, key.ayahNumber);
    final surahRes = widget.memorizationModule.quranStore.getSurah(key.surahNumber);

    if (ayahRes.isSuccess && mounted) {
      setState(() {
        _currentAyah = ayahRes.valueOrNull;
        _currentSurahName = surahRes.valueOrNull?.nameArabic ?? '';
      });
    }
  }

  Future<void> _onRateQuality(ReviewQuality quality) async {
    if (_session == null || _currentAyah == null) return;

    final key = _sessionQueue[_currentIndex];
    final updatedSessionRes = await widget.memorizationModule.submitReview(
      session: _session!,
      ayahKey: key,
      quality: quality,
    );

    if (updatedSessionRes.isSuccess && mounted) {
      final updatedSession = updatedSessionRes.valueOrNull!;
      final nextIdx = _currentIndex + 1;

      if (nextIdx >= _sessionQueue.length) {
        setState(() {
          _session = updatedSession;
          _isSessionFinished = true;
        });
      } else {
        setState(() {
          _session = updatedSession;
          _currentIndex = nextIdx;
        });
        await _loadCurrentAyah(_sessionQueue[nextIdx]);
      }
    }
  }

  void _openCurrentAyahInQuran() {
    if (_currentAyah == null) return;
    Navigator.pushNamed(
      context,
      '/quran/${_currentAyah!.surahNumber}:${_currentAyah!.ayahNumber}',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('جلسة الحفظ والمراجعة')),
        body: const LoadingStateView(),
      );
    }

    if (_sessionQueue.isEmpty) {
      return _buildEmptyDayScreen(context);
    }

    if (_isSessionFinished) {
      return _buildSummaryScreen(context);
    }

    final total = _sessionQueue.length;
    final progress = total > 0 ? (_currentIndex + 1) / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('بطاقة ${_currentIndex + 1} من $total'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'إيقاف مؤقت والخروج',
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
          ),
        ),
      ),
      body: _currentAyah != null
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: StudyCardView(
                  ayah: _currentAyah!,
                  surahNameArabic: _currentSurahName,
                  onRate: _onRateQuality,
                  onOpenInQuran: _openCurrentAyahInQuran,
                ),
              ),
            )
          : const EmptyStateView(message: 'تعذر تحميل بيانات الآية'),
    );
  }

  Widget _buildEmptyDayScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جلسة اليوم')),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_available_rounded, size: 72, color: Colors.green),
              const SizedBox(height: AppSpacing.m),
              Text(
                'لا توجد مراجعات مستحقة اليوم',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              const Text(
                'خطة المراجعات اليومية مكتملة أو لم تُضف آيات جديدة بعد.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.memorizationPlan);
                },
                icon: const Icon(Icons.tune_rounded),
                label: const Text('إعداد الخطة وإضافة آيات جديدة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryScreen(BuildContext context) {
    final results = _session?.results ?? [];
    final successCount = results.where((r) => r.isSuccessful).length;
    final lastAyahKey = results.isNotEmpty ? results.last.ayahKey : null;

    return Scaffold(
      appBar: AppBar(title: const Text('اكتملت جلسة اليوم')),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
              const SizedBox(height: AppSpacing.m),
              Text(
                'تم إكمال جلسة الحفظ والمراجعة بنجاح',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'تمت مراجعة واستدعاء ${results.length} آية (بنسبة استدعاء ناجح ${(results.isNotEmpty ? (successCount / results.length * 100).toStringAsFixed(0) : 100)}%)',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                    ),
                    onPressed: widget.onFinish,
                    child: const Text('العودة للوحة التحكم', style: TextStyle(fontSize: 15)),
                  ),
                  if (lastAyahKey != null)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/quran/${lastAyahKey.surahNumber}:${lastAyahKey.ayahNumber}',
                        );
                      },
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text('فتح في المصحف'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
