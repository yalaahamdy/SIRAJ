import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/search/adhkar_search_engine.dart';
import 'package:siraj/shell/seed/data/canonical_adhkar_data.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M03.2 — Adhkar Content Ingestion Batch 2 Verification Suite', () {
    late List<DhikrItem> items;
    late AdhkarModule module;

    setUp(() async {
      items = CanonicalAdhkarData.getAllAdhkar();
      final registry = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: registry);
      await module.initialize();
      final package = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      module.mountPackage(package);
    });

    test('1. Inventory Audit: Total verified items is at least 133', () {
      expect(items.length, greaterThanOrEqualTo(133), reason: 'Total corpus must contain at least 133 canonical items in Batch 2');
    });

    test('2. Group A (Morning Adhkar Expansion): 19 authentic items', () {
      final morning = items.where((i) => i.occasion == DhikrOccasion.morning).toList();
      expect(morning.length, 19);

      // Ayat al-Kursi
      final kursi = morning.firstWhere((i) => i.id == 'dhikr_morning_009');
      expect(kursi.textArabic, contains('اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ'));
      expect(kursi.repetition.count, 1);

      // Mu'awwidhat
      final muawwidhat = morning.firstWhere((i) => i.id == 'dhikr_morning_010');
      expect(muawwidhat.repetition.count, 3);

      // Fitrah al-Islam
      final fitrah = morning.firstWhere((i) => i.id == 'dhikr_morning_011');
      expect(fitrah.textArabic, contains('أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلاَمِ'));

      // Hasbiyallah
      final hasbi = morning.firstWhere((i) => i.id == 'dhikr_morning_012');
      expect(hasbi.repetition.count, 7);

      // Afiyah in body
      final afiyah = morning.firstWhere((i) => i.id == 'dhikr_morning_013');
      expect(afiyah.repetition.count, 3);
      expect(afiyah.textArabic, contains('اللَّهُمَّ عَافِنِي فِي بَدَنِي'));

      // Tahlil 10x and 100x
      final tahlil10 = morning.firstWhere((i) => i.id == 'dhikr_morning_015');
      expect(tahlil10.repetition.count, 10);
      final tahlil100 = morning.firstWhere((i) => i.id == 'dhikr_morning_016');
      expect(tahlil100.repetition.count, 100);

      // Juwayriyah dhikr
      final juwayriyah = morning.firstWhere((i) => i.id == 'dhikr_morning_017');
      expect(juwayriyah.repetition.count, 3);
      expect(juwayriyah.textArabic, contains('عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ'));

      // Istighfar 100x
      final istighfar100 = morning.firstWhere((i) => i.id == 'dhikr_morning_018');
      expect(istighfar100.repetition.count, 100);

      // Beneficial Knowledge
      final knowledge = morning.firstWhere((i) => i.id == 'dhikr_morning_019');
      expect(knowledge.textArabic, contains('عِلْماً نَافِعاً، وَرِزْقاً طَيِّباً'));
    });

    test('3. Group B (Evening Adhkar Expansion): 17 authentic items', () {
      final evening = items.where((i) => i.occasion == DhikrOccasion.evening).toList();
      expect(evening.length, 17);

      final kursi = evening.firstWhere((i) => i.id == 'dhikr_evening_009');
      expect(kursi.textArabic, contains('اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ'));
      expect(kursi.repetition.count, 1);

      final sayyid = evening.firstWhere((i) => i.id == 'dhikr_evening_011');
      expect(sayyid.textArabic, contains('اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ'));

      final baqarahEnd = evening.firstWhere((i) => i.id == 'dhikr_evening_016');
      expect(baqarahEnd.textArabic, contains('آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ'));

      final tasbih100 = evening.firstWhere((i) => i.id == 'dhikr_evening_017');
      expect(tasbih100.repetition.count, 100);
      expect(tasbih100.textArabic, 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.');
    });

    test('4. Group C (Sleep Adhkar Expansion): 15 authentic items including split Tasbih', () {
      final sleep = items.where((i) => i.occasion == DhikrOccasion.sleep).toList();
      expect(sleep.length, 15);

      final subhanallah = sleep.firstWhere((i) => i.id == 'dhikr_sleep_007_a');
      expect(subhanallah.textArabic, 'سُبْحَانَ اللَّهِ.');
      expect(subhanallah.repetition.count, 33);

      final alhamdulillah = sleep.firstWhere((i) => i.id == 'dhikr_sleep_007_b');
      expect(alhamdulillah.textArabic, 'الْحَمْدُ لِلَّهِ.');
      expect(alhamdulillah.repetition.count, 33);

      final allahuakbar = sleep.firstWhere((i) => i.id == 'dhikr_sleep_007_c');
      expect(allahuakbar.textArabic, 'اللَّهُ أَكْبَرُ.');
      expect(allahuakbar.repetition.count, 34);

      final kafiroon = sleep.firstWhere((i) => i.id == 'dhikr_sleep_010');
      expect(kafiroon.textArabic, contains('قُلْ يَا أَيُّهَا الْكَافِرُونَ'));

      final taqallub = sleep.firstWhere((i) => i.id == 'dhikr_sleep_011');
      expect(taqallub.textArabic, contains('لَا إِلَهَ إِلَّا اللَّهُ الوَاحِدُ القَهَّارُ'));

      final dream = sleep.firstWhere((i) => i.id == 'dhikr_sleep_013');
      expect(dream.textArabic, contains('ينفث عن يساره ثلاثاً'));
      expect(dream.repetition.count, 3);
    });

    test('5. Group D (Waking Adhkar Expansion): 4 authentic items', () {
      final waking = items.where((i) => i.occasion == DhikrOccasion.waking).toList();
      expect(waking.length, 4);

      final wake1 = waking.firstWhere((i) => i.id == 'dhikr_general_wake_001');
      expect(wake1.textArabic, contains('أَحْيَانَا بَعْدَ مَا أَمَاتَنَا'));

      final wake2 = waking.firstWhere((i) => i.id == 'dhikr_waking_002');
      expect(wake2.textArabic, contains('عَافَانِي فِي جَسَدِي، وَرَدَّ عَلَيَّ رُوحِي'));

      final wake3 = waking.firstWhere((i) => i.id == 'dhikr_waking_003');
      expect(wake3.textArabic, contains('اللَّهُمَّ اغْفِرْ لِي'));

      final wake4 = waking.firstWhere((i) => i.id == 'dhikr_waking_004');
      expect(wake4.textArabic, contains('إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالأَرْضِ'));
    });

    test('6. Group E (Clothing Adhkar): 5 authentic items classified under clothing', () {
      final clothing = items.where((i) => i.occasion == DhikrOccasion.clothing).toList();
      expect(clothing.length, 5);

      final wear1 = clothing.firstWhere((i) => i.id == 'dhikr_clothing_001');
      expect(wear1.textArabic, contains('كَسَانِي هَذَا الثَّوْبَ وَرَزَقَنِيهِ'));

      final wearNew = clothing.firstWhere((i) => i.id == 'dhikr_clothing_002');
      expect(wearNew.textArabic, contains('اللَّهُمَّ لَكَ الحَمْدُ أَنْتَ كَسَوْتَنِيهِ'));

      final prayNew1 = clothing.firstWhere((i) => i.id == 'dhikr_clothing_003');
      expect(prayNew1.textArabic, contains('تُبْلِي وَيُخْلِفُ اللَّهُ تَعَالَى'));

      final prayNew2 = clothing.firstWhere((i) => i.id == 'dhikr_clothing_004');
      expect(prayNew2.textArabic, contains('الْبَسْ جَدِيداً، وَعِشْ حَمِيداً'));

      final undress = clothing.firstWhere((i) => i.id == 'dhikr_clothing_005');
      expect(undress.textArabic, 'بِسْمِ اللَّهِ.');
    });

    test('7. Group F (General Occasions Expansion): Difficulty, Illness, Weather, Travel, Sneeze, Food, Life', () {
      // Difficulty
      final difficulty = items.where((i) => i.occasion == DhikrOccasion.difficulty).toList();
      expect(difficulty.length, greaterThanOrEqualTo(6));
      expect(difficulty.any((i) => i.id == 'dhikr_difficulty_002' && i.textArabic.contains('العَظِيمُ الحَلِيمُ')), isTrue);
      expect(difficulty.any((i) => i.id == 'dhikr_difficulty_006' && i.textArabic.contains('حَسْبُنَا اللَّهُ')), isTrue);

      // Illness
      final illness = items.where((i) => i.occasion == DhikrOccasion.illness).toList();
      expect(illness.length, 3);
      final tahur = illness.firstWhere((i) => i.id == 'dhikr_illness_001');
      expect(tahur.textArabic, contains('طَهُورٌ إِنْ شَاءَ اللَّهُ'));
      final shifa7 = illness.firstWhere((i) => i.id == 'dhikr_illness_002');
      expect(shifa7.repetition.count, 7);
      final ruqyah = illness.firstWhere((i) => i.id == 'dhikr_illness_003');
      expect(ruqyah.textArabic, contains('أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ'));

      // Weather
      final weather = items.where((i) => i.occasion == DhikrOccasion.weather).toList();
      expect(weather.length, 4);
      expect(weather.any((i) => i.id == 'dhikr_weather_001' && i.textArabic.contains('إِذَا عَصَفَتِ الرِّيحُ' ) == false && i.textArabic.contains('خَيْرَهَا')), isTrue);
      expect(weather.any((i) => i.id == 'dhikr_weather_002' && i.textArabic.contains('يُسَبِّحُ الرَّعْدُ')), isTrue);
      expect(weather.any((i) => i.id == 'dhikr_weather_003' && i.textArabic.contains('صَيِّباً نَافِعاً')), isTrue);
      expect(weather.any((i) => i.id == 'dhikr_weather_004' && i.textArabic.contains('مُطِرْنَا بِفَضْلِ اللَّهِ')), isTrue);

      // Travel
      final travel = items.where((i) => i.occasion == DhikrOccasion.travel).toList();
      expect(travel.length, greaterThanOrEqualTo(5));
      expect(travel.any((i) => i.id == 'dhikr_travel_002' && i.textArabic.contains('أَسْتَوْدِعُ اللَّهَ دِينَكَ')), isTrue);
      expect(travel.any((i) => i.id == 'dhikr_travel_005' && i.textArabic.contains('آيِبُونَ تَائِبُونَ')), isTrue);

      // Food
      final food = items.where((i) => i.occasion == DhikrOccasion.food).toList();
      expect(food.length, greaterThanOrEqualTo(3));
      expect(food.any((i) => i.id == 'dhikr_food_001' && i.textArabic.contains('بِسْمِ اللَّهِ فِي أَوَّلِهِ وَآخِرِهِ')), isTrue);
      expect(food.any((i) => i.id == 'dhikr_food_002' && i.textArabic.contains('أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ')), isTrue);

      // General (Sneeze, Joy, Condolences, Marriage)
      final general = items.where((i) => i.occasion == DhikrOccasion.general).toList();
      expect(general.length, greaterThanOrEqualTo(8));
      expect(general.any((i) => i.id == 'dhikr_general_sneeze_002' && i.textArabic == 'يَرْحَمُكَ اللَّهُ.'), isTrue);
      expect(general.any((i) => i.id == 'dhikr_general_joy_001' && i.textArabic.contains('بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ')), isTrue);
      expect(general.any((i) => i.id == 'dhikr_general_condolence_001' && i.textArabic.contains('إِنَّ لِلَّهِ مَا أَخَذَ')), isTrue);
      expect(general.any((i) => i.id == 'dhikr_general_marriage_001' && i.textArabic.contains('بَارَكَ اللَّهُ لَكَ')), isTrue);
    });

    test('8. Forensic Cryptographic Integrity: 100% of all 132 items verify their SHA-256 hash', () {
      final ids = <String>{};
      for (final item in items) {
        expect(ids.add(item.id), isTrue, reason: 'Duplicate ID detected: ${item.id}');
        expect(item.verifyHash(), isTrue, reason: 'Hash mismatch for item: ${item.id}');
        expect(item.textArabic.trim().isNotEmpty, isTrue);
        expect(item.sourceTitle.isNotEmpty, isTrue);
        expect(item.reference.isNotEmpty, isTrue);
        expect(item.attribution.isNotEmpty, isTrue);
        expect(item.authenticityGrade, AuthenticityGrade.authenticated);
        expect(item.repetition.count, greaterThanOrEqualTo(1));
        expect(item.repetition.isSourced, isTrue);
      }
    });

    test('9. Search Engine: Instant discovery across all new Batch 2 domains', () {
      const search = AdhkarSearchEngine();

      // Kursi
      final resKursi = search.search(items: items, query: 'الكرسي');
      expect(resKursi.isNotEmpty, isTrue);

      // Clothing
      final resCloth = search.search(items: items, query: 'كساني');
      expect(resCloth.any((i) => i.occasion == DhikrOccasion.clothing), isTrue);

      // Illness
      final resIll = search.search(items: items, query: 'طهور');
      expect(resIll.any((i) => i.occasion == DhikrOccasion.illness), isTrue);

      // Weather
      final resRain = search.search(items: items, query: 'صيبا');
      expect(resRain.any((i) => i.occasion == DhikrOccasion.weather), isTrue);

      // Sneeze
      final resSneeze = search.search(items: items, query: 'يرحمك');
      expect(resSneeze.any((i) => i.id == 'dhikr_general_sneeze_002'), isTrue);

      // Marriage
      final resMarriage = search.search(items: items, query: 'تزوج');
      expect(resMarriage.isNotEmpty, isTrue);

      // Food
      final resFood = search.search(items: items, query: 'اطعمني');
      expect(resFood.any((i) => i.occasion == DhikrOccasion.food), isTrue);
    });

    test('10. Counter and Persistence: New items increment and reset cleanly in mod_adhkar', () async {
      final clothItem = items.firstWhere((i) => i.id == 'dhikr_clothing_001');

      final initial = await module.getProgress(clothItem.id, 1);
      expect(initial.valueOrNull!.currentCount, 0);

      await module.incrementProgress(contentId: clothItem.id, targetCount: 1);
      final afterInc = await module.getProgress(clothItem.id, 1);
      expect(afterInc.valueOrNull!.currentCount, 1);
      expect(afterInc.valueOrNull!.isCompleted, isTrue);

      await module.resetProgress(contentId: clothItem.id, targetCount: 1);
      final afterReset = await module.getProgress(clothItem.id, 1);
      expect(afterReset.valueOrNull!.currentCount, 0);
    });
  });
}
