import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_session.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../../../modules/quran/recitation/domain/recitation_playback_policy.dart';
import '../../../../modules/quran/recitation/services/quran_recitation_session_store.dart';
import '../../theme/app_colors.dart';

/// Recitation Hub modal bottom sheet (§14, §15).
/// Minimal, respectful Arabic-first interface for initiating Quran recitation sessions.
class RecitationHubSheet extends StatefulWidget {
  final Surah surah;
  final int totalAyahs;
  final int currentAyahNumber;
  final QuranRecitationSessionStore sessionStore;
  final void Function(QuranRecitationTarget target, RecitationMode mode) onStartRecitation;

  const RecitationHubSheet({
    super.key,
    required this.surah,
    required this.totalAyahs,
    required this.currentAyahNumber,
    required this.sessionStore,
    required this.onStartRecitation,
  });

  @override
  State<RecitationHubSheet> createState() => _RecitationHubSheetState();
}

class _RecitationHubSheetState extends State<RecitationHubSheet> {
  int _rangeType = 0; // 0: current ayah, 1: custom range, 2: full surah
  late int _startAyah;
  late int _endAyah;
  RecitationMode _selectedMode = RecitationMode.recordAndReplay;
  QuranRecitationSession? _lastSession;
  bool _isLoadingLastSession = true;

  @override
  void initState() {
    super.initState();
    _startAyah = widget.currentAyahNumber;
    _endAyah = (widget.currentAyahNumber + 4).clamp(1, widget.totalAyahs);
    _loadLastSession();
  }

  Future<void> _loadLastSession() async {
    final session = await widget.sessionStore.getLastSession();
    if (mounted) {
      setState(() {
        _lastSession = session;
        _isLoadingLastSession = false;
      });
    }
  }

  QuranRecitationTarget _buildTarget() {
    int start;
    int end;

    if (_rangeType == 0) {
      start = widget.currentAyahNumber;
      end = widget.currentAyahNumber;
    } else if (_rangeType == 2) {
      start = 1;
      end = widget.totalAyahs;
    } else {
      start = _startAyah;
      end = _endAyah;
    }

    return QuranRecitationTarget(
      surahNumber: widget.surah.number,
      surahNameArabic: widget.surah.nameArabic,
      startAyah: start,
      endAyah: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF181C22) : const Color(0xFFFAF8F5);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.mic_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'مركز التسميع والحفظ — سورة ${widget.surah.nameArabic}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Section 1: Range Selection
                const Text(
                  'تحديد موضع التسميع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 340;
                    return SegmentedButton<int>(
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      segments: [
                        ButtonSegment(value: 0, label: Text(isCompact ? 'الحالية' : 'الآية الحالية', style: const TextStyle(fontSize: 11))),
                        ButtonSegment(value: 1, label: Text(isCompact ? 'نطاق' : 'نطاق محدد', style: const TextStyle(fontSize: 11))),
                        ButtonSegment(value: 2, label: Text(isCompact ? 'كاملة' : 'السورة كاملة', style: const TextStyle(fontSize: 11))),
                      ],
                      selected: {_rangeType},
                      onSelectionChanged: (val) => setState(() => _rangeType = val.first),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Range picker if custom range
                if (_rangeType == 1) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('من الآية:', style: TextStyle(fontSize: 12)),
                            DropdownButton<int>(
                              value: _startAyah,
                              isExpanded: true,
                              items: List.generate(
                                widget.totalAyahs,
                                (i) => DropdownMenuItem(value: i + 1, child: Text('الآية ${i + 1}')),
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _startAyah = val;
                                    if (_endAyah < val) _endAyah = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('إلى الآية:', style: TextStyle(fontSize: 12)),
                            DropdownButton<int>(
                              value: _endAyah,
                              isExpanded: true,
                              items: List.generate(
                                widget.totalAyahs - _startAyah + 1,
                                (i) {
                                  final num = _startAyah + i;
                                  return DropdownMenuItem(value: num, child: Text('الآية $num'));
                                },
                              ),
                              onChanged: (val) {
                                if (val != null) setState(() => _endAyah = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Section 2: Mode Selection
                const Text(
                  'اختر وضع التسميع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Mode A Card
                InkWell(
                  onTap: () => setState(() => _selectedMode = RecitationMode.recordAndReplay),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _selectedMode == RecitationMode.recordAndReplay
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedMode == RecitationMode.recordAndReplay
                            ? AppColors.primary
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic_external_on_rounded,
                          color: _selectedMode == RecitationMode.recordAndReplay
                              ? AppColors.primary
                              : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'تسجيل التلاوة والاستماع الذاتي (موصى به)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'يُحجب النص، تسجل تلاوتك بصوتك، ثم تستمع وتطابق تلاوتك مع المصحف بنفسك.',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _selectedMode == RecitationMode.recordAndReplay
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: _selectedMode == RecitationMode.recordAndReplay
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Mode B Card
                InkWell(
                  onTap: () => setState(() => _selectedMode = RecitationMode.recognition),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _selectedMode == RecitationMode.recognition
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedMode == RecitationMode.recognition
                            ? AppColors.primary
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hearing_rounded,
                          color: _selectedMode == RecitationMode.recognition
                              ? AppColors.primary
                              : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'التعرف الآلي الذكي (FastConformer)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'نموذج ذكي يتعرف على تلاوتك وتظهر الكلمات تباعاً مع إمكانية إظهار الكلمات عند الحاجة.',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _selectedMode == RecitationMode.recognition
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: _selectedMode == RecitationMode.recognition
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                // Last session overview
                if (!_isLoadingLastSession && _lastSession != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222730) : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.history_rounded, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'آخر جلسة: سورة ${_lastSession!.surahNameArabic} (${_lastSession!.startAyah}—${_lastSession!.endAyah}) • ${_lastSession!.mode == RecitationMode.recordAndReplay ? "تسجيل" : "تعرف"}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  'ابدأ التسميع الآن',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final target = _buildTarget();
                  Navigator.of(context).pop();
                  widget.onStartRecitation(target, _selectedMode);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
