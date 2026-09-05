import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_session.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_word.dart';
import '../../../../modules/quran/recitation/domain/recitation_playback_policy.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_matcher.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_recognition_gateway.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_session_store.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../../../core/audio/siraj_feedback_audio_service.dart';
import '../../theme/app_colors.dart';

/// Interactive View for Mode B: Professional Recitation Recognition (§4, §5, §11, §12).
/// Displays streaming recognized words sequentially, allows single-word manual reveal,
/// automatically advances verses upon completion, and presents an honest session summary.
class RecitationModeBView extends StatefulWidget {
  final QuranRecitationTarget target;
  final List<Ayah> targetAyahs;
  final QuranTypographyConfig config;
  final QuranRecitationRecognitionGateway gateway;
  final QuranRecitationSessionStore sessionStore;
  final VoidCallback onSwitchToModeA;
  final VoidCallback onClose;

  const RecitationModeBView({
    super.key,
    required this.target,
    required this.targetAyahs,
    required this.config,
    required this.gateway,
    required this.sessionStore,
    required this.onSwitchToModeA,
    required this.onClose,
  });

  @override
  State<RecitationModeBView> createState() => _RecitationModeBViewState();
}

class _RecitationModeBViewState extends State<RecitationModeBView> {
  bool _isCheckingAvailability = true;
  bool _isAvailable = false;
  bool _isListening = false;
  bool _isCompleted = false;

  late Map<int, List<QuranRecitationWord>> _ayahWordsMap;
  int _currentAyahIndex = 0;
  int _currentWordIndex = 0;

  DateTime? _sessionStartTime;
  Timer? _sessionTimer;
  int _elapsedSeconds = 0;

  StreamSubscription? _tokenSub;
  StreamSubscription? _listeningSub;

  int _wordsRecognizedCount = 0;
  int _wordsRevealedCount = 0;
  int _wordsUncertainCount = 0;

  @override
  void initState() {
    super.initState();
    _initWordsMap();
    _checkEngineAvailability();
  }

  void _initWordsMap() {
    _ayahWordsMap = {};
    for (final ayah in widget.targetAyahs) {
      _ayahWordsMap[ayah.ayahNumber] = QuranRecitationMatcher.initializeWordsForAyah(ayah);
    }
  }

  Future<void> _checkEngineAvailability() async {
    final available = await widget.gateway.isAvailable();
    if (mounted) {
      setState(() {
        _isAvailable = available;
        _isCheckingAvailability = false;
      });
      if (available) {
        _subscribeToSpeechTokens();
      }
    }
  }

  void _subscribeToSpeechTokens() {
    _listeningSub = widget.gateway.isListeningStream.listen((listening) {
      if (mounted) setState(() => _isListening = listening);
    });

    _tokenSub = widget.gateway.tokenStream.listen((token) {
      if (!mounted || _isCompleted || !_isListening) return;
      _handleSpeechToken(token);
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _tokenSub?.cancel();
    _listeningSub?.cancel();
    widget.gateway.stopListening();
    super.dispose();
  }

  Future<void> _startRecitation() async {
    try {
      _sessionStartTime = DateTime.now();
      _elapsedSeconds = 0;
      _sessionTimer?.cancel();
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _elapsedSeconds++);
      });

      await widget.gateway.startListening();
      setState(() => _isListening = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر تفعيل الميكروفون: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _stopRecitation() async {
    _sessionTimer?.cancel();
    await widget.gateway.stopListening();
    if (mounted) setState(() => _isListening = false);
  }

  void _handleSpeechToken(QuranRecitationToken token) {
    if (_currentAyahIndex >= widget.targetAyahs.length) return;

    final currentAyah = widget.targetAyahs[_currentAyahIndex];
    final words = _ayahWordsMap[currentAyah.ayahNumber]!;

    final result = QuranRecitationMatcher.matchToken(
      words: words,
      currentIndex: _currentWordIndex,
      speechToken: token.normalizedText,
    );

    if (result.isHesitation) {
      // Hesitation absorbed (§10): user repeated previous word, do not fail
      return;
    }

    if (result.isMatch && result.matchedIndex != null) {
      setState(() {
        final idx = result.matchedIndex!;
        words[idx] = words[idx].copyWith(
          state: RecitationWordState.recognized,
          confidence: result.confidence,
          confidenceLevel: result.confidenceLevel,
          recognizedAt: DateTime.now(),
          recognizerToken: result.recognizerToken,
        );
        _wordsRecognizedCount++;
        _currentWordIndex = idx + 1;
      });

      _checkVerseCompletion();
    } else {
      // Uncertain token
      setState(() {
        _wordsUncertainCount++;
      });
    }
  }

  /// Manually reveals only the current single word when user is stuck (§11).
  void _revealCurrentWord() {
    if (_currentAyahIndex >= widget.targetAyahs.length) return;

    final currentAyah = widget.targetAyahs[_currentAyahIndex];
    final words = _ayahWordsMap[currentAyah.ayahNumber]!;

    if (_currentWordIndex < words.length) {
      setState(() {
        words[_currentWordIndex] = words[_currentWordIndex].copyWith(
          state: RecitationWordState.revealed,
          confidenceLevel: RecitationWordConfidence.notRecognized,
        );
        _wordsRevealedCount++;
        _currentWordIndex++;
      });

      _checkVerseCompletion();
    }
  }

  void _checkVerseCompletion() {
    final currentAyah = widget.targetAyahs[_currentAyahIndex];
    final words = _ayahWordsMap[currentAyah.ayahNumber]!;

    // If all words in current Ayah are visible (recognized or revealed)
    if (_currentWordIndex >= words.length) {
      if (_currentAyahIndex + 1 < widget.targetAyahs.length) {
        // Auto advance to next verse (§12)
        SirajFeedbackAudioService.instance.playCompletion();
        setState(() {
          _currentAyahIndex++;
          _currentWordIndex = 0;
        });
      } else {
        // Session complete (§13)
        _finalizeSession();
      }
    }
  }

  Future<void> _finalizeSession() async {
    await _stopRecitation();
    SirajFeedbackAudioService.instance.playSuccess();
    setState(() => _isCompleted = true);

    final totalWords = widget.targetAyahs.fold<int>(
      0,
      (sum, a) => sum + (_ayahWordsMap[a.ayahNumber]?.length ?? 0),
    );

    final session = QuranRecitationSession(
      sessionId: 'recog_${DateTime.now().millisecondsSinceEpoch}',
      surahNumber: widget.target.surahNumber,
      surahNameArabic: widget.target.surahNameArabic,
      startAyah: widget.target.startAyah,
      endAyah: widget.target.endAyah,
      mode: RecitationMode.recognition,
      startedAt: _sessionStartTime ?? DateTime.now(),
      endedAt: DateTime.now(),
      totalWords: totalWords,
      recognizedWordsCount: _wordsRecognizedCount,
      revealedWordsCount: _wordsRevealedCount,
      uncertainWordsCount: _wordsUncertainCount,
      duration: Duration(seconds: _elapsedSeconds),
      status: RecitationSessionStatus.completed,
    );

    await widget.sessionStore.saveLastSession(session);
  }

  String _formatDuration(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF14171A) : const Color(0xFFFAF8F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('${widget.target.formatArabicRange()} (تسميع ذكي)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'إغلاق',
          onPressed: () {
            _stopRecitation();
            widget.onClose();
          },
        ),
      ),
      body: _isCheckingAvailability
          ? const Center(child: CircularProgressIndicator())
          : !_isAvailable
              ? _buildUnavailableFallback(isDark)
              : _isCompleted
                  ? _buildCompletedSummary(isDark)
                  : _buildActiveRecognitionFlow(isDark),
    );
  }

  Widget _buildUnavailableFallback(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_off_rounded, size: 56, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'التعرف على التلاوة غير متاح على هذا الجهاز حالياً',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'حفاظاً على قدسية القرآن وعدم تقديم تقييم غير دقيق، يتطلب التعرف الصوتي توافر محرك تعرف عربي موثوق. يمكنك استخدام وضع التسجيل والاستماع الذاتي المتاح بشكل كامل.',
              style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.mic_rounded),
              label: const Text('التبديل إلى وضع التسجيل الذاتي'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: widget.onSwitchToModeA,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRecognitionFlow(bool isDark) {
    return Column(
      children: [
        // 1. Status bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: _isListening
              ? AppColors.primary.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF1E242C) : const Color(0xFFF0F3F6)),
          child: Row(
            children: [
              Icon(
                _isListening ? Icons.hearing_rounded : Icons.info_outline_rounded,
                size: 18,
                color: _isListening ? AppColors.primary : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isListening
                      ? 'النظام يستمع لتلاوتك... الكلمات تظهر تباعاً فور نطقها.'
                      : 'اضغط "ابدأ التسميع" ثم اقرأ بهدوء وترتيل.',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              if (_isListening)
                Text(
                  _formatDuration(_elapsedSeconds),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
            ],
          ),
        ),

        // 2. Continuous flow with word states
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _buildVersesFlow(isDark),
          ),
        ),

        // 3. Action bar with Reveal Single Word and Start/Stop
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E232B) : Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Reveal Single Word Button (§11)
                OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('إظهار الكلمة', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.goldAccent,
                    side: const BorderSide(color: AppColors.goldAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isListening ? _revealCurrentWord : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded),
                    label: Text(
                      _isListening ? 'إيقاف التسميع' : 'ابدأ التسميع',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening ? Colors.red : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isListening ? _stopRecitation : _startRecitation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersesFlow(bool isDark) {
    final quranStyle = widget.config.buildQuranTextStyle();
    final spans = <InlineSpan>[];

    for (int i = 0; i < widget.targetAyahs.length; i++) {
      final ayah = widget.targetAyahs[i];
      final words = _ayahWordsMap[ayah.ayahNumber] ?? [];

      for (final word in words) {
        if (word.isVisible) {
          // Recognized or revealed word
          final isRevealed = word.state == RecitationWordState.revealed;
          spans.add(
            TextSpan(
              text: '${word.canonicalText} ',
              style: quranStyle.copyWith(
                color: isRevealed
                    ? AppColors.goldAccent
                    : (isDark ? Colors.white : Colors.black),
                backgroundColor: isRevealed
                    ? AppColors.goldAccent.withValues(alpha: 0.15)
                    : null,
              ),
            ),
          );
        } else {
          // Hidden word: accessible veil
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Semantics(
                label: 'كلمة مخفية',
                excludeSemantics: true,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C323D) : const Color(0xFFE2E0D8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '••••',
                    style: TextStyle(fontSize: 12, color: Colors.transparent),
                  ),
                ),
              ),
            ),
          );
        }
      }

      // Ayah Marker ﴿١﴾
      spans.add(
        TextSpan(
          text: ' ﴿${ayah.ayahNumber}﴾ ',
          style: widget.config.buildAyahMarkerStyle(),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildCompletedSummary(bool isDark) {
    final totalWords = widget.targetAyahs.fold<int>(
      0,
      (sum, a) => sum + (_ayahWordsMap[a.ayahNumber]?.length ?? 0),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'اكتملت جلسة التسميع',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.target.formatArabicRange(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Objective metric overview (§13: NO religious/piety scores)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E232B) : const Color(0xFFF6F5F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  _buildMetricRow('إجمالي كلمات الموضع', '$totalWords'),
                  const Divider(height: 16),
                  _buildMetricRow('الكلمات المتعرف عليها', '$_wordsRecognizedCount', color: AppColors.primary),
                  const Divider(height: 16),
                  _buildMetricRow('الكلمات المستكشفة بزر المساعدة', '$_wordsRevealedCount', color: AppColors.goldAccent),
                  const Divider(height: 16),
                  _buildMetricRow('مدة التلاوة المستغرقة', _formatDuration(_elapsedSeconds)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onClose,
                child: const Text('إنهاء والعودة للمصحف', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
