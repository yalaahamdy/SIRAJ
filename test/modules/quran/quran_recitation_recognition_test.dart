import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_target.dart';
import 'package:siraj/modules/quran/recitation/domain/recitation_playback_policy.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_recognition_gateway.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_session_store.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/recitation/recitation_mode_b_view.dart';

void main() {
  final testAyah1 = Ayah.create(
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

  final testAyah2 = Ayah.create(
    surahNumber: 1,
    ayahNumber: 2,
    textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ',
    textSimple: 'الحمد لله رب العالمين',
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
    endAyah: 2,
  );

  late MockRecitationRecognitionGateway mockGateway;
  late QuranRecitationSessionStore sessionStore;

  setUp(() {
    mockGateway = MockRecitationRecognitionGateway(simulateAvailable: true);
    sessionStore = QuranRecitationSessionStore(storageRegistry: MemoryStorageRegistry());
  });

  tearDown(() {
    mockGateway.dispose();
  });

  group('M02.2 Quran Recitation Recognition Subsystem Tests (§4, §5, §11, §12)', () {
    test('Gateway reports available when supported by the underlying engine', () async {
      expect(await mockGateway.isAvailable(), isTrue);

      final unavailableGateway = NativeSpeechRecognitionGateway(isHardwareAvailable: false);
      expect(await unavailableGateway.isAvailable(), isFalse);
    });

    testWidgets('Renders unavailable fallback card when recognition engine is unsupported (§6)', (tester) async {
      final unavailableGateway = MockRecitationRecognitionGateway(simulateAvailable: false);
      bool switchedToModeA = false;

      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeBView(
            target: target,
            targetAyahs: [testAyah1, testAyah2],
            config: const QuranTypographyConfig(),
            gateway: unavailableGateway,
            sessionStore: sessionStore,
            onSwitchToModeA: () => switchedToModeA = true,
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التعرف على التلاوة غير متاح على هذا الجهاز حالياً'), findsOneWidget);
      expect(find.text('التبديل إلى وضع التسجيل الذاتي'), findsOneWidget);

      await tester.tap(find.text('التبديل إلى وضع التسجيل الذاتي'));
      await tester.pumpAndSettle();
      expect(switchedToModeA, isTrue);
    });

    testWidgets('Starts listening and reveals recognized words sequentially upon speech token stream', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeBView(
            target: target,
            targetAyahs: [testAyah1, testAyah2],
            config: const QuranTypographyConfig(),
            gateway: mockGateway,
            sessionStore: sessionStore,
            onSwitchToModeA: () {},
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "ابدأ التسميع"
      await tester.tap(find.text('ابدأ التسميع'));
      await tester.pump();

      expect(find.text('إيقاف التسميع'), findsOneWidget);

      bool isWordRevealed(String word) {
        final texts = tester.widgetList<Text>(find.byType(Text));
        return texts.any((t) => t.textSpan?.toPlainText().contains(word) ?? false);
      }

      // Initially all words are hidden
      expect(isWordRevealed('بِسْمِ'), isFalse);

      // Emit first word 'بسم'
      mockGateway.emitToken('بسم');
      await tester.pump();

      // First word revealed
      expect(isWordRevealed('بِسْمِ'), isTrue);

      // Emit second word 'الله'
      mockGateway.emitToken('الله');
      await tester.pump();
      expect(isWordRevealed('ٱللَّهِ'), isTrue);
    });

    testWidgets('Manual reveal button reveals current word and advances pointer (§11)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeBView(
            target: target,
            targetAyahs: [testAyah1],
            config: const QuranTypographyConfig(),
            gateway: mockGateway,
            sessionStore: sessionStore,
            onSwitchToModeA: () {},
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Start recitation
      await tester.tap(find.text('ابدأ التسميع'));
      await tester.pump();

      bool isWordRevealed(String word) {
        final texts = tester.widgetList<Text>(find.byType(Text));
        return texts.any((t) => t.textSpan?.toPlainText().contains(word) ?? false);
      }

      expect(isWordRevealed('بِسْمِ'), isFalse);

      // Tap 'إظهار الكلمة'
      await tester.tap(find.text('إظهار الكلمة'));
      await tester.pump();

      // First word revealed through manual help
      expect(isWordRevealed('بِسْمِ'), isTrue);
    });

    testWidgets('Auto-advances to next verse and displays complete summary without religious score (§12, §13)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RecitationModeBView(
            target: target,
            targetAyahs: [testAyah1], // 4 words total
            config: const QuranTypographyConfig(),
            gateway: mockGateway,
            sessionStore: sessionStore,
            onSwitchToModeA: () {},
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ابدأ التسميع'));
      await tester.pump();

      // Emit all 4 words of testAyah1
      mockGateway.emitToken('بسم');
      await tester.pump();
      mockGateway.emitToken('الله');
      await tester.pump();
      mockGateway.emitToken('الرحمن');
      await tester.pump();
      mockGateway.emitToken('الرحيم');
      await tester.pumpAndSettle();

      // Session should be complete
      expect(find.text('اكتملت جلسة التسميع'), findsOneWidget);
      expect(find.text('الكلمات المتعرف عليها'), findsOneWidget);
      expect(find.text('4'), findsNWidgets(2));

      // Invariant: strictly NO piety / religious score
      expect(find.textContaining('درجة الإيمان'), findsNothing);
      expect(find.textContaining('درجة التدين'), findsNothing);
      expect(find.textContaining('تقييم شرعي'), findsNothing);

      // Verify session was persisted in store
      final lastSession = await sessionStore.getLastSession();
      expect(lastSession, isNotNull);
      expect(lastSession!.recognizedWordsCount, equals(4));
      expect(lastSession.mode, equals(RecitationMode.recognition));
    });
  });
}
