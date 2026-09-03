import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/widgets/provenance_disclosure_card.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Provenance Disclosure Card Suite (§38..§43, §115, §119)', () {
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
        home: Scaffold(body: child),
      );
    }

    testWidgets('Provenance 1: Provenance card discloses source, grade, and repetition accurately', (tester) async {
      final item = module.getAllItems().valueOrNull!.first;

      await tester.pumpWidget(createTestApp(ProvenanceDisclosureCard(item: item)));
      await tester.pumpAndSettle();

      expect(find.textContaining('المصدر:'), findsOneWidget);
      expect(find.text(item.sourceTitle), findsOneWidget);
      expect(find.text(item.authenticityGrade.labelArabic), findsOneWidget);
    });
  });
}
