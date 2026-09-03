import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/shell/seed/content_seed_engine.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';

void main() {
  group('M46: Content Population & Non-Empty Experience Tests (§20)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;
    late AdhkarModule adhkarModule;
    late ZakatModule zakatModule;
    late FastingModule fastingModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      quranModule = QuranModule(storageRegistry: storage);
      memorizationModule = MemorizationModule(storageRegistry: storage, quranStore: quranModule.store);
      adhkarModule = AdhkarModule(storageRegistry: storage);
      zakatModule = ZakatModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      learningModule = LearningModule(storageRegistry: storage);
      seerahModule = SeerahModule(storageRegistry: storage);
      hajjModule = HajjModule(storageRegistry: storage);

      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
        quranModule: quranModule,
        memorizationModule: memorizationModule,
        adhkarModule: adhkarModule,
        zakatModule: zakatModule,
        fastingModule: fastingModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      // Seed all modules
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );
    });

    test('All seeded modules contain real verified content items', () {
      // 1. Quran
      final surahs = quranModule.store.getAllSurahs();
      expect(surahs.isSuccess, isTrue);
      expect(surahs.valueOrNull!.length, greaterThanOrEqualTo(6));

      // 2. Adhkar
      final adhkar = adhkarModule.getAllItems();
      expect(adhkar.isSuccess, isTrue);
      expect(adhkar.valueOrNull!.length, greaterThanOrEqualTo(4));

      // 3. Knowledge / Hadith
      final hadiths = knowledgeModule.search('النيات');
      expect(hadiths.isSuccess, isTrue);
      expect(hadiths.valueOrNull!.isNotEmpty, isTrue);

      // 4. Learning / Curriculum
      final paths = learningModule.store.getAllPaths();
      expect(paths.isSuccess, isTrue);
      expect(paths.valueOrNull!.isNotEmpty, isTrue);

      // 5. Seerah / History
      final periods = seerahModule.store.getAllPeriods();
      expect(periods.isSuccess, isTrue);
      expect(periods.valueOrNull!.isNotEmpty, isTrue);

      // 6. Hajj / Umrah
      final steps = hajjModule.store.getStepsForJourney(JourneyType.hajjTamattu);
      expect(steps.isSuccess, isTrue);
      expect(steps.valueOrNull!.isNotEmpty, isTrue);
    });

    test('Federated search over seeded content returns real results across modules', () async {
      final res = await companionModule.search('الوضوء');
      expect(res.isSuccess, isTrue);
      final hits = res.valueOrNull!;
      expect(hits.isNotEmpty, isTrue);
    });

    test('Dashboard cards are non-empty and convey real daily context', () async {
      final cardsRes = await companionModule.getDashboardCards();
      expect(cardsRes.isSuccess, isTrue);
      final cards = cardsRes.valueOrNull!;
      expect(cards.isNotEmpty, isTrue);
      expect(cards.first.titleArabic.isNotEmpty, isTrue);
    });
  });
}
