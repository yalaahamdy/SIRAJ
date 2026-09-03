import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_session.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../../../modules/quran/recitation/domain/recitation_playback_policy.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_recorder.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_session_store.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../theme/app_colors.dart';

/// Interactive View for Mode A: Record & Replay recitation (§3, §14, §15).
/// Enforces Quran First + Minimal UI: hides text while recording, then reveals
/// canonical text during playback so the user hears their own voice and self-evaluates.
class RecitationModeAView extends StatefulWidget {
  final QuranRecitationTarget target;
  final List<Ayah> targetAyahs;
  final QuranTypographyConfig config;
  final QuranRecitationRecorder recorder;
  final QuranRecitationSessionStore sessionStore;
  final VoidCallback onClose;

  const RecitationModeAView({
    super.key,
    required this.target,
    required this.targetAyahs,
    required this.config,
    required this.recorder,
    required this.sessionStore,
    required this.onClose,
  });

  @override
  State<RecitationModeAView> createState() => _RecitationModeAViewState();
}

enum _ModeAState { ready, recording, completed }

class _RecitationModeAViewState extends State<RecitationModeAView> {
  _ModeAState _state = _ModeAState.ready;
  String? _recordedFilePath;
  Timer? _timer;
  int _elapsedSeconds = 0;
  DateTime? _sessionStartTime;

  // Playback controller
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _compSub;

  @override
  void initState() {
    super.initState();
    _initPlaybackSubscriptions();
  }

  void _initPlaybackSubscriptions() {
    _posSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _playbackPosition = pos);
    });
    _durSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _playbackDuration = dur);
    });
    _compSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();
    _compSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _startRecording() async {
    try {
      _sessionStartTime = DateTime.now();
      _recordedFilePath = await widget.recorder.startRecording(
        surahNumber: widget.target.surahNumber,
        startAyah: widget.target.startAyah,
        endAyah: widget.target.endAyah,
      );

      setState(() {
        _state = _ModeAState.recording;
        _elapsedSeconds = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (mounted) setState(() => _elapsedSeconds++);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر بدء التسجيل: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await widget.recorder.stopRecording();
    setState(() {
      _recordedFilePath = path;
      _state = _ModeAState.completed;
    });

    // Save session in storage store
    final totalWords = widget.targetAyahs.fold<int>(
      0,
      (sum, a) => sum + a.textUthmani.split(RegExp(r'\s+')).length,
    );

    final session = QuranRecitationSession(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      surahNumber: widget.target.surahNumber,
      surahNameArabic: widget.target.surahNameArabic,
      startAyah: widget.target.startAyah,
      endAyah: widget.target.endAyah,
      mode: RecitationMode.recordAndReplay,
      startedAt: _sessionStartTime ?? DateTime.now(),
      endedAt: DateTime.now(),
      audioPath: path,
      totalWords: totalWords,
      duration: Duration(seconds: _elapsedSeconds),
      status: RecitationSessionStatus.completed,
    );

    await widget.sessionStore.saveLastSession(session);
  }

  Future<void> _togglePlayback() async {
    if (_recordedFilePath == null) return;
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _deleteRecording() async {
    await _audioPlayer.stop();
    await widget.recorder.deleteRecording(_recordedFilePath);
    setState(() {
      _state = _ModeAState.ready;
      _recordedFilePath = null;
      _elapsedSeconds = 0;
      _isPlaying = false;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF14171A) : const Color(0xFFFAF8F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.target.formatArabicRange()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'إغلاق وضع التسميع',
          onPressed: () async {
            if (_state == _ModeAState.recording) {
              await widget.recorder.stopRecording();
            }
            widget.onClose();
          },
        ),
      ),
      body: Column(
        children: [
          // 1. Informational header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: _state == _ModeAState.completed
                ? AppColors.primary.withValues(alpha: 0.12)
                : (isDark ? const Color(0xFF1E242C) : const Color(0xFFF0F3F6)),
            child: Row(
              children: [
                Icon(
                  _state == _ModeAState.completed
                      ? Icons.verified_rounded
                      : Icons.visibility_off_rounded,
                  size: 18,
                  color: _state == _ModeAState.completed
                      ? AppColors.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _state == _ModeAState.completed
                        ? 'تم التسجيل بنجاح. استمع إلى تلاوتك وطابقها مع المصحف الشريف.'
                        : 'نص الآيات مخفي لتمكينك من التسميع غيباً. اضغط بدء التسجيل ثم رتّل.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _state == _ModeAState.completed
                          ? AppColors.primary
                          : null,
                      fontWeight: _state == _ModeAState.completed
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Quran Text Display Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildQuranTextContent(isDark),
            ),
          ),

          // 3. Bottom Control Console
          _buildControlPanel(isDark),
        ],
      ),
    );
  }

  Widget _buildQuranTextContent(bool isDark) {
    if (_state != _ModeAState.completed) {
      // HIDDEN STATE: Accessible and visually veiled (§16, §17)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.targetAyahs.map((ayah) {
          return Semantics(
            label: 'نص الآية ${ayah.ayahNumber} مخفي أثناء التسميع',
            excludeSemantics: true,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E232B) : const Color(0xFFEDE9DE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.goldAccent.withValues(alpha: 0.2),
                    child: Text(
                      '${ayah.ayahNumber}',
                      style: const TextStyle(fontSize: 11, color: AppColors.goldAccent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '••••••••••••••••••••••••••••••••••••',
                      style: TextStyle(letterSpacing: 4, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    // REVEALED STATE: Full canonical Uthmani calligraphy
    final quranStyle = widget.config.buildQuranTextStyle();
    final markerStyle = widget.config.buildAyahMarkerStyle();

    return Text.rich(
      TextSpan(
        children: widget.targetAyahs.expand((ayah) {
          return [
            TextSpan(
              text: '${ayah.textUthmani} ',
              style: quranStyle,
            ),
            TextSpan(
              text: ' ﴿${ayah.ayahNumber}﴾ ',
              style: markerStyle.copyWith(color: AppColors.primary),
            ),
          ];
        }).toList(),
      ),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildControlPanel(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232B) : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _state == _ModeAState.ready
            ? _buildReadyControls()
            : _state == _ModeAState.recording
                ? _buildRecordingControls()
                : _buildCompletedControls(),
      ),
    );
  }

  Widget _buildReadyControls() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.mic_rounded),
        label: const Text(
          'بدء تسجيل التلاوة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _startRecording,
      ),
    );
  }

  Widget _buildRecordingControls() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatDuration(_elapsedSeconds),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'جارٍ تسجيل تلاوتك...',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.stop_rounded),
          label: const Text('إيقاف وحفظ'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _stopRecording,
        ),
      ],
    );
  }

  Widget _buildCompletedControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Playback audio progress bar
        Row(
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
              iconSize: 38,
              color: AppColors.primary,
              onPressed: _togglePlayback,
            ),
            Expanded(
              child: Slider(
                value: _playbackPosition.inMilliseconds
                    .toDouble()
                    .clamp(0.0, _playbackDuration.inMilliseconds.toDouble() > 0 ? _playbackDuration.inMilliseconds.toDouble() : 1.0),
                max: _playbackDuration.inMilliseconds.toDouble() > 0
                    ? _playbackDuration.inMilliseconds.toDouble()
                    : 1.0,
                onChanged: (val) {
                  _audioPlayer.seek(Duration(milliseconds: val.toInt()));
                },
              ),
            ),
            Text(
              '${_formatDuration(_playbackPosition.inSeconds)} / ${_formatDuration(_playbackDuration.inSeconds)}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 8),
        // Secondary actions: Delete and Restart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
              label: const Text('حذف التسجيل', style: TextStyle(color: Colors.red, fontSize: 12)),
              onPressed: _deleteRecording,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('تسجيل محاولة جديدة', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _deleteRecording,
            ),
          ],
        ),
      ],
    );
  }
}
