import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../modules/quran/services/tawasheeh_offline_audio_service.dart';
import '../../../../modules/quran/store/tawasheeh_store.dart';
import '../../theme/app_colors.dart';
import 'zip_import_progress_dialog.dart';

/// Interactive offline storage & ZIP import action bar for Tawasheeh (§14, §20).
class TawasheehOfflineActionBar extends StatefulWidget {
  final TawasheehStore tawasheehStore;
  final VoidCallback onDataChanged;

  const TawasheehOfflineActionBar({
    super.key,
    required this.tawasheehStore,
    required this.onDataChanged,
  });

  @override
  State<TawasheehOfflineActionBar> createState() => _TawasheehOfflineActionBarState();
}

class _TawasheehOfflineActionBarState extends State<TawasheehOfflineActionBar> {
  int _downloadedCount = 0;
  bool _isImporting = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _refreshCount();
  }

  Future<void> _refreshCount() async {
    final count = await TawasheehOfflineAudioService.instance.getDownloadedCount();
    if (mounted) {
      setState(() => _downloadedCount = count);
    }
  }

  Future<void> _handlePickAndImportZip() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      dialogTitle: 'اختر ملف ZIP يحتوي على التواشيح والابتهالات',
    );

    if (files.isEmpty || files.first.path == null) return;
    final zipFilePath = files.first.path!;
    if (!mounted) return;

    await ZipImportProgressDialog.show(
      context: context,
      title: 'استيراد التواشيح والابتهالات',
      subtitle: 'جارٍ فك ضغط ملف الـ ZIP واستخراج الابتهالات...',
      task: (onProgress) async {
        final res = await TawasheehOfflineAudioService.instance.importZipFile(
          zipFilePath: zipFilePath,
          store: widget.tawasheehStore,
          onProgress: onProgress,
        );
        if (!res.isSuccess) {
          throw Exception(res.errorMessage ?? 'تعذر فك ضغط ملف الـ ZIP');
        }
        return res.importedTracksCount;
      },
    );

    if (mounted) {
      await _refreshCount();
      widget.onDataChanged();
    }
  }

  Future<void> _handlePickAudioFiles() async {
    setState(() => _isImporting = true);

    try {
      final res = await TawasheehOfflineAudioService.instance.pickAndImportAudioFiles(
        store: widget.tawasheehStore,
      );
      if (!mounted) return;
      setState(() => _isImporting = false);

      if (res == null) return;

      if (res.isSuccess) {
        await _refreshCount();
        widget.onDataChanged();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت إضافة ${res.importedTracksCount} تسجيلاً بنجاح إلى التواشيح!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.errorMessage ?? 'تعذر استيراد الملفات الصوتية.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ أثناء اختيار الملفات: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleClearOffline() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف التسجيلات المحلية؟'),
        content: const Text(
          'سيتم حذف جميع ملفات التواشيح المحملة على الجهاز لتوفير المساحة. يمكنك إعادة تنزيلها أو استيرادها لاحقاً.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await TawasheehOfflineAudioService.instance.deleteOfflineTawasheeh(
        store: widget.tawasheehStore,
      );
      await _refreshCount();
      widget.onDataChanged();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف التسجيلات المحلية بنجاح.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161E2E) : const Color(0xFFF7F4EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: isDark ? 0.3 : 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar (always visible, tap to expand/collapse)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: [
                  Icon(
                    _downloadedCount > 0
                        ? Icons.offline_pin_rounded
                        : Icons.cloud_download_outlined,
                    size: 18,
                    color: _downloadedCount > 0 ? Colors.green : AppColors.goldAccent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _downloadedCount > 0
                          ? 'التخزين المحلي (محمّل: $_downloadedCount تسجيلاً)'
                          : 'التخزين المحلي واستيراد ZIP',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _downloadedCount > 0
                            ? (isDark ? Colors.greenAccent : Colors.green.shade800)
                            : null,
                      ),
                    ),
                  ),
                  if (_downloadedCount > 0) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: AppColors.error),
                      tooltip: 'حذف التسجيلات المحلية لتوفير المساحة',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      onPressed: _handleClearOffline,
                    ),
                    const SizedBox(width: 4),
                  ],
                  // Expand / Collapse Toggle Icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'إخفاء' : 'إدارة',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.goldAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Action Buttons Body
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Import ZIP Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldAccent,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: _isImporting
                            ? const SizedBox(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
                              )
                            : const Icon(Icons.folder_zip_rounded, size: 15),
                        label: const Text(
                          'استيراد ملف ZIP من جهازك',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _isImporting ? null : _handlePickAndImportZip,
                      ),

                      // Pick Individual Audio Files Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
                          side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.audio_file_rounded, size: 15),
                        label: const Text(
                          'إضافة ملفات صوتية',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _isImporting ? null : _handlePickAudioFiles,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
