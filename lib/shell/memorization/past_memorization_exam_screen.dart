import 'package:flutter/material.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../../../modules/memorization/services/past_memorization_engine.dart';
import '../../../modules/quran/quran_module.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';

/// Interactive Exam Screen for testing and confirming past memorized Quran portions (§38, §50).
class PastMemorizationExamScreen extends StatefulWidget {
  final MemorizationModule memorizationModule;
  final QuranModule? quranModule;
  final VoidCallback? onFinished;

  const PastMemorizationExamScreen({
    super.key,
    required this.memorizationModule,
    this.quranModule,
    this.onFinished,
  });

  @override
  State<PastMemorizationExamScreen> createState() => _PastMemorizationExamScreenState();
}

class _PastMemorizationExamScreenState extends State<PastMemorizationExamScreen> {
  PastExamQuestion? _currentQuestion;
  PastMasteryStats? _stats;
  bool _isLoading = true;
  bool _isAnswerRevealed = false;
  bool _isAudioPlaying = false;
  bool _isSubmitted = false;
  bool? _lastSubmissionMastered;

  @override
  void initState() {
    super.initState();
    _loadExamData();
  }

  Future<void> _loadExamData() async {
    setState(() {
      _isLoading = true;
      _isAnswerRevealed = false;
      _isSubmitted = false;
      _lastSubmissionMastered = null;
      _isAudioPlaying = false;
    });

    final statsRes = await widget.memorizationModule.getPastMasteryStats();
    final questionRes = await widget.memorizationModule.generatePastExamQuestion(requestedPassageLength: 3);

    if (mounted) {
      setState(() {
        _stats = statsRes.valueOrNull;
        _currentQuestion = questionRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  void _toggleAudio() {
    if (widget.quranModule == null || _currentQuestion == null) return;

    if (_isAudioPlaying) {
      widget.quranModule!.audioService.pause();
      setState(() => _isAudioPlaying = false);
    } else {
      final start = _currentQuestion!.startAyahKey;
      widget.quranModule!.audioService.playRange(
        start.surahNumber,
        start.ayahNumber,
        _currentQuestion!.endAyahKey.ayahNumber,
        repeatCount: 1,
      );
      setState(() => _isAudioPlaying = true);
    }
  }

  Future<void> _submitEvaluation(bool isMastered) async {
    if (_currentQuestion == null) return;

    await widget.memorizationModule.submitPastExamResult(
      question: _currentQuestion!,
      isMastered: isMastered,
    );

    // Refresh stats
    final updatedStatsRes = await widget.memorizationModule.getPastMasteryStats();

    if (mounted) {
      setState(() {
        _isSubmitted = true;
        _lastSubmissionMastered = isMastered;
        _stats = updatedStatsRes.valueOrNull ?? _stats;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMastered
                ? 'مبارك! تم تأكيد حفظ المقطع ورفع درجة تمكينه بنجاح 🌟'
                : 'تم إدراج هذا المقطع في ورد المراجعة القادمة لتثبيته بإذن الله ⚠️',
          ),
          backgroundColor: isMastered ? Colors.green.shade700 : AppColors.warning,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('تسميع واختبار الماضي (تأكيد الحفظ)'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'سؤال آخر من الماضي',
            onPressed: _isLoading ? null : _loadExamData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingStateView()
          : _currentQuestion == null
              ? const Center(child: Text('لا توجد مقاطع متاحة للاختبار حالياً.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Stats Bar
                          _buildStatsHeader(context, isDark),
                          const SizedBox(height: AppSpacing.m),

                          // Exam Card
                          _buildExamQuestionCard(context, isDark),
                          const SizedBox(height: AppSpacing.l),

                          // Action Buttons for Verification
                          if (!_isSubmitted)
                            _buildVerificationActions(context, isDark)
                          else
                            _buildNextQuestionButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, bool isDark) {
    final stats = _stats;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      color: isDark ? AppColors.surfaceDark : AppColors.primaryLight.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('درجة تمكين الماضي', '${stats?.masteryPercentage.toStringAsFixed(0) ?? 100}%', Icons.verified_rounded, Colors.green),
            _buildStatItem('مقاطع متقنة', '${stats?.totalMasteredAyahs ?? 0}', Icons.star_rounded, AppColors.goldAccent),
            _buildStatItem('تحتاج لتثبيت', '${stats?.totalWeakAyahs ?? 0}', Icons.history_rounded, AppColors.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String val, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildExamQuestionCard(BuildContext context, bool isDark) {
    final q = _currentQuestion!;
    final typeLabel = q.type == PastExamQuestionType.surahStart
        ? 'اقرأ من فواتح سورة ${q.surahNameArabic}:'
        : 'أكمل من قوله تعالى في سورة ${q.surahNameArabic} (الآية ${q.startAyahKey.ayahNumber}):';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLarge),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Badge & Instructions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.goldAccent : AppColors.primary).withValues(alpha: 0.15),
                borderRadius: AppRadius.radiusSmall,
              ),
              child: Row(
                children: [
                  Icon(Icons.quiz_rounded, size: 18, color: isDark ? AppColors.goldAccent : AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? AppColors.goldAccent : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),

            // Prompt Ayah Box
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.amber.withValues(alpha: 0.08),
                borderRadius: AppRadius.radiusMedium,
                border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    '﴿ ${q.promptText} ﴾',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'المطلوب: تسميع غيباً إلى الآية ${q.endAyahKey.ayahNumber} (${q.passageLength} آيات)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),

            // Tool actions: Reveal Ayahs & Listen to Sheikh
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: Icon(_isAnswerRevealed ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                  label: Text(_isAnswerRevealed ? 'إخفاء الآيات' : 'كشف الآيات للمقارنة'),
                  onPressed: () {
                    setState(() => _isAnswerRevealed = !_isAnswerRevealed);
                  },
                ),
                if (widget.quranModule != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAudioPlaying ? Colors.red.shade700 : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(_isAudioPlaying ? Icons.pause_rounded : Icons.volume_up_rounded),
                    label: Text(_isAudioPlaying ? 'إيقاف التلاوة' : 'استمع لتلاوة الشيخ'),
                    onPressed: _toggleAudio,
                  ),
              ],
            ),

            // Revealed Passage
            if (_isAnswerRevealed) ...[
              const SizedBox(height: AppSpacing.m),
              const Divider(),
              const SizedBox(height: AppSpacing.s),
              Text(
                'النص القرآني المكتمل للمقطع:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green.shade800),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.06),
                  borderRadius: AppRadius.radiusSmall,
                  border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                ),
                child: Text(
                  q.expectedAyahs.map((a) => '${a.textUthmani} ﴿${a.ayahNumber}﴾').join(' '),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 19,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationActions(BuildContext context, bool isDark) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'قيّم جودة تسميعك لهذا المقطع من الماضي لتحديث مؤشر التمكين:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                  ),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('أتقنت التسميع بنجاح 🌟', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => _submitEvaluation(true),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                  ),
                  icon: const Icon(Icons.history_rounded),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('يحتاج تثبيت ومراجعة ⚠️', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => _submitEvaluation(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextQuestionButton(BuildContext context) {
    final isMastered = _lastSubmissionMastered ?? true;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: (isMastered ? Colors.green : AppColors.warning).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: (isMastered ? Colors.green : AppColors.warning).withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMastered ? Icons.check_circle_rounded : Icons.history_rounded,
                color: isMastered ? Colors.green : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isMastered ? 'تم تسجيل المقطع كمتقن ومثبت 🌟' : 'تمت جدولة المقطع للمراجعة القادمة ⚠️',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMastered ? Colors.green.shade800 : AppColors.warning,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
          ),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('السؤال التالي من الماضي', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          onPressed: _loadExamData,
        ),
      ],
    );
  }
}
