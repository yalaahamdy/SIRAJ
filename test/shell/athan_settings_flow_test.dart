import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/screens/athan_settings_screen.dart';
import 'package:siraj/shell/prayer/widgets/athan_preview_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MemoryStorageRegistry storage;
  late PrayerModule prayerModule;

  setUp(() {
    storage = MemoryStorageRegistry();
    prayerModule = PrayerModule(storageRegistry: storage);
  });

  group('Athan Settings UI & Preview Flow Tests (§32)', () {
    testWidgets('AthanPreviewCard renders title and play button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AthanPreviewCard(
              audioService: prayerModule.athanAudioService,
            ),
          ),
        ),
      );

      expect(find.text('أذان الشيخ عبد الباسط عبد الصمد'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.text('اضغط للاستماع لمعاينة صوت الأذان'), findsOneWidget);
    });

    testWidgets('AthanSettingsScreen renders preview card, volume slider, and all prayers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AthanSettingsScreen(
            prayerModule: prayerModule,
          ),
        ),
      );

      // Verify sections
      expect(find.text('إعدادات الأذان والتنبيهات'), findsOneWidget);
      expect(find.text('الصوت المعتمد للأذان'), findsOneWidget);
      expect(find.text('أذان الشيخ عبد الباسط عبد الصمد'), findsOneWidget);
      expect(find.text('التحكم في الصوت والاهتزاز'), findsOneWidget);
      expect(find.text('مستوى صوت الأذان'), findsOneWidget);
      expect(find.text('تفعيل الاهتزاز مع التنبيه'), findsOneWidget);

      // Verify all prayers exist in the list
      expect(find.text('الفجر'), findsOneWidget);
      expect(find.text('الظهر'), findsOneWidget);
      expect(find.text('العصر'), findsOneWidget);
      expect(find.text('المغرب'), findsOneWidget);
      expect(find.text('العشاء'), findsOneWidget);
    });

    testWidgets('Tapping prayer item opens customization modal bottom sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AthanSettingsScreen(
            prayerModule: prayerModule,
          ),
        ),
      );

      // Tap on Fajr tile
      await tester.tap(find.text('الفجر'));
      await tester.pumpAndSettle();

      // Verify modal sheet opened
      expect(find.text('تخصيص تنبيه صلاة الفجر'), findsOneWidget);
      expect(find.text('أذان كامل'), findsOneWidget);
      expect(find.text('تكبيرات فقط'), findsOneWidget);
      expect(find.text('إشعار فقط'), findsOneWidget);
      expect(find.text('صامت'), findsOneWidget);
      expect(find.text('معطل'), findsOneWidget);

      // Switch Fajr to Takbeerat only
      await tester.tap(find.text('تكبيرات فقط'));
      await tester.pumpAndSettle();

      // Modal closed and state updated
      expect(find.text('تخصيص تنبيه صلاة الفجر'), findsNothing);
      expect(find.textContaining('النمط: تكبيرات فقط'), findsOneWidget);
    });
  });
}
