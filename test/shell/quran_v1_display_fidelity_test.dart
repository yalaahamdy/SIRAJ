import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Display Fidelity Forensic Suite (§12..§15, §83)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
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
        home: child,
      );
    }

    testWidgets('Display Fidelity: Canonical Uthmani text reaches Text widget bit-for-bit without mutation', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final ayahsRes = quranModule.getSurahAyahs(1);
      expect(ayahsRes.isSuccess, isTrue);
      final canonicalAyahs = ayahsRes.valueOrNull!;

      // Find all AyahView widgets in reader
      final ayahViews = tester.widgetList<AyahView>(find.byType(AyahView)).toList();
      expect(ayahViews.length, equals(canonicalAyahs.length));

      for (int i = 0; i < canonicalAyahs.length; i++) {
        final canonicalAyah = canonicalAyahs[i];
        final view = ayahViews[i];

        // 1. Ayah object identity & key match
        expect(view.ayah.key, equals(canonicalAyah.key));

        // 2. Exact string match (No stripping, normalization, or punctuation mutation)
        expect(view.ayah.textUthmani, equals(canonicalAyah.textUthmani));
        expect(view.ayah.textUthmani.runes.toList(), equals(canonicalAyah.textUthmani.runes.toList()));

        // 3. Exact hash integrity verification
        expect(Ayah.computeHash(view.ayah.textUthmani), equals(canonicalAyah.integrityHash));
      }
    });

    testWidgets('Display Fidelity: Surah 114 (An-Nas) displays all canonical verses in exact order', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 114,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final ayahsRes = quranModule.getSurahAyahs(114);
      expect(ayahsRes.isSuccess, isTrue);
      final canonicalAyahs = ayahsRes.valueOrNull!;

      final ayahViews = tester.widgetList<AyahView>(find.byType(AyahView)).toList();
      expect(ayahViews.length, equals(canonicalAyahs.length));

      for (int i = 0; i < canonicalAyahs.length; i++) {
        expect(ayahViews[i].ayah.ayahNumber, equals(i + 1));
        expect(ayahViews[i].ayah.textUthmani, equals(canonicalAyahs[i].textUthmani));
      }
    });
  });
}
