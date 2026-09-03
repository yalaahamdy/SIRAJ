import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/shell/memorization/study_session_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L4 Study Session Screen UI & Interaction Tests (§10, §38, §39)', () {
    late MemoryStorageRegistry storage;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: TestClock(DateTime.utc(2026, 8, 31, 12, 0)),
      );

      await module.initialize();
      // Setup a 1-Ayah mini plan for fast testing
      await module.savePlan(
        MemorizationPlan(
          id: 'plan_mini',
          title: 'خطة سريعة',
          targetSurahs: const [1],
          startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
          endAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
          dailyNewAyahs: 1,
          dailyReviewTarget: 5,
          createdAt: DateTime.utc(2026, 8, 31),
        ),
      );
    });

    testWidgets('Study session lifecycle: Hidden -> Reveal -> Rating -> Completion Summary', (tester) async {
      var finished = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StudySessionScreen(
            memorizationModule: module,
            onFinish: () => finished = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Card is hidden initially
      expect(find.text('استدعِ الآية في ذاكرتك ثم اضغط للتحقق'), findsOneWidget);
      expect(find.text('إظهار الآية والتحقق'), findsOneWidget);

      // Tap Reveal button
      await tester.tap(find.text('إظهار الآية والتحقق'));
      await tester.pumpAndSettle();

      // Canonical verse text is now displayed
      expect(find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsOneWidget);

      // Rating bar appears with 4 buttons
      expect(find.text('إعادة'), findsOneWidget);
      expect(find.text('صعب'), findsOneWidget);
      expect(find.text('جيد'), findsOneWidget);
      expect(find.text('سهل'), findsOneWidget);

      // Tap "جيد"
      await tester.tap(find.text('جيد'));
      await tester.pumpAndSettle();

      // Session completes -> Summary screen renders
      expect(find.textContaining('تم إكمال جلسة'), findsOneWidget);
      expect(find.text('العودة للوحة التحكم'), findsOneWidget);

      // Tap finish
      await tester.tap(find.text('العودة للوحة التحكم'));
      await tester.pumpAndSettle();
      expect(finished, isTrue);
    });
  });
}
