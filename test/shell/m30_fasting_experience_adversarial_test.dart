import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/routing/app_router.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Adversarial & Canonical Shield Suite (§100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
    });

    test('Adversarial 1: Invalid / out-of-range Qada balance is handled safely without throwing', () {
      final invalidPlan = QadaPlan(
        totalDays: 0,
        completedDays: 0,
        preferredWeekdays: const [],
        updatedAt: DateTime.utc(2026, 9, 1),
      );

      expect(invalidPlan.remainingDays, equals(0));
      expect(invalidPlan.progressRatio, equals(1.0));

      final projected = fastingModule.qadaPlannerService.projectCompletionDate(plan: invalidPlan);
      expect(projected, isNull);
    });

    test('Adversarial 2: Corrupted raw JSON in user storage recovers gracefully without crashing', () async {
      await storage.getStoreForModule('mod_fasting').setString('fasting_records', '{malformed_json: true}');

      final res = await fastingModule.getDayRecords();
      expect(res.isSuccess, isFalse);
    });

    test('Adversarial 3: Cross-Module Shield — Fasting operations never mutate Quran or Prayer stores', () async {
      // 1. Mark fasting status
      await fastingModule.markTodayStatus(
        type: FastingType.voluntary,
        status: FastingStatus.fasted,
      );

      // 2. Save Qada plan
      await fastingModule.updateQadaPlan(
        QadaPlan(
          totalDays: 5,
          completedDays: 1,
          preferredWeekdays: const [1, 4],
          updatedAt: DateTime.utc(2026, 9, 1),
        ),
      );

      // 3. Save snapshot
      await fastingModule.saveSnapshot();

      // Verify other stores are untouched
      final quranStoreRes = await storage.getStoreForModule('mod_quran').getString('fasting_records');
      final adhkarStoreRes = await storage.getStoreForModule('mod_adhkar').getString('fasting_records');
      expect(quranStoreRes.valueOrNull, isNull);
      expect(adhkarStoreRes.valueOrNull, isNull);
    });

    testWidgets('Adversarial 4: Invalid deep link route /fasting/unknown loads safe fallback error page without crashing', (tester) async {
      AppRouter.defaultFastingModule = fastingModule;

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
          initialRoute: '/fasting/invalid_subroute_path',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط المطلوب لبرنامج الصيام ورمضان غير صالح'), findsOneWidget);
      expect(find.text('العودة للصيام ورمضان'), findsOneWidget);
    });
  });
}
