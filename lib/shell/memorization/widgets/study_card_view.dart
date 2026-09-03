import 'package:flutter/material.dart';
import '../../../../modules/memorization/domain/review_quality.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Interactive study card rendering the Ayah under recall test with hide/reveal controls (§10..§15, §37, §86, §114).
class StudyCardView extends StatefulWidget {
  final Ayah ayah;
  final String surahNameArabic;
  final ValueChanged<ReviewQuality> onRate;
  final VoidCallback? onOpenInQuran;

  const StudyCardView({
    super.key,
    required this.ayah,
    required this.surahNameArabic,
    required this.onRate,
    this.onOpenInQuran,
  });

  @override
  State<StudyCardView> createState() => _StudyCardViewState();
}

class _StudyCardViewState extends State<StudyCardView> {
  bool _isRevealed = false;

  @override
  void didUpdateWidget(covariant StudyCardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ayah.key != widget.ayah.key) {
      _isRevealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLarge),
      margin: const EdgeInsets.all(AppSpacing.m),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Surah & Ayah Badge + Open in Quran Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.surfaceDark : AppColors.primary).withValues(alpha: 0.15),
                    borderRadius: AppRadius.radiusSmall,
                  ),
                  child: Text(
                    'سورة ${widget.surahNameArabic} — الآية ${widget.ayah.ayahNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldAccent : AppColors.primary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'صفحة ${widget.ayah.pageNumber}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (widget.onOpenInQuran != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.menu_book_rounded, size: 20),
                        tooltip: 'عرض في المصحف الشريف',
                        onPressed: widget.onOpenInQuran,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),

            // Content Area (Hidden vs Revealed)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: _isRevealed
                      ? Text(
                          widget.ayah.textUthmani,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            height: 2.2,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility_off_outlined,
                              size: 48,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            Text(
                              'استدعِ الآية في ذاكرتك ثم اضغط للتحقق',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.l),
                            ElevatedButton.icon(
                              onPressed: () => setState(() => _isRevealed = true),
                              icon: const Icon(Icons.visibility_rounded),
                              label: const Text('إظهار الآية والتحقق'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Self-Assessment Bar (Visible only when revealed)
            if (_isRevealed) ...[
              const Divider(),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'ما مدى سهولة استدعائك للآية؟',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'يُستخدم التقييم لتحديد موعد المراجعة القادمة وفق خوارزمية التكرار المتباعد',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Row(
                children: [
                  Expanded(
                    child: _buildQualityBtn(
                      label: 'إعادة',
                      quality: ReviewQuality.again,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildQualityBtn(
                      label: 'صعب',
                      quality: ReviewQuality.hard,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildQualityBtn(
                      label: 'جيد',
                      quality: ReviewQuality.good,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildQualityBtn(
                      label: 'سهل',
                      quality: ReviewQuality.easy,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQualityBtn({
    required String label,
    required ReviewQuality quality,
    required Color color,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSmall,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
        ),
      ),
      onPressed: () => widget.onRate(quality),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
