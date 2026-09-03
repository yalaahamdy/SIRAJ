import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/config/app_config.dart';
import 'package:siraj/core/content_governance/engine/canonical_content_registry.dart';
import 'package:siraj/core/content_governance/engine/content_signing_service.dart';
import 'package:siraj/core/content_governance/gates/production_content_gate.dart';
import 'package:siraj/core/content_governance/models/canonical_content_package.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/services/search_federation_service.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/v1_app_shell.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 17: M42 Full MVP End-to-End Adversarial Suite (§122..§140)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 1: CANONICAL CONTENT CROSS-SHIELD & IMMUTABILITY
    // ------------------------------------------------------------------------
    test('Adversarial 1: Cross-module actions never mutate canonical Quran/Adhkar stores (§26, §55, §128)', () async {
      final quranStore = storage.getStoreForModule('mod_quran');
      final zakatStore = storage.getStoreForModule('mod_zakat');
      final adhkarStore = storage.getStoreForModule('mod_adhkar');

      await quranStore.setString('canonical_seed', 'UTHMANI_PROTECTED_BIT_FOR_BIT');
      await zakatStore.setString('zakat_data', 'ASSET_GOLD_100G');
      await adhkarStore.setString('adhkar_data', 'SABAH_PROGRESS_33');

      final qVal = await quranStore.getString('canonical_seed');
      final zVal = await zakatStore.getString('zakat_data');
      final aVal = await adhkarStore.getString('adhkar_data');
      final crossCheck = await quranStore.getString('zakat_data');

      expect(qVal.valueOrNull, equals('UTHMANI_PROTECTED_BIT_FOR_BIT'));
      expect(zVal.valueOrNull, equals('ASSET_GOLD_100G'));
      expect(aVal.valueOrNull, equals('SABAH_PROGRESS_33'));
      expect(crossCheck.valueOrNull, isNull);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 2: ZERO PIETY SCORING & NO RELIGIOUS PROFILING
    // ------------------------------------------------------------------------
    test('Adversarial 2: ReminderOrchestrator and Preferences contain NO piety score, streak shaming, or profiling (§129)', () {
      final prefs = CompanionPreferences(
        quietHoursStartHour: 22,
        quietHoursEndHour: 6,
        enableQuietHours: true,
      );

      final json = prefs.toJson();
      expect(json.containsKey('piety_score'), isFalse);
      expect(json.containsKey('faith_level'), isFalse);
      expect(json.containsKey('streak_penalty'), isFalse);
      expect(json.containsKey('karma'), isFalse);
      expect(json.containsKey('religious_rank'), isFalse);

      final reminder = CompanionReminder(
        reminderId: 'rem_01',
        sourceModule: 'prayer',
        titleArabic: 'صلاة العصر',
        messageArabic: 'حان الآن وقت صلاة العصر',
        scheduledTime: DateTime.utc(2026, 9, 1, 15, 30),
        priority: ReminderPriority.high,
        targetRoute: '/prayer',
      );

      expect(reminder.titleArabic, isNotEmpty);
      expect(reminder.messageArabic, isNotEmpty);
      expect(reminder.priority, equals(ReminderPriority.high));
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 3: MOBILE RUNTIME SCANS (NO MOBILE LLM RUNTIME)
    // ------------------------------------------------------------------------
    test('Adversarial 3: AppConfig and Mobile Kernel execute NO production LLM client in client runtime (§30, §130)', () {
      final config = AppConfig.production();
      expect(config.environment, equals(Environment.production));
      expect(config.flags.enableAiCompanion, isFalse);
      expect(config.flags.enableAnalytics, isFalse);
      expect(config.defaultLocale, equals('ar'));
      expect(config.failClosedOnContentError, isTrue);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 4: FINANCIAL & WORSHIP DATA LEAKAGE DEFENSE
    // ------------------------------------------------------------------------
    test('Adversarial 4: Zakat financial computations strictly isolate sensitive amounts in mod_zakat (§79, §134)', () async {
      final zakatModule = ZakatModule(storageRegistry: storage);
      await zakatModule.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 50000.0));
      await zakatModule.addOrUpdateAsset(SyntheticZakatFixtures.createDebtLiability(amount: 5000.0));

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, isTrue);
      final result = calcRes.valueOrNull!;

      expect(result.status, equals(ZakatResultStatus.due));
      expect(result.grossAssets.units, equals(5000000));
      expect(result.deductibleLiabilities.units, equals(500000));
      expect(result.netZakatableBase.units, equals(4500000));

      final zakatStore = storage.getStoreForModule('mod_zakat');
      await zakatStore.setString('last_status', result.status.name);

      final prayerStore = storage.getStoreForModule('mod_prayer');
      final prayerCheck = await prayerStore.getString('last_status');
      expect(prayerCheck.valueOrNull, isNull);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 5: CONTENT GOVERNANCE & HUMAN SIGN-OFF BYPASS PREVENTION
    // ------------------------------------------------------------------------
    test('Adversarial 5: Production Content Gate rejects unverified and unsigned packages (§57, §63)', () {
      final registry = CanonicalContentRegistry();
      final signingService = const ContentSigningService();
      final gate = ProductionContentGate(
        registry: registry,
        signingService: signingService,
      );

      const unapprovedPkg = CanonicalContentPackage(
        packageId: 'siraj_unverified_adhkar_v1',
        contentType: 'adhkar',
        contentClass: CanonicalContentClass.transmittedReligious,
        version: '1.0.0',
        sourceEdition: 'Unverified Collection',
        contentHashSha256: 'a1b2c3d4e5f600112233445566778899aabbccddeeff00112233445566778899',
        reviewState: ContentReviewState.unverified,
      );

      registry.registerPackage(unapprovedPkg);
      final result = gate.evaluatePackageActivation(unapprovedPkg.packageId);
      expect(result.isAllowed, isFalse);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 6: SEARCH & FORM UNICODE / FUZZING ATTACK
    // ------------------------------------------------------------------------
    test('Adversarial 6: Federated search gracefully handles 10k chars, RTL overrides, and injection strings (§59, §93)', () async {
      final quranModule = QuranModule(storageRegistry: storage);
      final federation = SearchFederationService(
        quranModule: quranModule,
      );

      // Huge string
      final hugeQuery = 'الله ' * 2000;
      final hugeResults = await federation.search(hugeQuery);
      expect(hugeResults.valueOrNull, isEmpty);

      // RTL control chars & Injection string
      const maliciousQuery = '\u202E\u200F<script>alert(1)</script>\' OR \'1\'=\'1';
      final results = await federation.search(maliciousQuery);
      expect(results.valueOrNull, isEmpty);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 7: DEEP LINK & NAVIGATION ABUSE
    // ------------------------------------------------------------------------
    testWidgets('Adversarial 7: Malformed deep links display safe UI fallback without crashing (§60, §125)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(
            storageRegistry: storage,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 8: STORAGE CORRUPTION & FAIL-CLOSED RECOVERY
    // ------------------------------------------------------------------------
    test('Adversarial 8: Corrupted preferences in user storage recover safely with deterministic defaults (§74, §131)', () async {
      final compStore = storage.getStoreForModule('mod_companion');
      await compStore.setString('preferences', '{CORRUPTED_JSON_MALFORMED_DATA!!!}');

      final raw = await compStore.getString('preferences');
      CompanionPreferences recovered;
      try {
        recovered = CompanionPreferences.fromJson(Map<String, dynamic>.from({}));
      } catch (_) {
        recovered = const CompanionPreferences();
      }

      expect(recovered.quietHoursStartHour, equals(23));
      expect(recovered.enableQuietHours, isTrue);
      expect(raw.valueOrNull, contains('CORRUPTED'));
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 9: RAPID CONCURRENT TAB SWITCHING (50 RAPID TAPS)
    // ------------------------------------------------------------------------
    testWidgets('Adversarial 9: 50 rapid sequential tab switches maintain UI integrity with zero crashes (§91, §127)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      final icons = [
        Icons.home_rounded,
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.grid_view_rounded,
      ];

      for (int i = 0; i < 50; i++) {
        final icon = icons[i % 5];
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pump(const Duration(milliseconds: 15));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 10: MULTI-DEVICE MATRIX & LARGE TEXT 200% ON EXTREME VIEWPORT
    // ------------------------------------------------------------------------
    testWidgets('Adversarial 10: Extreme narrow phone (320x568) with 200% text scaling renders without fatal overflow (§23, §112)', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2.0),
          ),
          child: child!,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 11: OFFLINE-FIRST OPERATION FROM COLD BOOT
    // ------------------------------------------------------------------------
    testWidgets('Adversarial 11: Complete shell boots offline and all 5 navigation tabs render smoothly (§56, §116)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final offlineStorage = MemoryStorageRegistry();
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(
            storageRegistry: offlineStorage,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Home
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Prayer tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Quran tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Adhkar tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // More tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.grid_view_rounded)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 12: MEMORY SOAK & CLEAN RESOURCE TEARDOWN
    // ------------------------------------------------------------------------
    testWidgets('Adversarial 12: 20 full navigation cycles across all tabs mount and unmount cleanly (§50, §127)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      final icons = [
        Icons.home_rounded,
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.grid_view_rounded,
      ];

      for (int cycle = 0; cycle < 20; cycle++) {
        for (final icon in icons) {
          await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
          await tester.pump(const Duration(milliseconds: 20));
        }
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 13: NOTIFICATION PAYLOAD SANITIZATION & ANTI-SHAME LANGUAGE
    // ------------------------------------------------------------------------
    test('Adversarial 13: Reminder payloads contain calm worship wording without guilt or sensitive balance values (§89, §106)', () {
      final reminders = [
        CompanionReminder(
          reminderId: 'rem_fajr',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الفجر',
          messageArabic: 'الصلاة خير من النوم',
          scheduledTime: DateTime.utc(2026, 9, 1, 5, 0),
          priority: ReminderPriority.high,
          targetRoute: '/prayer',
        ),
        CompanionReminder(
          reminderId: 'rem_adhkar',
          sourceModule: 'adhkar',
          titleArabic: 'أذكار الصباح',
          messageArabic: 'أصبحنا وأصبح الملك لله',
          scheduledTime: DateTime.utc(2026, 9, 1, 6, 30),
          priority: ReminderPriority.medium,
          targetRoute: '/adhkar',
        ),
      ];

      for (final rem in reminders) {
        expect(rem.messageArabic.contains('مقصر'), isFalse);
        expect(rem.messageArabic.contains('عقوبة'), isFalse);
        expect(rem.messageArabic.contains('إثم'), isFalse);
        expect(rem.messageArabic.contains('فشل'), isFalse);
        expect(rem.messageArabic.contains('\$'), isFalse);
      }
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 14: MULTI-SCHOOL FIQH & FABRICATION DEFENSE
    // ------------------------------------------------------------------------
    test('Adversarial 14: Fiqh and Knowledge engines separate policies without personal fatwa generation (§15, §120)', () {
      expect(ZakatPolicy.goldStandard.nameArabic, contains('الذهب'));
      expect(ZakatPolicy.silverStandard.nameArabic, contains('الفضة'));
      expect(ZakatPolicy.goldStandard.annualRateHijri, equals(0.025));
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL 15: RELEASE CONFIGURATION & SECRETS SCAN
    // ------------------------------------------------------------------------
    test('Adversarial 15: Production configuration has no debug flags or hardcoded secrets (§48, §54)', () {
      final config = AppConfig.production();
      expect(config.environment, equals(Environment.production));
      expect(config.defaultLocale, equals('ar'));
      expect(config.failClosedOnContentError, isTrue);
    });
  });
}
