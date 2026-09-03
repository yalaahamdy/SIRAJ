import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import 'package:siraj/shell/adhkar/widgets/provenance_disclosure_card.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Scholarly Provenance & Attribution Suite (§12..§15, §47, §48, §90)', () {
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

    testWidgets('Provenance Flow: Provenance card displays authentic source, author, reference and grade', (tester) async {
      final itemsRes = module.getAllItems();
      expect(itemsRes.isSuccess, isTrue);
      final item = itemsRes.valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          DhikrDetailScreen(
            item: item,
            module: module,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProvenanceDisclosureCard), findsOneWidget);
      expect(find.text('توثيق وتخريج الذكر'), findsOneWidget);
      expect(find.text(item.sourceTitle), findsWidgets);
      expect(find.text(item.sourceAuthor), findsWidgets);
      expect(find.text(item.reference), findsWidgets);
      expect(find.text(item.attribution), findsWidgets);
      expect(find.text(item.authenticityGrade.labelArabic), findsWidgets);
    });
  });
}
