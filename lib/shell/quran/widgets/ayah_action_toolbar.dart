import 'package:flutter/material.dart';
import '../controllers/ayah_selection_controller.dart';
import '../../theme/app_colors.dart';

/// Floating, compact minimal action toolbar displayed upon Ayah selection (§5, §6).
/// Displays strictly: [تلاوة] [تفسير] [فاصل] [المزيد] to maximize reading area.
class AyahActionToolbar extends StatelessWidget {
  final AyahSelectionController controller;
  final VoidCallback onPlay;
  final VoidCallback onTafsir;
  final VoidCallback onBookmark;
  final VoidCallback onMore;
  final VoidCallback onClose;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const AyahActionToolbar({
    super.key,
    required this.controller,
    required this.onPlay,
    required this.onTafsir,
    required this.onBookmark,
    required this.onMore,
    required this.onClose,
    this.onCopy,
    this.onShare,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRange = controller.isRangeSelection;

    final titleText = isRange
        ? '${controller.rangeStart}-${controller.rangeEnd}'
        : '${controller.selectedAyah}';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1B2028).withValues(alpha: 0.96)
              : Colors.white.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ayah Number Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'الآية $titleText',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldAccent,
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // 1. Play Action
              _ToolbarButton(
                icon: Icons.play_arrow_rounded,
                label: 'تلاوة',
                onPressed: onPlay,
                isPrimary: true,
              ),

              // 2. Tafsir Action
              _ToolbarButton(
                icon: Icons.menu_book_rounded,
                label: 'تفسير',
                onPressed: onTafsir,
              ),

              // 3. Bookmark Action
              _ToolbarButton(
                icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                label: 'فاصل',
                onPressed: onBookmark,
                color: isBookmarked ? AppColors.goldAccent : null,
              ),

              // 4. Optional Copy Action
              if (onCopy != null)
                _ToolbarButton(
                  icon: Icons.copy_rounded,
                  label: 'نسخ',
                  onPressed: onCopy!,
                ),

              // 5. Optional Share Action
              if (onShare != null)
                _ToolbarButton(
                  icon: Icons.share_rounded,
                  label: 'مشاركة',
                  onPressed: onShare!,
                ),

              // 6. More Action (opens bottom sheet)
              _ToolbarButton(
                icon: Icons.more_horiz_rounded,
                label: 'المزيد',
                onPressed: onMore,
              ),

              const SizedBox(width: 2),

              // Dismiss Button
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: 'إغلاق التحديد',
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? color;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? (isPrimary ? AppColors.goldAccent : null);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: effectiveColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
