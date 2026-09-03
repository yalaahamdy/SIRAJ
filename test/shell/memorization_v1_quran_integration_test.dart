import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/widgets/study_card_view.dart';
import 'package:siraj/shell/quran/widgets/ayah_action_bottom_sheet.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Quran -> Memorization Integration & Fidelity Suite (§3..§5, §51, §100, §101)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      );
    }

    testWidgets('Integration 1: Ayah action sheet offers Memorization linking with exact AyahKey', (tester) async {
      final surah = quranModule.store.getSurah(1).valueOrNull!;
      final ayah = quranModule.store.getAyah(1, 1).valueOrNull!;
      bool memorized = false;

      await tester.pumpWidget(
        createTestApp(
          AyahActionBottomSheet(
            ayah: ayah,
            surah: surah,
            isBookmarked: false,
            onToggleBookmark: () {},
            onMemorize: () => memorized = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final memTile = find.text('إضافة إلى خطة التحفيظ والتكرار المتباعد');
      expect(memTile, findsOneWidget);

      await tester.tap(memTile);
      expect(memorized, isTrue);
    });

    testWidgets('Integration 2 (Display Fidelity): Revealed Ayah in StudyCardView matches canonical store bit-for-bit', (tester) async {
      final ayah = quranModule.store.getAyah(1, 1).valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          StudyCardView(
            ayah: ayah,
            surahNameArabic: 'الفاتحة',
            onRate: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap reveal
      await tester.tap(find.text('إظهار الآية والتحقق'));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      final renderedText = textWidgets.firstWhere((t) => t.data == ayah.textUthmani);

      expect(renderedText.data, equals(ayah.textUthmani));
      expect(renderedText.data!.runes.toList(), equals(ayah.textUthmani.runes.toList()));
    });
  });
}
