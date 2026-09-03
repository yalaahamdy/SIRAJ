import 'package:flutter/material.dart';
import '../../core/i18n/app_strings.dart';
import '../../platform/content/domain/content_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Loading indicator view.
class LoadingStateView extends StatelessWidget {
  final String? message;

  const LoadingStateView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.m),
          Text(
            message ?? AppStrings.loading,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Empty state placeholder view.
class EmptyStateView extends StatelessWidget {
  final String? message;
  final IconData icon;

  const EmptyStateView({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: AppSpacing.m),
            Text(
              message ?? AppStrings.emptyState,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Non-intrusive banner indicating offline status.
/// Completely silenced to prevent intrusive UI banners across the application.
class OfflineStateBanner extends StatelessWidget {
  const OfflineStateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Standard UI container for displaying verified canonical content records.
/// Visualizes source citations, attributions, and grades according to SACRED_CONTENT_POLICY.md §7.
class SacredContentView extends StatelessWidget {
  final ContentRecord record;

  const SacredContentView({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: isDark ? AppColors.sacredFrameDark : AppColors.sacredFrameLight,
        borderRadius: AppRadius.radiusMedium,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.sacredBorder,
          width: 1.2,
        ),
      ),
      padding: AppSpacing.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text Payload formatted with sacred typography
          Text(
            record.text,
            style: AppTypography.sacredText(isDark),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.m),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.s),

          // Attribution / Grade row
          if (record.attribution != null || record.grade != null)
            Row(
              children: [
                if (record.attribution != null)
                  Chip(
                    label: Text(record.attribution!.to),
                    backgroundColor: AppColors.goldAccent.withValues(alpha: 0.15),
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    visualDensity: VisualDensity.compact,
                  ),
                if (record.grade != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Chip(
                    label: Text('${record.grade!.gradeValue} (${record.grade!.givenBy})'),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),

          // Authentic Source References
          if (record.sources.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                '${AppStrings.sourceLabel}: ${record.sources.map((s) => s.reference).join(' • ')}',
                style: AppTypography.bodySmall(isDark),
                textDirection: TextDirection.rtl,
              ),
            ),
        ],
      ),
    );
  }
}
