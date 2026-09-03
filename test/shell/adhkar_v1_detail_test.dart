import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Dhikr Detail & Display Fidelity Suite (§10..§15, §85, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
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

    testWidgets('Detail 1: Renders canonical text with full diacritics and provenance hierarchy (§11..§14)', (tester) async {
      final item = module.getAllItems().valueOrNull!.first;

      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item, module: module)));
      await tester.pumpAndSettle();

      // Text
      expect(find.text(item.textArabic), findsOneWidget);
      // Provenance & Source
      expect(find.textContaining('المصدر:'), findsWidgets);
    });
  });
}
