import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Reset & Isolated Data Clear Suite (§62..§64, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;
    late QuranModule quranModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
      quranModule = QuranModule(storageRegistry: registry);
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: child,
      );
    }

    testWidgets('Reset 1: Reset dialog confirms and clears local zakat data only without affecting other modules', (tester) async {
      // 1. Populate Zakat data
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(title: 'أصل قبل الضبط', amount: 50000.0),
      );

      // 2. Populate Quran data
      await quranModule.userDataService.updateProgress(
        surahNumber: 2,
        ayahNumber: 255,
        pageNumber: 42,
        surahNameArabic: 'البقرة',
      );

      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('أصل قبل الضبط'), findsOneWidget);

      // 3. Trigger reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.text('إعادة ضبط بيانات الزكاة'), findsOneWidget);
      expect(find.textContaining('سيتم حذف بيانات الزكاة والأصول المحفوظة فقط'), findsOneWidget);

      await tester.tap(find.text('إعادة الضبط'));
      await tester.pumpAndSettle();

      // 4. Verify Zakat data is cleared
      expect(find.text('لم تقم بإضافة أي أصول مالية بعد'), findsOneWidget);
      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.isEmpty, true);

      // 5. Verify Quran canonical/user data remains intact (§64)
      final progress = await quranModule.userDataService.getProgress();
      expect(progress.isSuccess, true);
      expect(progress.valueOrNull!.lastReadSurah, 2);
      expect(progress.valueOrNull!.lastReadAyah, 255);
    });
  });
}
