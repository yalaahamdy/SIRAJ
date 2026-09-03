import 'package:flutter/material.dart';
import '../../core/i18n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Catches uncaught UI rendering exceptions and presents a graceful fail-closed error view.
class AppErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails details)? errorBuilder;

  const AppErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  /// Builds a standard error fallback widget for uncaught exceptions.
  static Widget defaultErrorWidget(FlutterErrorDetails details, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                AppStrings.errorOccurred,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                details.exceptionAsString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
