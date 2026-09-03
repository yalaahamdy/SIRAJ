import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/quran_bookmark.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/quran_reciter.dart';
import '../../../../modules/quran/domain/quran_translation.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../controllers/quran_reader_settings_controller.dart';

/// Comprehensive Quran Settings & Customization Tab (§10..§16, §20..§25).
/// Enables users to customize:
/// - Reading Mode (Mushaf, Translation, Study, Focus)
/// - Visual Themes (Light, Sepia, Dark)
/// - Arabic Typography & Font Sizing
/// - 11 Offline Translation Languages
/// - Reciters, Playback Speed, & Local ZIP / Audio Management
/// - On-demand Surah downloader for full offline listening
/// - Tajweed, Tafsir, Word-by-Word toggles
/// - Saved Bookmarks & Reading Progress
class QuranSettingsTab extends StatefulWidget {
  final QuranModule quranModule;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;
  final VoidCallback? onSettingsChanged;

  const QuranSettingsTab({
    super.key,
    required this.quranModule,
    required this.onOpenSurah,
    this.onSettingsChanged,
  });

  @override
  State<QuranSettingsTab> createState() => _QuranSettingsTabState();
}

class _QuranSettingsTabState extends State<QuranSettingsTab> {
  late QuranReaderSettingsController _settingsController;
  List<QuranBookmark> _bookmarks = [];
  List<Surah> _surahs = [];
  bool _isLoadingBookmarks = true;
  bool _isImportingZip = false;
  int _downloadedFilesCount = 0;

  @override
  void initState() {
    super.initState();
    _settingsController = QuranReaderSettingsController(
      store: widget.quranModule.userDataService.store,
    );
    _settingsController.addListener(_handleSettingsUpdate);
    _surahs = widget.quranModule.getAllSurahs().valueOrNull ?? [];
    _loadBookmarks();
    _refreshOfflineAudioStatus();
  }

  @override
  void dispose() {
    _settingsController.removeListener(_handleSettingsUpdate);
    _settingsController.dispose();
    super.dispose();
  }

  void _handleSettingsUpdate() {
    if (mounted) {
      setState(() {});
      _refreshOfflineAudioStatus();
      widget.onSettingsChanged?.call();
    }
  }

  Future<void> _loadBookmarks() async {
    final res = await widget.quranModule.getBookmarks();
    if (mounted) {
      setState(() {
        _bookmarks = res.valueOrNull ?? [];
        _isLoadingBookmarks = false;
      });
    }
  }

  QuranReciter get _activeReciter {
    final config = _settingsController.state;
    return kAvailableReciters.firstWhere(
      (r) => r.nameArabic == config.reciter,
      orElse: () => kDefaultAbdulBasitReciter,
    );
  }

  Future<void> _refreshOfflineAudioStatus() async {
    final count = await widget.quranModule.offlineAudioService.getTotalDownloadedFilesCount(_activeReciter.id);
    if (mounted) {
      setState(() {
        _downloadedFilesCount = count;
      });
    }
  }

  Future<void> _handlePickAndImportZip(QuranReciter reciter) async {
    setState(() => _isImportingZip = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جارٍ اختيار وقراءة ملف الـ ZIP واستخراج التلاوات...'),
        duration: Duration(seconds: 3),
      ),
    );

    try {
      final result = await widget.quranModule.offlineAudioService.pickAndImportZip(reciterId: reciter.id);
      if (!mounted) return;

      setState(() => _isImportingZip = false);

      if (result == null) {
        // User cancelled picker
        return;
      }

      if (result.isSuccess) {
        await _refreshOfflineAudioStatus();
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: AppColors.goldAccent),
                SizedBox(width: 8),
                Text('تم الاستيراد بنجاح', style: TextStyle(fontSize: 16)),
              ],
            ),
            content: Text(
              'تم استخراج واستيراد ${result.importedVersesCount} آية بصيغة MP3 للشيخ ${reciter.nameArabic} بنجاح!\n\nيمكنك الآن الاستماع لتلاوات هذه الآيات بالكامل بدون إنترنت.',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('تم'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'تعذر استيراد ملف الـ ZIP'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImportingZip = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ أثناء الاستيراد: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showDownloadSurahsSheet(QuranReciter reciter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SurahDownloaderSheet(
        quranModule: widget.quranModule,
        reciter: reciter,
        surahs: _surahs,
        onDownloadCompleted: () {
          _refreshOfflineAudioStatus();
        },
      ),
    );
  }

  Future<void> _handleDeleteOfflineAudio(QuranReciter reciter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف التلاوات المحلية'),
        content: Text('هل تريد حذف جميع التلاوات المحفوظة محلياً للشيخ ${reciter.nameArabic} لتوفير المساحة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.quranModule.offlineAudioService.deleteReciterAudio(reciter.id);
      await _refreshOfflineAudioStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف التلاوات المحلية بنجاح')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _settingsController.state;
    final isDark = Theme.of(context).brightness == Brightness.dark ||
        config.themeMode == QuranReaderThemeMode.dark;

    final activeReciter = _activeReciter;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
      children: [
        // 1. Section Header: Reading Mode
        _buildSectionHeader(
          icon: Icons.chrome_reader_mode_rounded,
          title: 'وضع القراءة',
          subtitle: 'اختر طريقة عرض آيات وصفحات المصحف الشريف',
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: QuranReaderMode.values.map((mode) {
              final isSelected = config.readerMode == mode;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
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
                      _settingsController.setReaderMode(mode);
                      if (mode == QuranReaderMode.translation) {
                        _settingsController.setShowTranslation(true);
                      }
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // 2. Section Header: Visual Themes
        _buildSectionHeader(
          icon: Icons.palette_rounded,
          title: 'السمة البصرية للمصحف',
          subtitle: 'ألوان وخلفيات مريحة للعين أثناء التلاوة',
        ),
        Row(
          children: QuranReaderThemeMode.values.map((theme) {
            final isSelected = config.themeMode == theme;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => _settingsController.setThemeMode(theme),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: theme == QuranReaderThemeMode.sepia
                          ? const Color(0xFFEDE3CE)
                          : (theme == QuranReaderThemeMode.dark
                              ? const Color(0xFF1E232A)
                              : const Color(0xFFF9F5EE)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.goldAccent : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        theme.labelArabic,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: theme == QuranReaderThemeMode.dark
                              ? Colors.white
                              : const Color(0xFF2C1F10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // 3. Section Header: Typography & Sizing
        _buildSectionHeader(
          icon: Icons.text_fields_rounded,
          title: 'الخط القرآني وحجم النص',
          subtitle: 'تخصيص الخط والمسافات بما يناسب راحتك',
        ),
        Card(
          elevation: 0,
          color: isDark ? const Color(0xFF1E242C) : const Color(0xFFF6F3EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<QuranFontFamily>(
                  initialValue: config.fontFamily,
                  decoration: const InputDecoration(
                    labelText: 'نوع الخط القرآني',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  items: QuranFontFamily.values.map((f) {
                    return DropdownMenuItem(
                      value: f,
                      child: Text(f.displayNameArabic, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) _settingsController.setFontFamily(val);
                  },
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('حجم الخط القرآني', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${config.fontSize.toInt()} px',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                  ],
                ),
                Slider(
                  value: config.fontSize,
                  min: 18.0,
                  max: 38.0,
                  divisions: 10,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) => _settingsController.setFontSize(val),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('تباعد الأسطر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${config.lineHeight.toStringAsFixed(1)}x',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                  ],
                ),
                Slider(
                  value: config.lineHeight,
                  min: 1.8,
                  max: 2.8,
                  divisions: 5,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) => _settingsController.setLineHeight(val),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: config.resolveBackgroundColor(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ﴿١﴾',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: config.fontFamily.fontFamily,
                      fontSize: config.fontSize,
                      height: config.lineHeight,
                      color: config.resolveTextColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 4. Section Header: Translation Languages
        _buildSectionHeader(
          icon: Icons.translate_rounded,
          title: 'ترجمة المعاني واللغات',
          subtitle: '11 لغة وترجمة معتمدة مدمجة محلياً',
        ),
        Card(
          elevation: 0,
          color: isDark ? const Color(0xFF1E242C) : const Color(0xFFF6F3EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('إظهار ترجمة المعاني', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('عرض ترجمة معاني الآيات أسفل كل آية', style: TextStyle(fontSize: 11)),
                  value: config.showTranslation || config.readerMode == QuranReaderMode.translation,
                  activeThumbColor: AppColors.goldAccent,
                  onChanged: (val) {
                    _settingsController.setShowTranslation(val);
                    if (val && config.readerMode == QuranReaderMode.mushaf) {
                      _settingsController.setReaderMode(QuranReaderMode.translation);
                    }
                  },
                ),
                const Divider(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: config.translationLanguage,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'لغة الترجمة المعتمدة',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  items: kAvailableQuranTranslations.map((t) {
                    return DropdownMenuItem(
                      value: t.code,
                      child: Text(
                        '${t.nameNative} (${t.nameEnglish})',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _settingsController.setTranslationLanguage(val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 5. Section Header: Recitation & Offline Audio Package
        _buildSectionHeader(
          icon: Icons.record_voice_over_rounded,
          title: 'التلاوة والقراء والتحميل المحلي',
          subtitle: 'اختيار الشيخ، السرعة، استيراد ZIP، وتحميل السور',
        ),
        Card(
          elevation: 0,
          color: isDark ? const Color(0xFF1E242C) : const Color(0xFFF6F3EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<QuranReciter>(
                  initialValue: activeReciter,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'القارئ الافتراضي',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  items: kAvailableReciters.map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(
                        '${r.nameArabic} - ${r.subTitle}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _settingsController.setReciter(val.nameArabic);
                      widget.quranModule.audioService.setReciter(val);
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Responsive Playback Speed Section
                const Text('سرعة التلاوة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [0.75, 1.0, 1.25, 1.5, 2.0].map((spd) {
                    final isSel = (config.playbackSpeed - spd).abs() < 0.05;
                    return ChoiceChip(
                      label: Text('${spd}x'),
                      selected: isSel,
                      selectedColor: AppColors.goldAccent,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.black : null,
                      ),
                      onSelected: (val) {
                        if (val) {
                          _settingsController.setPlaybackSpeed(spd);
                          widget.quranModule.audioService.setPlaybackSpeed(spd);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('التمرير التلقائي أثناء التلاوة', style: TextStyle(fontSize: 12)),
                  value: config.autoScroll,
                  activeThumbColor: AppColors.goldAccent,
                  onChanged: (val) => _settingsController.setAutoScroll(val),
                ),

                const Divider(height: 16),

                // Offline Audio Package Management Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF141920) : const Color(0xFFEFECE4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder_zip_rounded, color: AppColors.goldAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'إدارة التلاوات بدون إنترنت للشيخ ${activeReciter.nameArabic}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activeReciter.id == 'abdulbasit_murattal'
                            ? '• المصحف المرتل متوفر محلياً بالكامل (6,350 ملف صوتي)'
                            : (_downloadedFilesCount > 0
                                ? '• الملفات المحفوظة محلياً على جهازك: $_downloadedFilesCount آية'
                                : '• التلاوة تعمل عبر البث المباشر (يمكنك تنزيل سور أو استيراد ZIP)'),
                        style: TextStyle(
                          fontSize: 11,
                          color: _downloadedFilesCount > 0 ? AppColors.goldAccent : Colors.grey,
                          fontWeight: _downloadedFilesCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Action Buttons for ZIP import and Surah download
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Pick & Import ZIP button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldAccent,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            icon: _isImportingZip
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
                                  )
                                : const Icon(Icons.upload_file_rounded, size: 16),
                            label: const Text('استيراد ملف ZIP من جهازك', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: _isImportingZip ? null : () => _handlePickAndImportZip(activeReciter),
                          ),

                          // Download Surahs on-demand button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
                              side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.6)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text('تحميل سور محلياً', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () => _showDownloadSurahsSheet(activeReciter),
                          ),

                          // Delete audio button if files exist
                          if (_downloadedFilesCount > 0)
                            IconButton(
                              icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.error, size: 20),
                              tooltip: 'حذف التلاوات المحلية لتوفير المساحة',
                              onPressed: () => _handleDeleteOfflineAudio(activeReciter),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 6. Section Header: Tajweed & Display Options
        _buildSectionHeader(
          icon: Icons.tune_rounded,
          title: 'خيارات العرض والتجويد',
          subtitle: 'تلوين التجويد وعرض التفسير والكلمات',
        ),
        Card(
          elevation: 0,
          color: isDark ? const Color(0xFF1E242C) : const Color(0xFFF6F3EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('أحكام التجويد الملونة', style: TextStyle(fontSize: 12)),
                subtitle: const Text('تلوين مخارج وأحكام التلاوة بطبقة بصرية راقية', style: TextStyle(fontSize: 10)),
                value: config.showTajweed,
                activeThumbColor: AppColors.goldAccent,
                onChanged: (val) => _settingsController.setShowTajweed(val),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('إظهار التفسير الميسر', style: TextStyle(fontSize: 12)),
                subtitle: const Text('الوصول المباشر لتفسير الآيات', style: TextStyle(fontSize: 10)),
                value: config.showTafsir,
                activeThumbColor: AppColors.goldAccent,
                onChanged: (val) => _settingsController.setShowTafsir(val),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('معاني الكلمات المفردة', style: TextStyle(fontSize: 12)),
                subtitle: const Text('عرض معاني الكلمات الغريبة كلمة بكلمة', style: TextStyle(fontSize: 10)),
                value: config.showWordByWord,
                activeThumbColor: AppColors.goldAccent,
                onChanged: (val) => _settingsController.setShowWordByWord(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 7. Section Header: Bookmarks & Saved Reading Spots
        _buildSectionHeader(
          icon: Icons.bookmark_added_rounded,
          title: 'الفواصل المرجعية المحفوظة',
          subtitle: 'الآيات والمواضع التي قمت بحفظها للرجوع إليها',
        ),
        if (_isLoadingBookmarks)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (_bookmarks.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border_rounded, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text('لا توجد فواصل مرجعية محفوظة حالياً', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          )
        else
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF1E242C) : const Color(0xFFF6F3EC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bookmarks.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final b = _bookmarks[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.bookmark_rounded, color: AppColors.goldAccent, size: 18),
                  title: Text('سورة ${b.surahNameArabic} — آية ${b.ayahNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  subtitle: Text(b.ayahSnippet, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Amiri', fontSize: 11)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                    onPressed: () async {
                      await widget.quranModule.deleteBookmark(b.id);
                      _loadBookmarks();
                    },
                  ),
                  onTap: () => widget.onOpenSurah(b.surahNumber, targetPage: b.pageNumber, targetAyah: b.ayahNumber),
                );
              },
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.goldAccent),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal Sheet allowing the user to download individual Surahs on-demand for offline listening.
class _SurahDownloaderSheet extends StatefulWidget {
  final QuranModule quranModule;
  final QuranReciter reciter;
  final List<Surah> surahs;
  final VoidCallback onDownloadCompleted;

  const _SurahDownloaderSheet({
    required this.quranModule,
    required this.reciter,
    required this.surahs,
    required this.onDownloadCompleted,
  });

  @override
  State<_SurahDownloaderSheet> createState() => _SurahDownloaderSheetState();
}

class _SurahDownloaderSheetState extends State<_SurahDownloaderSheet> {
  final Map<int, bool> _downloadedMap = {};
  int? _activeDownloadingSurah;
  int _downloadedAyahsInCurrentSurah = 0;
  int _totalAyahsInCurrentSurah = 0;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    for (final surah in widget.surahs) {
      final isDone = await widget.quranModule.offlineAudioService.isSurahDownloaded(
        widget.reciter.id,
        surah.number,
        surah.ayahCount,
      );
      if (mounted) {
        setState(() {
          _downloadedMap[surah.number] = isDone;
        });
      }
    }
  }

  Future<void> _startDownload(Surah surah) async {
    setState(() {
      _activeDownloadingSurah = surah.number;
      _downloadedAyahsInCurrentSurah = 0;
      _totalAyahsInCurrentSurah = surah.ayahCount;
      _isCancelled = false;
    });

    await widget.quranModule.offlineAudioService.downloadSurahAudio(
      reciter: widget.reciter,
      surahNumber: surah.number,
      ayahCount: surah.ayahCount,
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _downloadedAyahsInCurrentSurah = current;
            _totalAyahsInCurrentSurah = total;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err), backgroundColor: AppColors.error),
          );
        }
      },
      isCancelled: () => _isCancelled,
    );

    if (mounted) {
      final isDone = await widget.quranModule.offlineAudioService.isSurahDownloaded(
        widget.reciter.id,
        surah.number,
        surah.ayahCount,
      );

      setState(() {
        _downloadedMap[surah.number] = isDone;
        _activeDownloadingSurah = null;
      });

      widget.onDownloadCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2129) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.download_for_offline_rounded, color: AppColors.goldAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تحميل سور كاملة بدون إنترنت', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('القارئ: ${widget.reciter.nameArabic}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    _isCancelled = true;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Surahs List
          Expanded(
            child: ListView.separated(
              itemCount: widget.surahs.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final surah = widget.surahs[index];
                final isDownloaded = _downloadedMap[surah.number] == true;
                final isCurrentDownloading = _activeDownloadingSurah == surah.number;

                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: isDownloaded ? AppColors.goldAccent : Colors.grey.withValues(alpha: 0.2),
                    foregroundColor: isDownloaded ? Colors.black : null,
                    child: Text('${surah.number}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  title: Text('سورة ${surah.nameArabic}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: isCurrentDownloading
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'جارٍ التحميل: آية $_downloadedAyahsInCurrentSurah من $_totalAyahsInCurrentSurah',
                              style: const TextStyle(fontSize: 10, color: AppColors.goldAccent),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: _totalAyahsInCurrentSurah > 0
                                  ? _downloadedAyahsInCurrentSurah / _totalAyahsInCurrentSurah
                                  : 0,
                              color: AppColors.goldAccent,
                              minHeight: 3,
                            ),
                          ],
                        )
                      : Text(
                          '${surah.nameEnglish} • ${surah.ayahCount} آية',
                          style: const TextStyle(fontSize: 11),
                        ),
                  trailing: isDownloaded
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                            SizedBox(width: 4),
                            Text('محمّلة', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : (isCurrentDownloading
                          ? IconButton(
                              icon: const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                              tooltip: 'إلغاء التحميل',
                              onPressed: () {
                                setState(() => _isCancelled = true);
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.download_rounded, color: AppColors.goldAccent, size: 20),
                              tooltip: 'تحميل السورة',
                              onPressed: _activeDownloadingSurah != null ? null : () => _startDownload(surah),
                            )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
