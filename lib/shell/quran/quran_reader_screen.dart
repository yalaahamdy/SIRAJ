import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../modules/quran/domain/ayah.dart';
import '../../modules/quran/domain/ayah_key.dart';
import '../../modules/quran/domain/quran_reader_modes.dart';
import '../../modules/quran/domain/quran_reciter.dart';
import '../../modules/quran/domain/surah.dart';
import '../../modules/quran/quran_module.dart';
import '../../modules/quran/services/quran_audio_service.dart';
import '../../modules/quran/services/quran_typography_service.dart';
import '../../modules/quran/store/canonical_quran_loader.dart';
import '../routing/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'controllers/ayah_selection_controller.dart';
import 'controllers/quran_reader_settings_controller.dart';
import 'widgets/ayah_action_bottom_sheet.dart';
import 'widgets/ayah_action_toolbar.dart';
import 'widgets/ayah_view.dart';
import 'widgets/quran_mini_player.dart';
import 'widgets/quran_mushaf_flow_view.dart';
import 'widgets/quran_mushaf_page_view.dart';
import 'widgets/range_selection_dialog.dart';
import 'widgets/reader_settings_sheet.dart';
import 'widgets/surah_header_card.dart';
import 'widgets/tafsir_bottom_sheet.dart';
import 'widgets/word_by_word_sheet.dart';
import '../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../modules/quran/recitation/domain/quran_recitation_word.dart';
import '../../modules/quran/recitation/domain/quran_recitation_session.dart';
import '../../modules/quran/recitation/domain/recitation_playback_policy.dart';
import '../../modules/quran/recitation/services/quran_recitation_recognition_gateway.dart';
import '../../modules/quran/recitation/services/quran_recitation_recorder.dart';
import '../../modules/quran/recitation/services/quran_recitation_matcher.dart';
import 'recitation/recitation_hub_sheet.dart';

/// Professional, distraction-free Quran Reader Screen (§1, §4, §10, §17).
/// Implements content-first reading, continuous inline Mushaf flow,
/// floating mini-controls, and persistent single-source-of-truth settings.
class QuranReaderScreen extends StatefulWidget {
  final QuranModule quranModule;
  final int initialSurahNumber;
  final int? initialAyahNumber;
  final int? initialPageNumber;
  final QuranRecitationRecorder? recorder;
  final QuranRecitationRecognitionGateway? recognitionGateway;

  const QuranReaderScreen({
    super.key,
    required this.quranModule,
    this.initialSurahNumber = 1,
    this.initialAyahNumber,
    this.initialPageNumber,
    this.recorder,
    this.recognitionGateway,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  late int _currentSurahNumber;
  int? _targetAyahNumber;
  Surah? _currentSurah;
  List<Ayah> _ayahs = [];
  Set<int> _bookmarkedAyahs = {};
  bool _isLoading = true;
  String? _errorMessage;

  late final QuranReaderSettingsController _settingsController;
  bool _isDistractionFree = false;

  Map<String, String> _translations = {};
  Map<String, dynamic> _tajweedRules = {};

  final AyahSelectionController _selectionController = AyahSelectionController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int? _lastScrolledAudioAyah;

  AudioPlaybackReport _audioReport = const AudioPlaybackReport(
    status: AudioPlaybackStatus.idle,
  );
  StreamSubscription<AudioPlaybackReport>? _audioSub;

  // In-Place Recitation Subsystem State (§M02.2)
  QuranRecitationTarget? _activeRecitationTarget;
  RecitationMode? _activeRecitationMode;
  bool _isRecitationActive = false;
  bool _isRecitationRecording = false; // Mode A recording: veils text in Mushaf
  bool _isRecitationCompleted = false; // Mode A stopped: reveals text immediately
  String? _recitationAudioPath;
  int _recitationSeconds = 0;
  Timer? _recitationTimer;
  Map<int, List<QuranRecitationWord>>? _recitationWordsMap;
  int _recitationCurrentAyahNumber = 1;
  int _recitationCurrentWordIndex = 0;
  late final QuranRecitationRecorder _recitationRecorder;
  late final QuranRecitationRecognitionGateway _recitationGateway;
  StreamSubscription<QuranRecitationToken>? _recitationTokenSub;

  // Recitation Audio Playback & Review State (§M02.2)
  AudioPlayer? _recitationAudioPlayer;
  bool _isRecitationAudioPlaying = false;
  Duration _recitationPlaybackPosition = Duration.zero;
  Duration _recitationPlaybackDuration = Duration.zero;
  StreamSubscription? _recitationAudioPosSub;
  StreamSubscription? _recitationAudioDurSub;
  StreamSubscription? _recitationAudioStateSub;

  // Recitation Pronunciation Mistakes State (§M02.2)
  int _recitationMistakesCount = 0;
  String? _recitationMistakeNotice;
  Timer? _recitationMistakeNoticeTimer;

  // Active Multi-Language Translation State (§13)
  String _currentLoadedTranslationLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _currentSurahNumber = widget.initialSurahNumber;
    _targetAyahNumber = widget.initialAyahNumber;

    _recitationRecorder = widget.recorder ?? QuranRecitationRecorder();
    _recitationGateway = widget.recognitionGateway ?? FastConformerQuranRecognitionGateway();

    _settingsController = QuranReaderSettingsController(
      store: widget.quranModule.userDataService.store,
    );
    // Sync reciter and playback speed from persistent settings to audio service
    final initialReciter = kAvailableReciters.firstWhere(
      (r) => r.nameArabic == _settingsController.state.reciter,
      orElse: () => kDefaultAbdulBasitReciter,
    );
    widget.quranModule.audioService.setReciter(initialReciter);
    if ((_settingsController.state.playbackSpeed - 1.0).abs() > 0.01) {
      widget.quranModule.audioService.setPlaybackSpeed(_settingsController.state.playbackSpeed);
    }

    _settingsController.addListener(() {
      if (mounted) {
        if (_translations.isEmpty ||
            _currentLoadedTranslationLanguage != _settingsController.state.translationLanguage) {
          _loadAuxiliaryData(languageCode: _settingsController.state.translationLanguage);
        }
        setState(() {});
      }
    });

    _loadSurahData();
    _loadAuxiliaryData();

    _audioSub = widget.quranModule.audioService.reportStream.listen((report) {
      if (mounted) {
        setState(() => _audioReport = report);
        if (_settingsController.state.autoScroll &&
            report.status == AudioPlaybackStatus.playing &&
            report.surahNumber == _currentSurahNumber &&
            report.ayahNumber != null &&
            report.ayahNumber != _lastScrolledAudioAyah) {
          _lastScrolledAudioAyah = report.ayahNumber;
          _scrollToAyah(report.ayahNumber!);
        } else if (report.status != AudioPlaybackStatus.playing) {
          _lastScrolledAudioAyah = null;
        }
      }
    });

    _selectionController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _loadAuxiliaryData({String? languageCode}) {
    final lang = languageCode ?? _settingsController.state.translationLanguage;
    _currentLoadedTranslationLanguage = lang;

    try {
      _translations = CanonicalQuranLoader.loadTranslationsSync(languageCode: lang);
      _tajweedRules = CanonicalQuranLoader.loadTajweedRulesSync();
    } catch (_) {}

    if (_translations.isEmpty) {
      CanonicalQuranLoader.loadTranslations(languageCode: lang).then((trans) {
        if (mounted && trans.isNotEmpty) {
          setState(() {
            _translations = trans;
          });
        }
      });
    }

    if (_tajweedRules.isEmpty) {
      CanonicalQuranLoader.loadTajweedRules().then((rules) {
        if (mounted && rules.isNotEmpty) {
          setState(() {
            _tajweedRules = rules;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(QuranReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSurahNumber != widget.initialSurahNumber) {
      _currentSurahNumber = widget.initialSurahNumber;
      _targetAyahNumber = widget.initialAyahNumber;
      _selectionController.clearSelection();
      _loadSurahData();
    }
  }

  @override
  void dispose() {
    _recitationTimer?.cancel();
    _recitationTokenSub?.cancel();
    _disposeRecitationAudioPlayer();
    _recitationMistakeNoticeTimer?.cancel();
    _audioSub?.cancel();
    _selectionController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _settingsController.dispose();
    _recitationRecorder.dispose();
    _recitationGateway.dispose();
    super.dispose();
  }

  Future<void> _loadSurahData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final surahRes = widget.quranModule.getSurah(_currentSurahNumber);
    final ayahsRes = widget.quranModule.getSurahAyahs(_currentSurahNumber);
    final bookmarksRes = await widget.quranModule.getBookmarks();

    if (surahRes.isFailure || ayahsRes.isFailure) {
      setState(() {
        _isLoading = false;
        _errorMessage = surahRes.failureOrNull?.message ??
            ayahsRes.failureOrNull?.message ??
            'خطأ في تحميل بيانات السورة';
      });
      return;
    }

    final surah = surahRes.valueOrNull!;
    final ayahs = ayahsRes.valueOrNull!;
    final bookmarks = bookmarksRes.valueOrNull ?? [];

    final bookmarkedSet = bookmarks
        .where((b) => b.surahNumber == _currentSurahNumber)
        .map((b) => b.ayahNumber)
        .toSet();

    setState(() {
      _currentSurah = surah;
      _ayahs = ayahs;
      _bookmarkedAyahs = bookmarkedSet;
      _isLoading = false;
    });

    if (ayahs.isNotEmpty) {
      final targetIndex = _targetAyahNumber != null
          ? (_targetAyahNumber! - 1).clamp(0, ayahs.length - 1)
          : 0;
      final targetAyah = ayahs[targetIndex];

      widget.quranModule.updateReadingPosition(
        surahNumber: surah.number,
        ayahNumber: targetAyah.ayahNumber,
        pageNumber: targetAyah.pageNumber,
        surahNameArabic: surah.nameArabic,
      );

      if (_targetAyahNumber != null) {
        final ayahToScroll = targetIndex + 1;
        _targetAyahNumber = null; // Clear to prevent unexpected jumping on rebuilds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToAyah(ayahToScroll);
        });
      }
    }
  }

  void _scrollToAyah(int ayahNumber) {
    if (_ayahs.isEmpty) return;
    final index = ayahNumber.clamp(1, _ayahs.length);

    // If in horizontal Mushaf page view mode, flip to the page containing this Ayah
    if (_settingsController.state.pageTurnMode == QuranPageTurnMode.horizontal) {
      if (_pageController.hasClients) {
        final targetAyah = _ayahs[index - 1];
        final pages = _ayahs.map((a) => a.pageNumber).toSet().toList()..sort();
        final pageIdx = pages.indexOf(targetAyah.pageNumber);
        if (pageIdx != -1) {
          _pageController.animateToPage(
            pageIdx,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      }
      return;
    }

    if (!_scrollController.hasClients) return;
    final estimatedOffset = ((index - 1) * 75.0)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      estimatedOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _toggleBookmark(Ayah ayah) async {
    final isBookmarked = _bookmarkedAyahs.contains(ayah.ayahNumber);

    if (isBookmarked) {
      final bookmarksRes = await widget.quranModule.getBookmarks();
      final target = bookmarksRes.valueOrNull?.firstWhere(
        (b) => b.surahNumber == ayah.surahNumber && b.ayahNumber == ayah.ayahNumber,
      );
      if (target != null) {
        await widget.quranModule.deleteBookmark(target.id);
        setState(() {
          _bookmarkedAyahs.remove(ayah.ayahNumber);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إزالة الفاصل المرجعي')),
          );
        }
      }
    } else {
      await widget.quranModule.addBookmark(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        pageNumber: ayah.pageNumber,
        surahNameArabic: _currentSurah?.nameArabic ?? '',
        ayahSnippet: ayah.textUthmani,
      );
      setState(() {
        _bookmarkedAyahs.add(ayah.ayahNumber);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حفظ فاصل عند الآية ${ayah.ayahNumber} من سورة ${_currentSurah?.nameArabic}',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  void _onAyahSingleTap(Ayah ayah) {
    if (_settingsController.state.readerMode == QuranReaderMode.focus || _isDistractionFree) {
      _settingsController.updateConfig(
        _settingsController.state.copyWith(readerMode: QuranReaderMode.mushaf),
      );
      setState(() => _isDistractionFree = false);
      return;
    }
    if (_selectionController.isAyahSelected(ayah.ayahNumber)) {
      _selectionController.clearSelection();
    } else {
      _selectionController.selectAyah(_currentSurahNumber, ayah.ayahNumber);
    }
  }

  void _onAyahDoubleTap(Ayah ayah) {
    final isPlayingThis = _audioReport.status == AudioPlaybackStatus.playing &&
        _audioReport.surahNumber == _currentSurahNumber &&
        _audioReport.ayahNumber == ayah.ayahNumber;

    if (isPlayingThis) {
      widget.quranModule.audioService.pause();
    } else {
      widget.quranModule.audioService.playAyah(_currentSurahNumber, ayah.ayahNumber);
    }
  }

  void _onAyahLongPress(Ayah ayah) {
    _selectionController.selectAyah(_currentSurahNumber, ayah.ayahNumber);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AyahActionBottomSheet(
        ayah: ayah,
        surah: _currentSurah!,
        isBookmarked: _bookmarkedAyahs.contains(ayah.ayahNumber),
        onToggleBookmark: () => _toggleBookmark(ayah),
        onMemorize: () => _onMemorizeAyah(ayah),
        onPlay: () {
          widget.quranModule.audioService.playAyah(_currentSurahNumber, ayah.ayahNumber);
        },
        onTafsir: () => _openTafsirSheet(ayah.ayahNumber),
        onSelectRange: () => _showRangeDialog(ayah.ayahNumber),
        onWordByWord: () => _openWordByWordSheet(ayah),
      ),
    );
  }

  void _openTafsirSheet(int ayahNumber) {
    if (_currentSurah == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TafsirBottomSheet(
        surahNumber: _currentSurahNumber,
        surahNameArabic: _currentSurah!.nameArabic,
        initialAyahNumber: ayahNumber,
        totalAyahsInSurah: _ayahs.length,
        tafsirService: widget.quranModule.tafsirService,
        ayahLookup: (aNum) => _ayahs[aNum - 1],
      ),
    );
  }

  void _openWordByWordSheet(Ayah ayah) {
    if (_currentSurah == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WordByWordSheet(
        ayah: ayah,
        surahNameArabic: _currentSurah!.nameArabic,
        words: const [],
        onPlayAyah: () {
          widget.quranModule.audioService.playAyah(_currentSurahNumber, ayah.ayahNumber);
        },
      ),
    );
  }

  void _showRangeDialog(int initialAyah) {
    if (_currentSurah == null) return;
    showDialog(
      context: context,
      builder: (ctx) => RangeSelectionDialog(
        surahNumber: _currentSurahNumber,
        surahNameArabic: _currentSurah!.nameArabic,
        initialAyah: initialAyah,
        totalAyahs: _ayahs.length,
        onSelectRange: (start, end) {
          _selectionController.selectRange(_currentSurahNumber, start, end);
        },
        onPlayRange: (start, end) {
          widget.quranModule.audioService.playRange(
            _currentSurahNumber,
            start,
            end,
            repeatCount: 1,
          );
        },
      ),
    );
  }

  void _copySelectedText() {
    if (_currentSurah == null || _ayahs.isEmpty) return;
    final selectedSet = _selectionController.selectedAyahs;
    if (selectedSet.isEmpty) return;

    final sorted = selectedSet.toList()..sort();
    final buffer = StringBuffer();
    for (final aNum in sorted) {
      if (aNum >= 1 && aNum <= _ayahs.length) {
        buffer.writeln(_ayahs[aNum - 1].textUthmani);
      }
    }
    final rangeText = sorted.length > 1
        ? '${sorted.first}-${sorted.last}'
        : '${sorted.first}';
    buffer.write('[سورة ${_currentSurah!.nameArabic}: الآية $rangeText]');

    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ النص القرآني مع التوثيق الكنسي'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareSelectedText() {
    if (_currentSurah == null || _ayahs.isEmpty) return;
    final selectedSet = _selectionController.selectedAyahs;
    if (selectedSet.isEmpty) return;

    final sorted = selectedSet.toList()..sort();
    final buffer = StringBuffer('قال تعالى:\n');
    for (final aNum in sorted) {
      if (aNum >= 1 && aNum <= _ayahs.length) {
        buffer.writeln('"${_ayahs[aNum - 1].textUthmani}"');
      }
    }
    final rangeText = sorted.length > 1
        ? '${sorted.first}-${sorted.last}'
        : '${sorted.first}';
    buffer.write('— [سورة ${_currentSurah!.nameArabic}: الآية $rangeText] (تطبيق سراج)');

    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تجهيز نص الآيات للمشاركة مع الإسناد'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _onMemorizeAyah(Ayah ayah) {
    Navigator.pushNamed(
      context,
      AppRouter.memorizationPlan,
      arguments: {
        'target_ayah_key': AyahKey(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
        ),
      },
    );
  }

  void _openReaderSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReaderSettingsSheet(
        config: _settingsController.state,
        onConfigChanged: (newConfig) {
          final oldLang = _settingsController.state.translationLanguage;
          final oldReciter = _settingsController.state.reciter;
          final oldSpeed = _settingsController.state.playbackSpeed;

          _settingsController.updateConfig(newConfig);

          if (oldLang != newConfig.translationLanguage) {
            _loadAuxiliaryData(languageCode: newConfig.translationLanguage);
          }
          if (oldReciter != newConfig.reciter) {
            final target = kAvailableReciters.firstWhere(
              (r) => r.nameArabic == newConfig.reciter,
              orElse: () => kDefaultAbdulBasitReciter,
            );
            widget.quranModule.audioService.setReciter(target);
          }
          if ((oldSpeed - newConfig.playbackSpeed).abs() > 0.01) {
            widget.quranModule.audioService.setPlaybackSpeed(newConfig.playbackSpeed);
          }

          setState(() {
            _isDistractionFree = newConfig.readerMode == QuranReaderMode.focus;
          });
        },
      ),
    );
  }

  void _showJumpToAyahDialog() {
    if (_currentSurah == null || _ayahs.isEmpty) return;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('الانتقال إلى آية في سورة ${_currentSurah!.nameArabic}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أدخل رقم الآية (1 حتى ${_currentSurah!.ayahCount}):',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'رقم الآية',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val >= 1 && val <= _ayahs.length) {
                Navigator.pop(ctx);
                setState(() => _targetAyahNumber = val);
                _scrollToAyah(val);
                final targetAyah = _ayahs[val - 1];
                widget.quranModule.updateReadingPosition(
                  surahNumber: _currentSurah!.number,
                  ayahNumber: targetAyah.ayahNumber,
                  pageNumber: targetAyah.pageNumber,
                  surahNameArabic: _currentSurah!.nameArabic,
                );
              }
            },
            child: const Text('انتقال'),
          ),
        ],
      ),
    );
  }

  void _openRecitationHub() {
    if (_currentSurah == null || _ayahs.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecitationHubSheet(
        surah: _currentSurah!,
        totalAyahs: _ayahs.length,
        currentAyahNumber: _targetAyahNumber ?? 1,
        sessionStore: widget.quranModule.recitationSessionStore,
        onStartRecitation: (target, mode) {
          _startInPlaceRecitation(target, mode);
        },
      ),
    );
  }

  Future<void> _startInPlaceRecitation(
    QuranRecitationTarget target,
    RecitationMode mode,
  ) async {
    _recitationTimer?.cancel();
    _recitationTokenSub?.cancel();

    setState(() {
      _activeRecitationTarget = target;
      _activeRecitationMode = mode;
      _isRecitationActive = true;
      _recitationSeconds = 0;
      _recitationAudioPath = null;
      _recitationMistakesCount = 0;
      _recitationMistakeNotice = null;
    });

    _disposeRecitationAudioPlayer();
    _recitationMistakeNoticeTimer?.cancel();
    _scrollToAyah(target.startAyah);

    if (mode == RecitationMode.recordAndReplay) {
      setState(() {
        _isRecitationRecording = true;
        _isRecitationCompleted = false;
        _recitationWordsMap = null;
      });

      await _recitationRecorder.startRecording(
        surahNumber: _currentSurahNumber,
        startAyah: target.startAyah,
        endAyah: target.endAyah,
      );

      _recitationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted && _isRecitationRecording) {
          setState(() {
            _recitationSeconds++;
          });
        }
      });
    } else {
      // Mode B: FastConformer Recitation Recognition
      final subAyahs = _ayahs
          .where((a) => a.ayahNumber >= target.startAyah && a.ayahNumber <= target.endAyah)
          .toList();

      final wordsMap = <int, List<QuranRecitationWord>>{};
      for (final a in subAyahs) {
        wordsMap[a.ayahNumber] = QuranRecitationMatcher.initializeWordsForAyah(a);
      }

      setState(() {
        _isRecitationRecording = false;
        _isRecitationCompleted = false;
        _recitationWordsMap = wordsMap;
        _recitationCurrentAyahNumber = target.startAyah;
        _recitationCurrentWordIndex = 0;
      });

      await _recitationGateway.startListening();

      _recitationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted && _isRecitationActive) {
          setState(() {
            _recitationSeconds++;
          });
        }
      });

      _recitationTokenSub = _recitationGateway.tokenStream.listen((token) {
        _onRecitationTokenReceived(token);
      });
    }
  }

  Future<void> _stopInPlaceRecording() async {
    _recitationTimer?.cancel();
    final path = await _recitationRecorder.stopRecording();
    if (!mounted) return;

    final subAyahs = _ayahs
        .where((a) =>
            a.ayahNumber >= (_activeRecitationTarget?.startAyah ?? 1) &&
            a.ayahNumber <= (_activeRecitationTarget?.endAyah ?? 1))
        .toList();

    final totalWords = subAyahs.fold<int>(
      0,
      (sum, a) =>
          sum + a.textUthmani.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length,
    );

    if (_activeRecitationTarget != null) {
      final session = QuranRecitationSession(
        sessionId: 'sess_rec_${DateTime.now().millisecondsSinceEpoch}',
        surahNumber: _currentSurahNumber,
        surahNameArabic: _currentSurah?.nameArabic ?? '',
        startAyah: _activeRecitationTarget!.startAyah,
        endAyah: _activeRecitationTarget!.endAyah,
        mode: RecitationMode.recordAndReplay,
        startedAt: DateTime.now().subtract(Duration(seconds: _recitationSeconds)),
        endedAt: DateTime.now(),
        totalWords: totalWords,
        audioPath: path,
        status: RecitationSessionStatus.completed,
        duration: Duration(seconds: _recitationSeconds),
      );
      await widget.quranModule.recitationSessionStore.saveLastSession(session);
    }

    _initRecitationAudioPlayer(path);

    setState(() {
      _isRecitationRecording = false;
      _isRecitationCompleted = true;
      _recitationAudioPath = path;
    });
  }

  void _initRecitationAudioPlayer(String? path) {
    _disposeRecitationAudioPlayer();
    if (path == null) return;

    try {
      final player = AudioPlayer();
      _recitationAudioPosSub = player.onPositionChanged.listen((pos) {
        if (mounted) setState(() => _recitationPlaybackPosition = pos);
      });
      _recitationAudioDurSub = player.onDurationChanged.listen((dur) {
        if (mounted) setState(() => _recitationPlaybackDuration = dur);
      });
      _recitationAudioStateSub = player.onPlayerStateChanged.listen((state) {
        if (mounted) setState(() => _isRecitationAudioPlaying = (state == PlayerState.playing));
      });
      _recitationAudioPlayer = player;
    } catch (_) {}
  }

  void _disposeRecitationAudioPlayer() {
    _recitationAudioPosSub?.cancel();
    _recitationAudioPosSub = null;
    _recitationAudioDurSub?.cancel();
    _recitationAudioDurSub = null;
    _recitationAudioStateSub?.cancel();
    _recitationAudioStateSub = null;
    try {
      _recitationAudioPlayer?.stop();
      _recitationAudioPlayer?.dispose();
    } catch (_) {}
    _recitationAudioPlayer = null;
    _isRecitationAudioPlaying = false;
    _recitationPlaybackPosition = Duration.zero;
    _recitationPlaybackDuration = Duration.zero;
  }

  Future<void> _toggleRecitationAudioPlayback() async {
    if (_recitationAudioPath == null) return;
    if (_recitationAudioPlayer == null) {
      _initRecitationAudioPlayer(_recitationAudioPath);
    }
    try {
      if (_isRecitationAudioPlaying) {
        await _recitationAudioPlayer?.pause();
      } else {
        if (_recitationPlaybackDuration > Duration.zero &&
            _recitationPlaybackPosition >= _recitationPlaybackDuration) {
          await _recitationAudioPlayer?.seek(Duration.zero);
        }
        await _recitationAudioPlayer?.play(DeviceFileSource(_recitationAudioPath!));
      }
    } catch (_) {}
  }

  Future<void> _seekRecitationAudio(Duration pos) async {
    try {
      await _recitationAudioPlayer?.seek(pos);
    } catch (_) {}
  }

  Future<void> _replayRecitationAudio5Seconds() async {
    if (_recitationAudioPlayer == null) return;
    try {
      final newPos = _recitationPlaybackPosition - const Duration(seconds: 5);
      await _recitationAudioPlayer?.seek(newPos < Duration.zero ? Duration.zero : newPos);
    } catch (_) {}
  }

  void _stopRecitationAudioPlayback() {
    try {
      _recitationAudioPlayer?.stop();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isRecitationAudioPlaying = false;
        _recitationPlaybackPosition = Duration.zero;
      });
    }
  }

  void _onRecitationTokenReceived(QuranRecitationToken token) {
    if (!mounted || _recitationWordsMap == null || _activeRecitationTarget == null) return;

    final subWords = token.rawText.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (subWords.length > 1) {
      for (final sw in subWords) {
        final subToken = QuranRecitationToken(
          rawText: sw,
          normalizedText: QuranRecitationMatcher.normalizeForRecognition(sw),
          confidence: token.confidence,
          timestamp: token.timestamp,
        );
        _matchSingleWordToken(subToken);
      }
    } else {
      _matchSingleWordToken(token);
    }
  }

  void _matchSingleWordToken(QuranRecitationToken token) {
    if (!mounted || _recitationWordsMap == null || _activeRecitationTarget == null) return;

    // Build 3-word parallel lookahead candidates
    final candidates = QuranRecitationMatcher.getLookaheadCandidates(
      wordsMap: _recitationWordsMap!,
      currentAyahNumber: _recitationCurrentAyahNumber,
      currentWordIndex: _recitationCurrentWordIndex,
      endAyah: _activeRecitationTarget!.endAyah,
      windowSize: 3,
    );

    if (candidates.isEmpty) return;

    // Check previous word for hesitation / stutter absorption
    RecitationWordPointer? prevPointer;
    if (_recitationCurrentWordIndex > 0) {
      final curList = _recitationWordsMap![_recitationCurrentAyahNumber];
      if (curList != null && curList.isNotEmpty) {
        prevPointer = RecitationWordPointer(
          ayahNumber: _recitationCurrentAyahNumber,
          wordIndex: _recitationCurrentWordIndex - 1,
          word: curList[_recitationCurrentWordIndex - 1],
        );
      }
    }

    final lookaheadResult = QuranRecitationMatcher.evaluateLookaheadMatch(
      candidates: candidates,
      speechToken: token.normalizedText,
      previousWord: prevPointer,
    );

    if (lookaheadResult.isHesitation) {
      // Absorbed hesitation: user repeated the previous word, do not fail or advance
      return;
    }

    if (lookaheadResult.isMatch && lookaheadResult.matchedPointer != null) {
      final matched = lookaheadResult.matchedPointer!;
      final skipped = lookaheadResult.skippedPointers;

      setState(() {
        _recitationMistakeNotice = null;

        // 1. Mark any skipped words preceding this match as MISTAKES (colored in RED in UI)
        for (final sp in skipped) {
          final ayahWords = _recitationWordsMap![sp.ayahNumber];
          if (ayahWords != null && sp.wordIndex < ayahWords.length) {
            ayahWords[sp.wordIndex] = sp.word.copyWith(
              state: RecitationWordState.mistake,
              confidence: 0.0,
              confidenceLevel: RecitationWordConfidence.uncertain,
            );
          }
        }
        if (skipped.isNotEmpty) {
          _recitationMistakesCount += skipped.length;
        }

        // 2. Mark the matched candidate as RECOGNIZED (CONFIRMED)
        final targetAyahWords = _recitationWordsMap![matched.ayahNumber];
        if (targetAyahWords != null && matched.wordIndex < targetAyahWords.length) {
          targetAyahWords[matched.wordIndex] = matched.word.copyWith(
            state: RecitationWordState.recognized,
            confidence: lookaheadResult.confidence,
            confidenceLevel: lookaheadResult.confidenceLevel,
            recognizedAt: DateTime.now(),
            recognizerToken: token.rawText,
          );
        }

        // 3. Advance pointer to the word immediately following the matched word
        final targetAyahLen = targetAyahWords?.length ?? 0;
        if (matched.wordIndex + 1 < targetAyahLen) {
          _recitationCurrentAyahNumber = matched.ayahNumber;
          _recitationCurrentWordIndex = matched.wordIndex + 1;
        } else {
          // Ayah completed, advance to the next Ayah if within target
          if (matched.ayahNumber < _activeRecitationTarget!.endAyah) {
            _recitationCurrentAyahNumber = matched.ayahNumber + 1;
            _recitationCurrentWordIndex = 0;
            _scrollToAyah(_recitationCurrentAyahNumber);
          } else {
            _finishInPlaceRecitation();
          }
        }
      });
      return;
    }

    // If completely unmatched against all candidates in window, notice minor mistake if different word
    final curWord = candidates.first.word;
    final singleMatch = QuranRecitationMatcher.evaluateWordMatch(
      curWord.normalizedText,
      token.normalizedText,
    );

    if (singleMatch.isMistake) {
      setState(() {
        _recitationMistakesCount++;
        _recitationMistakeNotice = 'غير مطابقة: "${token.rawText}"';
      });
      _recitationMistakeNoticeTimer?.cancel();
      _recitationMistakeNoticeTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _recitationMistakeNotice = null);
      });
      return;
    }
  }

  void _revealRecitationCurrentWord() {
    if (_recitationWordsMap == null || _activeRecitationTarget == null) return;

    final currentWords = _recitationWordsMap![_recitationCurrentAyahNumber];
    if (currentWords == null || _recitationCurrentWordIndex >= currentWords.length) return;

    setState(() {
      final targetWord = currentWords[_recitationCurrentWordIndex];
      currentWords[_recitationCurrentWordIndex] = targetWord.copyWith(
        state: RecitationWordState.revealed,
        confidence: 1.0,
        confidenceLevel: RecitationWordConfidence.confirmed,
      );
      _recitationCurrentWordIndex++;
      if (_recitationCurrentWordIndex >= currentWords.length) {
        if (_recitationCurrentAyahNumber < _activeRecitationTarget!.endAyah) {
          _recitationCurrentAyahNumber++;
          _recitationCurrentWordIndex = 0;
          _scrollToAyah(_recitationCurrentAyahNumber);
        } else {
          _finishInPlaceRecitation();
        }
      }
    });
  }

  void _finishInPlaceRecitation() {
    _recitationTimer?.cancel();
    _recitationGateway.stopListening();
    _recitationTokenSub?.cancel();
    _disposeRecitationAudioPlayer();
    _recitationMistakeNoticeTimer?.cancel();

    setState(() {
      _isRecitationActive = false;
      _isRecitationRecording = false;
      _isRecitationCompleted = false;
      _activeRecitationTarget = null;
      _recitationWordsMap = null;
      _recitationAudioPath = null;
      _recitationMistakesCount = 0;
      _recitationMistakeNotice = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اكتملت جلسة التسميع بنجاح وتمت مراجعة الآيات في المصحف.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _cancelInPlaceRecitation() async {
    _recitationTimer?.cancel();
    _recitationTokenSub?.cancel();
    _disposeRecitationAudioPlayer();
    _recitationMistakeNoticeTimer?.cancel();
    if (_isRecitationRecording) {
      await _recitationRecorder.stopRecording();
    }
    await _recitationGateway.stopListening();

    setState(() {
      _isRecitationActive = false;
      _isRecitationRecording = false;
      _isRecitationCompleted = false;
      _activeRecitationTarget = null;
      _recitationWordsMap = null;
      _recitationAudioPath = null;
      _recitationMistakesCount = 0;
      _recitationMistakeNotice = null;
    });
  }

  void _goToPreviousSurah({bool openLastPage = false}) {
    if (_currentSurahNumber > 1) {
      setState(() {
        _currentSurahNumber -= 1;
        _targetAyahNumber = openLastPage ? 999999 : null;
      });
      _selectionController.clearSelection();
      _loadSurahData();
    }
  }

  void _goToNextSurah() {
    if (_currentSurahNumber < 114) {
      setState(() {
        _currentSurahNumber += 1;
        _targetAyahNumber = null;
      });
      _selectionController.clearSelection();
      _loadSurahData();
    }
  }

  Widget _buildReadingContent(QuranTypographyConfig config) {
    final isMushafFlow = config.readerMode == QuranReaderMode.mushaf ||
        config.readerMode == QuranReaderMode.focus;

    final playingAyah = (_audioReport.status == AudioPlaybackStatus.playing &&
            _audioReport.surahNumber == _currentSurahNumber)
        ? _audioReport.ayahNumber
        : null;

    if (isMushafFlow) {
      if (config.pageTurnMode == QuranPageTurnMode.horizontal) {
        final prevSurahName = _currentSurahNumber > 1
            ? widget.quranModule.getSurah(_currentSurahNumber - 1).valueOrNull?.nameArabic
            : null;
        final nextSurahName = _currentSurahNumber < 114
            ? widget.quranModule.getSurah(_currentSurahNumber + 1).valueOrNull?.nameArabic
            : null;

        return QuranMushafPageView(
          surah: _currentSurah!,
          ayahs: _ayahs,
          config: config,
          selectedAyahNumber: _selectionController.selectedAyah,
          playingAyahNumber: playingAyah,
          bookmarkedAyahs: _bookmarkedAyahs,
          activeRecitationTarget: _activeRecitationTarget,
          isRecitationActive: _isRecitationActive,
          isRecitationTextHidden: _isRecitationRecording,
          recitationWordsMap: _recitationWordsMap,
          pageController: _pageController,
          onAyahTap: _onAyahSingleTap,
          onAyahDoubleTap: _onAyahDoubleTap,
          onAyahLongPress: _onAyahLongPress,
          onPreviousSurah: () => _goToPreviousSurah(openLastPage: true),
          onNextSurah: _goToNextSurah,
          previousSurahName: prevSurahName,
          nextSurahName: nextSurahName,
        );
      }

      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            SurahHeaderCard(
              surah: _currentSurah!,
              juzNumber: _ayahs.isNotEmpty ? _ayahs.first.juzNumber : null,
              config: config,
            ),
            QuranMushafFlowView(
              surah: _currentSurah!,
              ayahs: _ayahs,
              config: config,
              selectedAyahNumber: _selectionController.selectedAyah,
              playingAyahNumber: playingAyah,
              bookmarkedAyahs: _bookmarkedAyahs,
              activeRecitationTarget: _activeRecitationTarget,
              isRecitationActive: _isRecitationActive,
              isRecitationTextHidden: _isRecitationRecording,
              recitationWordsMap: _recitationWordsMap,
              onAyahTap: _onAyahSingleTap,
              onAyahDoubleTap: _onAyahDoubleTap,
              onAyahLongPress: _onAyahLongPress,
            ),
          ],
        ),
      );
    }

    // Verse-by-verse presentation for Translation and Study modes
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: _ayahs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurahHeaderCard(
            surah: _currentSurah!,
            juzNumber: _ayahs.isNotEmpty ? _ayahs.first.juzNumber : null,
            config: config,
          );
        }

        final ayah = _ayahs[index - 1];
        final isBookmarked = _bookmarkedAyahs.contains(ayah.ayahNumber);
        final isSelected = _selectionController.isAyahSelected(ayah.ayahNumber);
        final isPlayingHere = playingAyah == ayah.ayahNumber;

        return AyahView(
          ayah: ayah,
          isBookmarked: isBookmarked,
          isSelected: isSelected,
          isPlaying: isPlayingHere,
          config: config,
          translationText: _translations['$_currentSurahNumber:${ayah.ayahNumber}'],
          tajweedRules: _tajweedRules['$_currentSurahNumber']?['verse_${ayah.ayahNumber}'],
          onTap: () => _onAyahSingleTap(ayah),
          onDoubleTap: () => _onAyahDoubleTap(ayah),
          onLongPress: () => _onAyahLongPress(ayah),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _settingsController.state;
    final bgColor = config.resolveBackgroundColor(context);
    final isFocus = _isDistractionFree || config.readerMode == QuranReaderMode.focus;
    final isAudioActive = _audioReport.status == AudioPlaybackStatus.playing ||
        _audioReport.status == AudioPlaybackStatus.paused;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: isFocus
          ? null
          : AppBar(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  _currentSurah != null ? 'سورة ${_currentSurah!.nameArabic}' : 'القرآن الكريم',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: Icon(
                    config.pageTurnMode == QuranPageTurnMode.horizontal
                        ? Icons.view_headline_rounded
                        : Icons.auto_stories_rounded,
                  ),
                  tooltip: config.pageTurnMode == QuranPageTurnMode.horizontal
                      ? 'التبديل إلى التمرير الرأسي'
                      : 'التبديل إلى التصفح الأفقي بالصفحات',
                  onPressed: () {
                    _settingsController.togglePageTurnMode();
                  },
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: const Icon(Icons.mic_none_rounded),
                  tooltip: 'التسميع والحفظ',
                  onPressed: _openRecitationHub,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'خيارات القراءة والمصحف',
                  onPressed: _openReaderSettings,
                ),
                PopupMenuButton<String>(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: const Icon(Icons.more_vert_rounded),
                  tooltip: 'المزيد من الخيارات',
                  onSelected: (val) {
                    if (val == 'jump') _showJumpToAyahDialog();
                    if (val == 'prev') _goToPreviousSurah();
                    if (val == 'next') _goToNextSurah();
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'jump',
                      child: Text('الانتقال إلى آية'),
                    ),
                    if (_currentSurahNumber > 1)
                      const PopupMenuItem(
                        value: 'prev',
                        child: Text('السورة السابقة'),
                      ),
                    if (_currentSurahNumber < 114)
                      const PopupMenuItem(
                        value: 'next',
                        child: Text('السورة التالية'),
                      ),
                  ],
                ),
              ],
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: AppSpacing.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 48,
                          color: AppColors.warning,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        ElevatedButton(
                          onPressed: _loadSurahData,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    // Main Quran reading text surface
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: config.maxWidth),
                        child: _buildReadingContent(config),
                      ),
                    ),

                    // Floating contextual Ayah Mini-Toolbar
                    if (_selectionController.hasSelection)
                      Positioned(
                        bottom: isAudioActive ? 72 : 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AyahActionToolbar(
                            controller: _selectionController,
                            isBookmarked: _bookmarkedAyahs.contains(
                              _selectionController.selectedAyah ?? 0,
                            ),
                            onCopy: _copySelectedText,
                            onShare: _shareSelectedText,
                            onPlay: () {
                              final aNum = _selectionController.selectedAyah ?? 1;
                              widget.quranModule.audioService.playAyah(
                                _currentSurahNumber,
                                aNum,
                              );
                            },
                            onTafsir: () {
                              final aNum = _selectionController.selectedAyah ?? 1;
                              _openTafsirSheet(aNum);
                            },
                            onBookmark: () {
                              final aNum = _selectionController.selectedAyah;
                              if (aNum != null && aNum <= _ayahs.length) {
                                _toggleBookmark(_ayahs[aNum - 1]);
                              }
                            },
                            onMore: () {
                              final aNum = _selectionController.selectedAyah;
                              if (aNum != null && aNum <= _ayahs.length) {
                                _onAyahLongPress(_ayahs[aNum - 1]);
                              }
                            },
                            onClose: () => _selectionController.clearSelection(),
                          ),
                        ),
                      ),

                    // Floating Mini-Player (only when audio active)
                    if (isAudioActive)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: QuranMiniPlayer(
                              report: _audioReport,
                              surahNameArabic: _currentSurah?.nameArabic ?? '',
                              onPlayPause: () {
                                if (_audioReport.status == AudioPlaybackStatus.playing) {
                                  widget.quranModule.audioService.pause();
                                } else {
                                  widget.quranModule.audioService.resume();
                                }
                              },
                              onNext: () => widget.quranModule.audioService.nextAyah(),
                              onPrevious: () => widget.quranModule.audioService.previousAyah(),
                              onStop: () => widget.quranModule.audioService.stop(),
                            ),
                          ),
                        ),
                      ),

                    // Floating In-Place Recitation Control Bar (§M02.2)
                    if (_isRecitationActive)
                      _buildInPlaceRecitationBar(
                        config.themeMode == QuranReaderThemeMode.dark ||
                            Theme.of(context).brightness == Brightness.dark,
                      ),

                    // Floating Exit Button for Focus / Khushoo' Mode
                    if (isFocus)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        child: SafeArea(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _settingsController.updateConfig(
                                  config.copyWith(readerMode: QuranReaderMode.mushaf),
                                );
                                setState(() => _isDistractionFree = false);
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: (Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF1E232A)
                                          : Colors.white)
                                      .withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.goldAccent.withValues(alpha: 0.65),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: Theme.of(context).brightness == Brightness.dark ? 0.4 : 0.15,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.fullscreen_exit_rounded,
                                      size: 20,
                                      color: AppColors.goldAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'إنهاء وضع الخشوع',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? AppColors.goldAccent
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildInPlaceRecitationBar(bool isDark) {
    final minutes = (_recitationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recitationSeconds % 60).toString().padLeft(2, '0');

    return Positioned(
      bottom: 12,
      left: 8,
      right: 8,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232D) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isRecitationCompleted
                ? _buildModeACompletedBar(isDark)
                : _activeRecitationMode == RecitationMode.recordAndReplay
                    ? _buildModeARecordingBar(isDark, minutes, seconds)
                    : _buildModeBRecognitionBar(isDark, minutes, seconds),
          ),
        ),
      ),
    );
  }

  Widget _buildModeARecordingBar(bool isDark, String minutes, String seconds) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$minutes:$seconds',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: _stopInPlaceRecording,
          icon: const Icon(Icons.stop_rounded, size: 16),
          label: const Text('إيقاف وحفظ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 32),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: _cancelInPlaceRecitation,
          icon: const Icon(Icons.close_rounded, size: 18),
          tooltip: 'إلغاء التسميع',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }

  Widget _buildModeACompletedBar(bool isDark) {
    final posSec = _recitationPlaybackPosition.inSeconds;
    final durSec = _recitationPlaybackDuration.inSeconds;
    final posStr = '${(posSec ~/ 60).toString().padLeft(2, '0')}:${(posSec % 60).toString().padLeft(2, '0')}';
    final durStr = '${(durSec ~/ 60).toString().padLeft(2, '0')}:${(durSec % 60).toString().padLeft(2, '0')}';

    final maxVal = _recitationPlaybackDuration.inMilliseconds.toDouble();
    final curVal = _recitationPlaybackPosition.inMilliseconds.toDouble().clamp(0.0, maxVal > 0 ? maxVal : 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top row: Info title & Action buttons
        Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'ظهرت الآيات! استمع وطابق تلاوتك',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                _stopRecitationAudioPlayback();
                if (_activeRecitationTarget != null) {
                  _startInPlaceRecitation(_activeRecitationTarget!, RecitationMode.recordAndReplay);
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              tooltip: 'إعادة التسجيل',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            ),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: _finishInPlaceRecitation,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                minimumSize: const Size(0, 26),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('إنهاء', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        if (_recitationAudioPath != null) ...[
          const SizedBox(height: 2),
          // Audio Player Controls Row
          Row(
            children: [
              // Play/Pause button
              IconButton(
                onPressed: _toggleRecitationAudioPlayback,
                icon: Icon(
                  _isRecitationAudioPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
              // Replay 5s backwards button
              IconButton(
                onPressed: _replayRecitationAudio5Seconds,
                icon: const Icon(Icons.replay_5_rounded, size: 18),
                tooltip: 'ترجيع 5 ثوانٍ',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
              // Scrubbing Slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.5,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
                    thumbColor: AppColors.primary,
                  ),
                  child: Slider(
                    value: curVal,
                    min: 0.0,
                    max: maxVal > 0 ? maxVal : 1.0,
                    onChanged: (val) {
                      _seekRecitationAudio(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
              ),
              // Current & Total Time
              Text(
                '$posStr / $durStr',
                style: TextStyle(
                  fontSize: 10,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildModeBRecognitionBar(bool isDark, String minutes, String seconds) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_recitationMistakeNotice != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 13),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _recitationMistakeNotice!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
        Row(
          children: [
            InkWell(
              onTap: () async {
                await _recitationGateway.startListening();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الميكروفون نشط ويعمل'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$minutes:$seconds',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_recitationMistakesCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'أخطاء: $_recitationMistakesCount',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: _revealRecitationCurrentWord,
              icon: const Icon(Icons.remove_red_eye_rounded, size: 14),
              label: const Text('إظهار كلمة', style: TextStyle(fontSize: 11)),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.goldAccent.withValues(alpha: 0.25),
                foregroundColor: isDark ? Colors.amber[200] : const Color(0xFF8B6508),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 30),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _finishInPlaceRecitation,
              icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 20),
              tooltip: 'إنهاء التسميع',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ],
    );
  }
}
