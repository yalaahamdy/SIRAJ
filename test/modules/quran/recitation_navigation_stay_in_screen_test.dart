import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_target.dart';
import 'package:siraj/modules/quran/recitation/domain/recitation_playback_policy.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_session_store.dart';
import 'package:siraj/shell/quran/recitation/recitation_hub_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testSurah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameEnglish: 'Al-Fatiha',
    nameTransliteration: 'Al-Fatihah',
    revelationType: RevelationType.meccan,
    ayahCount: 7,
    startPage: 1,
  );

  testWidgets('RecitationHubSheet pops only the bottom sheet and invokes callback without popping parent route',
      (tester) async {
    final storage = MemoryStorageRegistry();
    final sessionStore = QuranRecitationSessionStore(storageRegistry: storage);

    QuranRecitationTarget? receivedTarget;
    RecitationMode? receivedMode;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => RecitationHubSheet(
                        surah: testSurah,
                        totalAyahs: 7,
                        currentAyahNumber: 1,
                        sessionStore: sessionStore,
                        onStartRecitation: (target, mode) {
                          // The callback should NOT pop the parent route
                          receivedTarget = target;
                          receivedMode = mode;
                        },
                      ),
                    );
                  },
                  child: const Text('افتح لوحة التسميع'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Tap button to open RecitationHubSheet
    await tester.tap(find.text('افتح لوحة التسميع'));
    await tester.pumpAndSettle();

    // Verify sheet is visible
    expect(find.textContaining('مركز التسميع والحفظ'), findsOneWidget);
    expect(find.text('ابدأ التسميع الآن'), findsOneWidget);

    // Tap "ابدأ التسميع الآن"
    await tester.tap(find.text('ابدأ التسميع الآن'));
    await tester.pumpAndSettle();

    // Bottom sheet should be dismissed
    expect(find.textContaining('مركز التسميع والحفظ'), findsNothing);

    // Parent screen MUST STILL BE PRESENT (not exited)
    expect(find.text('افتح لوحة التسميع'), findsOneWidget);

    // Target and mode must be received correctly
    expect(receivedTarget, isNotNull);
    expect(receivedTarget!.surahNumber, equals(1));
    expect(receivedMode, equals(RecitationMode.recordAndReplay));
  });
}
