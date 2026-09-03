import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_target.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_recognition_gateway.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_recorder.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_session_store.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/recitation/recitation_mode_a_view.dart';
import 'package:siraj/shell/quran/recitation/recitation_mode_b_view.dart';

void main() {
  final testAyah = Ayah.create(
    surahNumber: 1,
    ayahNumber: 1,
    textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
    textSimple: 'بسم الله الرحمن الرحيم',
    pageNumber: 1,
    juzNumber: 1,
    hizbNumber: 1,
    rubNumber: 1,
    manzilNumber: 1,
  );

  final target = const QuranRecitationTarget(
    surahNumber: 1,
    surahNameArabic: 'الفاتحة',
    startAyah: 1,
    endAyah: 1,
  );

  late QuranRecitationSessionStore sessionStore;

  setUp(() {
    sessionStore = QuranRecitationSessionStore(storageRegistry: MemoryStorageRegistry());
  });

  group('M02.2 Quran Recitation Accessibility Semantics Tests (§17)', () {
    testWidgets('Mode A hides canonical Quran text from screen reader during recitation and exposes veil semantic (§17)', (tester) async {
      final mockRecorder = QuranRecitationRecorder(
        adapter: MockAudioRecorderAdapter(permissionGranted: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeAView(
            target: target,
            targetAyahs: [testAyah],
            config: const QuranTypographyConfig(),
            recorder: mockRecorder,
            sessionStore: sessionStore,
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Screen reader MUST NOT read canonical verse text while recording/veiled
      expect(find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsNothing);

      // Screen reader should find semantic veil description
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'نص الآية 1 مخفي أثناء التسميع',
        ),
        findsOneWidget,
      );

      // Record button must have clear label
      expect(find.text('بدء تسجيل التلاوة'), findsOneWidget);
    });

    testWidgets('Mode B marks hidden words with "كلمة مخفية" semantic label (§17)', (tester) async {
      final mockGateway = MockRecitationRecognitionGateway(simulateAvailable: true);

      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeBView(
            target: target,
            targetAyahs: [testAyah],
            config: const QuranTypographyConfig(),
            gateway: mockGateway,
            sessionStore: sessionStore,
            onSwitchToModeA: () {},
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 4 words in ayah 1 should each have 'كلمة مخفية' semantics
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'كلمة مخفية',
        ),
        findsNWidgets(4),
      );

      // Reveal button is clearly labeled
      expect(find.text('إظهار الكلمة'), findsOneWidget);
      expect(find.text('ابدأ التسميع'), findsOneWidget);

      addTearDown(mockGateway.dispose);
    });
  });
}
