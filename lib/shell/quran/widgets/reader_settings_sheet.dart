import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/quran_reciter.dart';
import '../../../../modules/quran/domain/quran_translation.dart';
import '../../../../modules/quran/recitation/domain/recitation_playback_policy.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../theme/app_colors.dart';

/// Comprehensive, modern Reader Settings bottom sheet (§16, §41, §42).
/// Stateful to prevent stale state overwrites and ensure opaque, readable styling.
class ReaderSettingsSheet extends StatefulWidget {
  final QuranTypographyConfig config;
  final ValueChanged<QuranTypographyConfig> onConfigChanged;

  const ReaderSettingsSheet({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  late QuranTypographyConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
  }

  void _update(QuranTypographyConfig updated) {
    setState(() {
      _currentConfig = updated;
    });
    widget.onConfigChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark ||
        _currentConfig.themeMode == QuranReaderThemeMode.dark;

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
                const Text(
                  'إعدادات المصحف وتجربة القراءة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // 1. Reading Mode Selection
                const Text(
                  'وضع القراءة',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: QuranReaderMode.values.map((mode) {
                      final isSelected = _currentConfig.readerMode == mode;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(mode.labelArabic),
                          selected: isSelected,
                          selectedColor: AppColors.goldAccent.withValues(alpha: 0.25),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.goldAccent : null,
                          ),
                          onSelected: (val) {
                            if (val) {
                              _update(_currentConfig.copyWith(readerMode: mode));
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // 1b. Page Turn Mode Selection (Vertical vs Horizontal)
                const Text(
                  'طريقة تصفح المصحف',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: QuranPageTurnMode.values.map((turnMode) {
                    final isSelected = _currentConfig.pageTurnMode == turnMode;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.goldAccent.withValues(alpha: 0.2)
                                : null,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.goldAccent
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: Icon(turnMode.icon, size: 16, color: isSelected ? AppColors.goldAccent : null),
                          label: Text(
                            turnMode.labelArabic,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.goldAccent : null,
                            ),
                          ),
                          onPressed: () {
                            _update(_currentConfig.copyWith(pageTurnMode: turnMode));
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 2. Reading Theme Selection
                const Text(
                  'السمة البصرية',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: QuranReaderThemeMode.values.map((theme) {
                    final isSelected = _currentConfig.themeMode == theme;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.goldAccent.withValues(alpha: 0.2)
                                : null,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.goldAccent
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            _update(_currentConfig.copyWith(themeMode: theme));
                          },
                          child: Text(
                            theme.labelArabic,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 3. Quran Font Selection
                const Text(
                  'الخط القرآني',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<QuranFontFamily>(
                      isExpanded: true,
                      value: _currentConfig.fontFamily,
                      items: QuranFontFamily.values.map((f) {
                        return DropdownMenuItem(
                          value: f,
                          child: Text(
                            f.displayNameArabic,
                            style: TextStyle(fontFamily: f.fontFamily, fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _update(_currentConfig.copyWith(fontFamily: val));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Font Size Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'حجم الخط القرآني',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_currentConfig.fontSize.toInt()} نقطة',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _currentConfig.fontSize,
                  min: 18.0,
                  max: 38.0,
                  divisions: 10,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _update(_currentConfig.copyWith(fontSize: val));
                  },
                ),
                const SizedBox(height: 12),

                // 5. Line Height Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تباعد الأسطر',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_currentConfig.lineHeight.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _currentConfig.lineHeight,
                  min: 1.8,
                  max: 2.8,
                  divisions: 5,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _update(_currentConfig.copyWith(lineHeight: val));
                  },
                ),
                const SizedBox(height: 16),

                // 6. Content Toggles
                SwitchListTile(
                  title: const Text('أحكام التجويد الملونة', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('تلوين مخارج وأحكام التلاوة بطبقة بصرية راقية', style: TextStyle(fontSize: 11)),
                  value: _currentConfig.showTajweed,
                  activeThumbColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _update(_currentConfig.copyWith(showTajweed: val));
                  },
                ),
                SwitchListTile(
                  title: const Text('ترجمة المعاني', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('إظهار ترجمة معاني الآيات المعتمدة أسفل كل آية', style: TextStyle(fontSize: 11)),
                  value: _currentConfig.showTranslation,
                  activeThumbColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _update(_currentConfig.copyWith(showTranslation: val));
                  },
                ),
                if (_currentConfig.showTranslation) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.5)),
                        color: AppColors.goldAccent.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.translate_rounded, size: 18, color: AppColors.goldAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _currentConfig.translationLanguage,
                                items: kAvailableQuranTranslations.map((t) {
                                  return DropdownMenuItem(
                                    value: t.code,
                                    child: Text(
                                      '${t.nameNative} (${t.nameEnglish})',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _update(_currentConfig.copyWith(translationLanguage: val));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SwitchListTile(
                  title: const Text('التمرير التلقائي أثناء التلاوة (Auto-Scroll)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('تحريك الشاشة تلقائياً وبسلاسة إلى الآية المتلوة', style: TextStyle(fontSize: 11)),
                  value: _currentConfig.autoScroll,
                  activeThumbColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _update(_currentConfig.copyWith(autoScroll: val));
                  },
                ),
                const Divider(height: 32),

                // 7. Recitation & Audio Controls (§15, §16)
                const Text(
                  'التلاوة والتسميع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),

                // Reciter Selection
                const Text('القارئ المعتمد', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.5)),
                    color: AppColors.goldAccent.withValues(alpha: 0.05),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, size: 18, color: AppColors.goldAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: kAvailableReciters.any((r) => r.nameArabic == _currentConfig.reciter)
                                ? _currentConfig.reciter
                                : kDefaultAbdulBasitReciter.nameArabic,
                            items: kAvailableReciters.map((r) {
                              return DropdownMenuItem(
                                value: r.nameArabic,
                                child: Text(
                                  r.nameArabic + (r.isDefault ? ' (الافتراضي)' : ''),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _update(_currentConfig.copyWith(reciter: val));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Playback Speed Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('سرعة التلاوة', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SegmentedButton<double>(
                        segments: const [
                          ButtonSegment(value: 0.75, label: Text('0.75x')),
                          ButtonSegment(value: 1.0, label: Text('1.0x')),
                          ButtonSegment(value: 1.25, label: Text('1.25x')),
                          ButtonSegment(value: 1.5, label: Text('1.5x')),
                          ButtonSegment(value: 2.0, label: Text('2.0x')),
                        ],
                        selected: {_currentConfig.playbackSpeed},
                        onSelectionChanged: (val) {
                          _update(_currentConfig.copyWith(playbackSpeed: val.first));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Repeat Mode Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تكرار التلاوة للتحفيظ', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 6),
                    SegmentedButton<PlaybackRepeatPolicy>(
                      segments: const [
                        ButtonSegment(value: PlaybackRepeatPolicy.none, label: Text('بدون')),
                        ButtonSegment(value: PlaybackRepeatPolicy.ayah, label: Text('آية')),
                        ButtonSegment(value: PlaybackRepeatPolicy.range, label: Text('نطاق')),
                        ButtonSegment(value: PlaybackRepeatPolicy.surah, label: Text('سورة')),
                      ],
                      selected: {_currentConfig.repeatPolicy},
                      onSelectionChanged: (val) {
                        _update(_currentConfig.copyWith(repeatPolicy: val.first));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Repeat Count Slider (if repeatPolicy != none)
                if (_currentConfig.repeatPolicy != PlaybackRepeatPolicy.none) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('عدد مرات التكرار', style: TextStyle(fontSize: 12)),
                      Text('${_currentConfig.repeatCount} مرات', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: _currentConfig.repeatCount.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      _update(_currentConfig.copyWith(repeatCount: val.toInt()));
                    },
                  ),
                  const SizedBox(height: 10),
                ],

                // Delay between Ayahs Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('فاصل زمني بين الآيات', style: TextStyle(fontSize: 12)),
                    DropdownButton<int>(
                      value: _currentConfig.delayBetweenAyahsSeconds,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('بدون فاصل')),
                        DropdownMenuItem(value: 1, child: Text('ثانية واحدة')),
                        DropdownMenuItem(value: 2, child: Text('ثانيتان')),
                        DropdownMenuItem(value: 3, child: Text('3 ثوانٍ')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          _update(_currentConfig.copyWith(delayBetweenAyahsSeconds: val));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
