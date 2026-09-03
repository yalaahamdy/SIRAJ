import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Professional contextual bottom sheet for deep interactions with an Ayah (§18, §19).
class AyahActionBottomSheet extends StatelessWidget {
  final Ayah ayah;
  final Surah surah;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onMemorize;
  final VoidCallback? onPlay;
  final VoidCallback? onTafsir;
  final VoidCallback? onSelectRange;
  final VoidCallback? onWordByWord;

  const AyahActionBottomSheet({
    super.key,
    required this.ayah,
    required this.surah,
    required this.isBookmarked,
    required this.onToggleBookmark,
    required this.onMemorize,
    this.onPlay,
    this.onTafsir,
    this.onSelectRange,
    this.onWordByWord,
  });

  void _copyAyahText(BuildContext context) {
    final textToCopy = '${ayah.textUthmani}\n[سورة ${surah.nameArabic}: الآية ${ayah.ayahNumber}]';
    Clipboard.setData(ClipboardData(text: textToCopy));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ نص الآية الشريفة مع الإسناد'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareAyahReference(BuildContext context) {
    final reference = 'قال تعالى: "${ayah.textUthmani}" [سورة ${surah.nameArabic}: ${ayah.ayahNumber}] — مصحف المدينة النبوية (مجمع الملك فهد)';
    Clipboard.setData(ClipboardData(text: reference));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تجهيز مرجع الآية الموثق للمشاركة والنسخ'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF181C22) : const Color(0xFFFAF8F5);

    return Container(
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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سورة ${surah.nameArabic} — الآية ${ayah.ayahNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'الجزء ${ayah.juzNumber} • الحزب ${ayah.hizbNumber} • الربع ${ayah.rubNumber} • ص ${ayah.pageNumber}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),

            // Ayah Preview Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : AppColors.primaryLight).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: (isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: Text(
                ayah.textUthmani,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontFamily: 'Amiri', fontSize: 16, height: 1.8),
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Primary Actions
            if (onPlay != null)
              ListTile(
                leading: const Icon(Icons.play_circle_fill_rounded, color: AppColors.goldAccent),
                title: const Text('تلاوة الآية الشريفة'),
                onTap: () {
                  Navigator.pop(context);
                  onPlay!();
                },
              ),
            if (onTafsir != null)
              ListTile(
                leading: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                title: const Text('التفسير الميسر المعتمد'),
                onTap: () {
                  Navigator.pop(context);
                  onTafsir!();
                },
              ),
            ListTile(
              leading: Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: AppColors.goldAccent,
              ),
              title: Text(isBookmarked ? 'إزالة الفاصل المرجعي' : 'حفظ كفاصل مرجعي'),
              onTap: () {
                Navigator.pop(context);
                onToggleBookmark();
              },
            ),
            if (onSelectRange != null)
              ListTile(
                leading: const Icon(Icons.linear_scale_rounded, color: AppColors.primary),
                title: const Text('تحديد نطاق آيات (Select Range)'),
                onTap: () {
                  Navigator.pop(context);
                  onSelectRange!();
                },
              ),
            if (onWordByWord != null)
              ListTile(
                leading: const Icon(Icons.translate_rounded, color: AppColors.primary),
                title: const Text('بيان معاني الكلمات والمفردات'),
                onTap: () {
                  Navigator.pop(context);
                  onWordByWord!();
                },
              ),
            ListTile(
              leading: const Icon(Icons.copy_rounded, color: AppColors.primary),
              title: const Text('نسخ نص الآية مع التوثيق'),
              onTap: () => _copyAyahText(context),
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded, color: AppColors.primary),
              title: const Text('مشاركة مرجع الآية الشريفة'),
              onTap: () => _shareAyahReference(context),
            ),
            ListTile(
              leading: const Icon(Icons.psychology_rounded, color: AppColors.primary),
              title: const Text('إضافة إلى خطة التحفيظ والتكرار المتباعد'),
              onTap: () {
                Navigator.pop(context);
                onMemorize();
              },
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    ),
  );
}
}
