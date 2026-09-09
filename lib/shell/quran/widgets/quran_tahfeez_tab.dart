import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/memorization/domain/memorization_plan.dart';
import '../../../../modules/memorization/domain/tahfeez_surah_summary.dart';
import '../../../../modules/memorization/memorization_module.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/ayah_key.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../../../modules/quran/services/quran_audio_service.dart';
import '../../memorization/past_memorization_exam_screen.dart';
import '../../memorization/plan_setup_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/state_views.dart';

/// Clean, professional, visual Quran Memorization & Review Hub Tab.
/// Rebuilt from scratch to directly render daily Quran verses, audio repetitions,
/// instant memorization checkmarks, and plan surah progress with zero screen overflow.
class QuranTahfeezTab extends StatefulWidget {
  final QuranModule quranModule;
  final MemorizationModule memorizationModule;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;

  const QuranTahfeezTab({
    super.key,
    required this.quranModule,
    required this.memorizationModule,
    required this.onOpenSurah,
  });

  @override
  State<QuranTahfeezTab> createState() => _QuranTahfeezTabState();
}

class _QuranTahfeezTabState extends State<QuranTahfeezTab> {
  MemorizationPlan? _plan;
  List<Ayah> _todayWirdAyahs = [];
  List<TahfeezSurahSummary> _surahsSummary = [];
  final Set<AyahKey> _memorizedKeys = {};
  final Set<AyahKey> _hiddenAyahKeys = {};

  bool _isLoading = true;
  int? _playingSurah;
  int? _playingAyah;
  int _repeatTimes = 1; // 1, 3, 5, 10
  int _currentRepeatIndex = 1;
  StreamSubscription<AudioPlaybackReport>? _audioSub;

  @override
  void initState() {
    super.initState();
    _loadTahfeezData();
    _listenToAudioPlayback();
  }

  @override
  void dispose() {
    _audioSub?.cancel();
    super.dispose();
  }

  void _listenToAudioPlayback() {
    _audioSub = widget.quranModule.audioService.reportStream.listen((report) {
      if (mounted) {
        setState(() {
          if (report.status == AudioPlaybackStatus.playing) {
            _playingSurah = report.surahNumber;
            _playingAyah = report.ayahNumber;
          } else if (report.status == AudioPlaybackStatus.stopped ||
              report.status == AudioPlaybackStatus.idle ||
              report.status == AudioPlaybackStatus.error) {
            if (_playingSurah != null && _playingAyah != null && _currentRepeatIndex < _repeatTimes) {
              _currentRepeatIndex++;
              widget.quranModule.audioService.playAyah(_playingSurah!, _playingAyah!);
            } else {
              _playingSurah = null;
              _playingAyah = null;
              _currentRepeatIndex = 1;
            }
          }
        });
      }
    });
  }

  Future<void> _loadTahfeezData() async {
    setState(() => _isLoading = true);

    await widget.memorizationModule.initialize();
    final planRes = await widget.memorizationModule.getPlan();
    final plan = planRes.valueOrNull ??
        MemorizationPlan.createDefaultJuzAmma(widget.memorizationModule.clock.nowUtc());

    final wirdRes = await widget.memorizationModule.getTodayWirdAyahs(plan);
    final summaryRes = await widget.memorizationModule.getPlanSurahsSummary(plan);
    final itemsRes = await widget.memorizationModule.getAllItems();

    final memorized = (itemsRes.valueOrNull ?? [])
        .where((i) => i.masteryScore >= 80.0)
        .map((i) => i.ayahKey)
        .toSet();

    if (mounted) {
      setState(() {
        _plan = plan;
        _todayWirdAyahs = wirdRes.valueOrNull ?? [];
        _surahsSummary = summaryRes.valueOrNull ?? [];
        _memorizedKeys
          ..clear()
          ..addAll(memorized);
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAyahMemorized(Ayah ayah) async {
    final isCurrentlyMem = _memorizedKeys.contains(ayah.key);
    final nextState = !isCurrentlyMem;

    setState(() {
      if (nextState) {
        _memorizedKeys.add(ayah.key);
      } else {
        _memorizedKeys.remove(ayah.key);
      }
    });

    await widget.memorizationModule.setAyahMemorizedStatus(ayah.key, nextState);
    final summaryRes = await widget.memorizationModule.getPlanSurahsSummary(_plan!);
    if (mounted && summaryRes.isSuccess) {
      setState(() {
        _surahsSummary = summaryRes.valueOrNull ?? [];
      });
    }
  }

  void _toggleHideAyah(AyahKey key) {
    setState(() {
      if (_hiddenAyahKeys.contains(key)) {
        _hiddenAyahKeys.remove(key);
      } else {
        _hiddenAyahKeys.add(key);
      }
    });
  }

  void _playAyahAudio(Ayah ayah) {
    if (_playingSurah == ayah.surahNumber && _playingAyah == ayah.ayahNumber) {
      widget.quranModule.audioService.stop();
      setState(() {
        _playingSurah = null;
        _playingAyah = null;
        _currentRepeatIndex = 1;
      });
    } else {
      _currentRepeatIndex = 1;
      widget.quranModule.audioService.playAyah(ayah.surahNumber, ayah.ayahNumber);
    }
  }

  void _cycleRepeatMode() {
    setState(() {
      if (_repeatTimes == 1) {
        _repeatTimes = 3;
      } else if (_repeatTimes == 3) {
        _repeatTimes = 5;
      } else if (_repeatTimes == 5) {
        _repeatTimes = 10;
      } else {
        _repeatTimes = 1;
      }
      _currentRepeatIndex = 1;
    });
  }

  void _openPlanSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlanSetupScreen(
          memorizationModule: widget.memorizationModule,
          onSaved: () {
            Navigator.pop(ctx);
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  void _openPastQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PastMemorizationExamScreen(
          memorizationModule: widget.memorizationModule,
          quranModule: widget.quranModule,
          onFinished: () {
            Navigator.pop(context);
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const LoadingStateView();
    }

    final totalAyahsCount = _surahsSummary.fold<int>(0, (sum, s) => sum + s.totalAyahsInPlan);
    final memorizedCount = _surahsSummary.fold<int>(0, (sum, s) => sum + s.memorizedAyahsCount);
    final overallProgress = totalAyahsCount > 0 ? (memorizedCount / totalAyahsCount) * 100 : 0.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: RefreshIndicator(
        onRefresh: _loadTahfeezData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Plan Summary & Hero Card
                  _buildPlanHeroCard(isDark, memorizedCount, totalAyahsCount, overallProgress),
                  const SizedBox(height: AppSpacing.m),

                  // 2. Today's Memorization Workspace Section (الآيات تظهر مباشرة بنصها العثماني)
                  _buildTodayWirdSection(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 3. Plan Surahs Progress List (سور الخطة المقررة)
                  _buildPlanSurahsList(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 4. Past Memorization Testing Card
                  _buildPastQuizCard(isDark),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanHeroCard(bool isDark, int memorized, int total, double progress) {
    final planTitle = _plan?.title ?? 'خطة جزء عمّ';
    final remaining = (total - memorized).clamp(0, total);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          planTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text('تغيير الخطة', style: TextStyle(fontSize: 12)),
                  onPressed: _openPlanSetup,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (progress / 100).clamp(0.0, 1.0),
                minHeight: 9,
                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeroStat('المحفوظ', '$memorized آية', Colors.green),
                Container(width: 1, height: 20, color: Colors.grey.shade300),
                _buildHeroStat('المتبقي', '$remaining آية', AppColors.primary),
                Container(width: 1, height: 20, color: Colors.grey.shade300),
                _buildHeroStat('نسبة الإنجاز', '${progress.toStringAsFixed(1)}%', AppColors.goldAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildTodayWirdSection(bool isDark) {
    final dailyTarget = _plan?.dailyNewAyahs ?? 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: AppColors.goldAccent, size: 18),
                  const SizedBox(width: 4),
                  const Flexible(
                    child: Text(
                      'ورد الحفظ لليوم',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_todayWirdAyahs.length}/$dailyTarget',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: _cycleRepeatMode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.repeat_rounded, size: 13, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      '$_repeatTimes×',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_todayWirdAyahs.isEmpty)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'أتممت جميع آيات الخطة بحمد الله وتوفيقه!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'يمكنك مراجعة الماضي أو اختيار خطة جديدة للبدء في جزء آخر.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todayWirdAyahs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ayah = _todayWirdAyahs[index];
              return _buildAyahCard(ayah, isDark);
            },
          ),
      ],
    );
  }

  Widget _buildAyahCard(Ayah ayah, bool isDark) {
    final surahRes = widget.memorizationModule.quranStore.getSurah(ayah.surahNumber);
    final surahName = surahRes.valueOrNull?.nameArabic ?? 'سورة ${ayah.surahNumber}';
    final isMemorized = _memorizedKeys.contains(ayah.key);
    final isHidden = _hiddenAyahKeys.contains(ayah.key);
    final isPlaying = _playingSurah == ayah.surahNumber && _playingAyah == ayah.ayahNumber;

    return Card(
      elevation: isPlaying ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isPlaying
              ? AppColors.primary
              : (isMemorized ? Colors.green.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2)),
          width: isPlaying ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Ayah Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.primaryLight.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'سورة $surahName — آية ${ayah.ayahNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('ص ${ayah.pageNumber}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => widget.onOpenSurah(ayah.surahNumber, targetPage: ayah.pageNumber, targetAyah: ayah.ayahNumber),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('المصحف', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward_ios_rounded, size: 9, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quranic Text (Uthmani) or Hidden placeholder
            GestureDetector(
              onTap: () => _toggleHideAyah(ayah.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: isHidden
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(Icons.visibility_off_rounded, color: Colors.grey, size: 24),
                              SizedBox(height: 4),
                              Text(
                                'الآية مخفية للتسميع الغيبي — اضغط هنا لإظهارها والتحقق',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        ayah.textUthmani,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 20,
                          height: 2.1,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Bottom Action Bar: [Play/Repeat] + [Hide/Show] + [Memorized Button]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _playAyahAudio(ayah),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: isPlaying ? AppColors.primary : (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isPlaying ? AppColors.primary : Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded, size: 15, color: isPlaying ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                            const SizedBox(width: 4),
                            Text(
                              isPlaying ? '$_currentRepeatIndex/$_repeatTimes' : 'استماع',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPlaying ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      tooltip: isHidden ? 'إظهار الآية' : 'إخفاء للتسميع الغيبي',
                      icon: Icon(isHidden ? Icons.visibility_rounded : Icons.visibility_off_outlined, size: 18),
                      onPressed: () => _toggleHideAyah(ayah.key),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _toggleAyahMemorized(ayah),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isMemorized ? Colors.green : (isDark ? Colors.white10 : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isMemorized ? Colors.green : Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isMemorized ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 15, color: isMemorized ? Colors.white : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          isMemorized ? 'تم حفظها ✅' : 'حفظ الآية',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isMemorized ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSurahsList(bool isDark) {
    if (_surahsSummary.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Icon(Icons.format_list_bulleted_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 6),
            Text('سور الخطة المقررة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _surahsSummary.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = _surahsSummary[index];
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: surah.isCompleted ? Colors.green.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: surah.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.green, size: 18)
                        : Text(
                            '${surah.surahNumber}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                  ),
                ),
                title: Text(
                  'سورة ${surah.surahNameArabic}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (surah.progressPercent / 100).clamp(0.0, 1.0),
                          minHeight: 5,
                          backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(surah.isCompleted ? Colors.green : AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${surah.memorizedAyahsCount}/${surah.totalAyahsInPlan}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                onTap: () => widget.onOpenSurah(surah.surahNumber),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPastQuizCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.4)),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.amber.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology_rounded, color: AppColors.goldAccent, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تسميع واختبار الماضي (لتثبيت المحفوظ)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'امتحن استحضارك للآيات المحفوظة لمنع التفلت وتأكيد التمكين',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _openPastQuiz,
              child: const Text('بدء التسميع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
