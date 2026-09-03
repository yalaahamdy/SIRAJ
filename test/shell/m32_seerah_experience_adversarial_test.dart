import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/domain/canonical_seerah_package.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Adversarial Suite (§115, §116)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Adversarial 1: Package with invalid/empty signature is rejected (fail-closed)', () {
      final invalidPkg = CanonicalSeerahPackage.create(
        packageId: 'pkg_tampered_seerah',
        periods: [],
        events: [],
        persons: [],
        relationships: [],
        places: [],
        signerIdentity: '',
        signature: '',
        publishedAt: DateTime.utc(2026, 8, 31),
      );

      final unmountedModule = SeerahModule(storageRegistry: storage);
      final res = unmountedModule.mountPackage(invalidPkg);
      expect(res.isSuccess, isFalse);
    });

    test('Adversarial 2: User notes cannot mutate canonical event content', () async {
      await seerahModule.saveUserNote('evt_badr_major', 'ملاحظة تحاول تغيير المتن التاريخي');

      final event = seerahModule.getEvent('evt_badr_major').valueOrNull!;
      expect(event.summary, contains('أول معركة فاصلة في الإسلام'));
      expect(event.summary, isNot(contains('ملاحظة تحاول')));
    });

    test('Adversarial 3: Cross-Module Shield — Seerah operations never mutate Quran store', () async {
      await seerahModule.markEventViewed('evt_badr_major');
      await seerahModule.saveUserNote('evt_badr_major', 'note');

      final quranRes = await storage.getStoreForModule('mod_quran').getString('user_seerah_progress');
      expect(quranRes.valueOrNull, isNull);
    });

    testWidgets('Adversarial 4: Invalid deep link /seerah/unknown loads safe fallback error page', (tester) async {
      AppRouter.defaultSeerahModule = seerahModule;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/seerah/invalid_subroute_path',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط المطلوب للسيرة والتاريخ الإسلامي غير صالح'), findsOneWidget);
      expect(find.text('العودة للسيرة'), findsOneWidget);
    });
  });
}
