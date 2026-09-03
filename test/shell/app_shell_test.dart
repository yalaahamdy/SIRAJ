import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/config/app_config.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/i18n/locale_manager.dart';
import 'package:siraj/shell/siraj_app.dart';
import 'package:siraj/shell/widgets/error_boundary.dart';
import 'package:siraj/shell/widgets/state_views.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L4 App Shell UI Foundation Tests', () {
    testWidgets('SirajApp bootstraps with Arabic RTL directionality and default Home view', (tester) async {
      final config = AppConfig.test();
      final localeManager = LocaleManager();

      await tester.pumpWidget(
        SirajApp(
          config: config,
          localeManager: localeManager,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.byType(OfflineStateBanner), findsOneWidget);
      expect(find.text(AppStrings.offlineNotice), findsNothing);

      // Verify RTL text direction
      final directionality = tester.widget<Directionality>(find.byType(Directionality).first);
      expect(directionality.textDirection, equals(TextDirection.rtl));
    });

    testWidgets('SacredContentView renders canonical record with source citation badge', (tester) async {
      final record = SyntheticFixtures.createSyntheticRecord(
        contentId: 'UI-TEST-001',
        text: 'SYNTHETIC_DISPLAY_TEXT',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SacredContentView(record: record),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SYNTHETIC_DISPLAY_TEXT'), findsOneWidget);
      expect(find.textContaining(AppStrings.sourceLabel), findsOneWidget);
      expect(find.textContaining('Synthetic Verification Manual'), findsOneWidget);
    });

    testWidgets('AppErrorBoundary renders defaultErrorWidget gracefully', (tester) async {
      final details = FlutterErrorDetails(
        exception: Exception('Simulated test error'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => AppErrorBoundary.defaultErrorWidget(details, context),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.errorOccurred), findsOneWidget);
      expect(find.textContaining('Simulated test error'), findsOneWidget);
    });
  });
}
