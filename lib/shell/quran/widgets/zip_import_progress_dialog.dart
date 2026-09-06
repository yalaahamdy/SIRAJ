import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// State representation of an ongoing ZIP audio extraction and import process.
class ZipImportProgressState {
  final int current;
  final int total;
  final String currentFileName;
  final bool isCompleted;
  final String? errorMessage;
  final int successCount;

  const ZipImportProgressState({
    this.current = 0,
    this.total = 0,
    this.currentFileName = '',
    this.isCompleted = false,
    this.errorMessage,
    this.successCount = 0,
  });

  double get progress => total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
  int get remaining => total > current ? total - current : 0;
}

/// Modal dialog showing real-time extraction progress and remaining files count for ZIP imports.
class ZipImportProgressDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Future<int?> Function(void Function(int current, int total, String fileName) onProgress) task;

  const ZipImportProgressDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.task,
  });

  static Future<int?> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Future<int?> Function(void Function(int current, int total, String fileName) onProgress) task,
  }) {
    return showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ZipImportProgressDialog(
        title: title,
        subtitle: subtitle,
        task: task,
      ),
    );
  }

  @override
  State<ZipImportProgressDialog> createState() => _ZipImportProgressDialogState();
}

class _ZipImportProgressDialogState extends State<ZipImportProgressDialog> {
  ZipImportProgressState _state = const ZipImportProgressState();

  @override
  void initState() {
    super.initState();
    _startTask();
  }

  Future<void> _startTask() async {
    try {
      final successCount = await widget.task((current, total, fileName) {
        if (mounted) {
          setState(() {
            _state = ZipImportProgressState(
              current: current,
              total: total,
              currentFileName: fileName,
            );
          });
        }
      });

      if (mounted) {
        setState(() {
          _state = ZipImportProgressState(
            current: _state.total,
            total: _state.total,
            isCompleted: true,
            successCount: successCount ?? _state.current,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ZipImportProgressState(
            isCompleted: true,
            errorMessage: e.toString(),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _state.isCompleted,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (_state.errorMessage != null
                        ? AppColors.error
                        : (_state.isCompleted ? Colors.green : AppColors.goldAccent))
                    .withValues(alpha: 0.15),
              ),
              child: Icon(
                _state.errorMessage != null
                    ? Icons.error_outline_rounded
                    : (_state.isCompleted ? Icons.check_circle_rounded : Icons.folder_zip_rounded),
                color: _state.errorMessage != null
                    ? AppColors.error
                    : (_state.isCompleted ? Colors.green : AppColors.goldAccent),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _state.errorMessage != null
                    ? 'تعذر استيراد الملف'
                    : (_state.isCompleted ? 'تم الاستيراد بنجاح' : widget.title),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_state.errorMessage != null) ...[
              Text(
                'حدث خطأ أثناء فك ضغط ملف الـ ZIP:\n${_state.errorMessage}',
                style: const TextStyle(fontSize: 13, color: AppColors.error),
              ),
            ] else if (_state.isCompleted) ...[
              Text(
                'تم استخراج واستيراد ${_state.successCount} ملفاً صوتياً بنجاح!\nالملفات متاحة الآن للاستماع بدون إنترنت.',
                style: const TextStyle(fontSize: 13.5, height: 1.5),
              ),
            ] else ...[
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _state.total > 0 ? _state.progress : null,
                  backgroundColor: isDark ? Colors.white10 : Colors.black12,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),

              // Numeric and Percentage Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _state.total > 0
                        ? 'تم استخراج ${_state.current} من أصل ${_state.total} ملفاً'
                        : 'جارٍ قراءة وفحص ملف الـ ZIP...',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  if (_state.total > 0)
                    Text(
                      '${(_state.progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),

              // Remaining count
              if (_state.total > 0)
                Text(
                  'المتبقي: ${_state.remaining} ملفاً',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),

              if (_state.currentFileName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'الملف الحالي: ${_state.currentFileName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ],
        ),
        actions: [
          if (_state.isCompleted)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(_state.successCount),
              child: const Text('تم'),
            ),
        ],
      ),
    );
  }
}
