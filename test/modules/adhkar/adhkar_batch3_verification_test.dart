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
  group('M03.3 — Adhkar Content Ingestion Batch 3 Verification Suite', () {
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

    test('1. Inventory Audit: Total verified items reflects Batch 3 baseline', () {
      // 133 previous items + 48 new items = 181 items
      expect(items.length, 181, reason: 'Batch 3 corpus must contain exactly 181 canonical items');
    });

    test('2. Prayer Occasions Expansion: Istikharah, Witr Qunut, Sujud Tilawah, Repentance', () {
      final prayerItems = items.where((i) => i.occasion == DhikrOccasion.prayer).toList();
      // Previously 19, now 19 + 5 = 24
      expect(prayerItems.length, 24);

      final istikharah = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_istikharah_001');
      expect(istikharah.textArabic, contains('اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ'));
      expect(istikharah.repetition.count, 1);

      final qunut = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_witr_qunut_001');
      expect(qunut.textArabic, contains('اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ'));

      final witrAfter = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_witr_after_001');
      expect(witrAfter.textArabic, contains('سُبْحَانَ المَلِكِ القُدُّوسِ'));
      expect(witrAfter.repetition.count, 3);

      final sujud = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sujud_tilawah_001');
      expect(sujud.textArabic, contains('سَجَدَ وَجْهِي لِلَّذِي خَلَقَهُ'));

      final repentance = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_repentance_001');
      expect(repentance.textArabic, contains('فَيُصَلِّي رَكْعَتَيْنِ، ثُمَّ يَسْتَغْفِرُ اللَّهَ'));
    });

    test('3. Difficulty Occasions Expansion: Faith Whispers, Debt Relief, Hardship Ease, Anger', () {
      final diffItems = items.where((i) => i.occasion == DhikrOccasion.difficulty).toList();
      // Previously 6, now 6 + 8 = 14
      expect(diffItems.length, 14);

      final faith1 = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_whisper_faith_001');
      expect(faith1.textArabic, contains('آمَنْتُ بِاللَّهِ وَرُسُلِهِ'));

      final debt1 = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_debt_001');
      expect(debt1.textArabic, contains('اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ'));

      final debt2 = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_debt_002');
      expect(debt2.textArabic, contains('وَضَلَعِ الدَّيْنِ، وَغَلَبَةِ الرِّجَالِ'));

      final whisperPrayer = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_whisper_prayer_001');
      expect(whisperPrayer.textArabic, contains('وَاتْفُلْ عَلَى يَسَارِكَ ثَلَاثاً'));
      expect(whisperPrayer.repetition.count, 3);

      final hardship = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_hardship_001');
      expect(hardship.textArabic, contains('اللَّهُمَّ لا سَهْلَ إِلاَّ مَا جَعَلْتَهُ سَهْلاً'));

      final anger = diffItems.firstWhere((i) => i.id == 'dhikr_difficulty_anger_001');
      expect(anger.textArabic, 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ.');
    });

    test('4. Funerals & Bereavement Domain (DhikrOccasion.funerals): 7 authentic items', () {
      final funerals = items.where((i) => i.occasion == DhikrOccasion.funerals).toList();
      expect(funerals.length, 7);

      final dying1 = funerals.firstWhere((i) => i.id == 'dhikr_funerals_dying_001');
      expect(dying1.textArabic, contains('وَأَلْحِقْنِي بِالرَّفِيقِ الأَعْلَى'));

      final dying2 = funerals.firstWhere((i) => i.id == 'dhikr_funerals_dying_002');
      expect(dying2.textArabic, contains('أَحْيِنِي مَا كَانَتِ الحَيَاةُ خَيْراً لِي'));

      final talqin = funerals.firstWhere((i) => i.id == 'dhikr_funerals_talqin_001');
      expect(talqin.textArabic, contains('مَنْ كَانَ آخِرُ كَلَامِهِ لَا إِلَهَ إِلَّا اللَّهُ'));

      final calamity = funerals.firstWhere((i) => i.id == 'dhikr_funerals_calamity_001');
      expect(calamity.textArabic, contains('إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ'));

      final graveEnter = funerals.firstWhere((i) => i.id == 'dhikr_funerals_grave_enter_001');
      expect(graveEnter.textArabic, contains('بِسْمِ اللَّهِ، وَعَلَى سُنَّةِ رَسُولِ اللَّهِ'));

      final burialAfter = funerals.firstWhere((i) => i.id == 'dhikr_funerals_after_burial_001');
      expect(burialAfter.textArabic, contains('اسْتَغْفِرُوا لِأَخِيكُمْ، وَسَلُوا لَهُ التَّثْبِيتَ'));

      final gravesVisit = funerals.firstWhere((i) => i.id == 'dhikr_funerals_visit_graves_001');
      expect(gravesVisit.textArabic, contains('السَّلَامُ عَلَيْكُمْ أَهْلَ الدِّيَارِ'));
    });

    test('5. Fasting & Hilal Domain (DhikrOccasion.fasting): 5 authentic items', () {
      final fasting = items.where((i) => i.occasion == DhikrOccasion.fasting).toList();
      expect(fasting.length, 5);

      final hilal = fasting.firstWhere((i) => i.id == 'dhikr_fasting_hilal_001');
      expect(hilal.textArabic, contains('اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِاليُمْنِ وَالإِيمَانِ'));

      final iftar1 = fasting.firstWhere((i) => i.id == 'dhikr_fasting_iftar_001');
      expect(iftar1.textArabic, contains('ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ العُرُوقُ'));

      final iftar2 = fasting.firstWhere((i) => i.id == 'dhikr_fasting_iftar_002');
      expect(iftar2.textArabic, contains('أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ'));

      final insult = fasting.firstWhere((i) => i.id == 'dhikr_fasting_insult_001');
      expect(insult.textArabic, 'إِنِّي صَائِمٌ، إِنِّي صَائِمٌ.');
      expect(insult.repetition.count, 1);

      final invited = fasting.firstWhere((i) => i.id == 'dhikr_fasting_invited_001');
      expect(invited.textArabic, contains('فَإِنْ كَانَ صَائِماً فَلْيُصَلِّ'));
    });

    test('6. Gatherings Domain (DhikrOccasion.gatherings): 7 authentic items', () {
      final gatherings = items.where((i) => i.occasion == DhikrOccasion.gatherings).toList();
      expect(gatherings.length, 7);

      final kaffarah = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_kaffarah_001');
      expect(kaffarah.textArabic, contains('سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ'));

      final endDua = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_end_dua_001');
      expect(endDua.textArabic, contains('اللَّهُمَّ اقْسِمْ لَنَا مِنْ خَشْيَتِكَ'));

      final favor = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_favor_001');
      expect(favor.textArabic, 'جَزَاكَ اللَّهُ خَيْراً.');

      final love = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_love_allah_001');
      expect(love.textArabic, 'أَحَبَّكَ الَّذِي أَحْبَبْتَنِي لَهُ.');

      final wealthOffer = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_wealth_offer_001');
      expect(wealthOffer.textArabic, 'بَارَكَ اللَّهُ لَكَ فِي أَهْلِكَ وَمَالِكَ.');

      final debtPay = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_debt_pay_001');
      expect(debtPay.textArabic, contains('إِنَّمَا جَزَاءُ السَّلَفِ الوَفَاءُ وَالحَمْدُ'));

      final salam = gatherings.firstWhere((i) => i.id == 'dhikr_gatherings_salam_001');
      expect(salam.textArabic, contains('أَفْشُوا السَّلَامَ، وَأَطْعِمُوا الطَّعَامَ'));
    });

    test('7. Travel, Food & General Expansion: Market, Village, Milk, Fruit, Virtues', () {
      // Travel market and village
      final market = items.firstWhere((i) => i.id == 'dhikr_travel_market_001');
      expect(market.occasion, DhikrOccasion.travel);
      expect(market.textArabic, contains('يُحْيِي وَيُمِيتُ، وَهُوَ حَيٌّ لَا يَمُوتُ'));

      final village = items.firstWhere((i) => i.id == 'dhikr_travel_village_enter_001');
      expect(village.occasion, DhikrOccasion.travel);
      expect(village.textArabic, contains('اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ'));

      final stayHome = items.firstWhere((i) => i.id == 'dhikr_travel_stay_home_001');
      expect(stayHome.textArabic, 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.');

      // Food milk and fruit
      final milk = items.firstWhere((i) => i.id == 'dhikr_food_milk_001');
      expect(milk.occasion, DhikrOccasion.food);
      expect(milk.textArabic, 'اللَّهُمَّ بَارِكْ لَنَا فِيهِ وَزِدْنَا مِنْهُ.');

      final fruit = items.firstWhere((i) => i.id == 'dhikr_food_first_fruit_001');
      expect(fruit.occasion, DhikrOccasion.food);
      expect(fruit.textArabic, contains('اللَّهُمَّ بَارِكْ لَنَا فِي ثَمَرِنَا'));

      // General virtues
      final intercourse = items.firstWhere((i) => i.id == 'dhikr_general_intercourse_001');
      expect(intercourse.textArabic, contains('جَنِّبْنَا الشَّيْطَانَ'));

      final afflicted = items.firstWhere((i) => i.id == 'dhikr_general_afflicted_001');
      expect(afflicted.textArabic, contains('الحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ'));

      final dajjal = items.firstWhere((i) => i.id == 'dhikr_general_dajjal_surah_001');
      expect(dajjal.textArabic, contains('سُورَةِ الكَهْفِ'));

      final shirk = items.firstWhere((i) => i.id == 'dhikr_general_shirk_fear_001');
      expect(shirk.textArabic, contains('أَنْ أُشْرِكَ بِكَ وَأَنَا أَعْلَمُ'));

      final tiyarah = items.firstWhere((i) => i.id == 'dhikr_general_tiyarah_001');
      expect(tiyarah.textArabic, contains('اللَّهُمَّ لَا طَيْرَ إِلَّا طَيْرُكَ'));

      final salawat = items.firstWhere((i) => i.id == 'dhikr_general_salawat_001');
      expect(salawat.repetition.count, 10);

      final tasbihScale = items.firstWhere((i) => i.id == 'dhikr_general_tasbih_scale_001');
      expect(tasbihScale.textArabic, contains('كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ'));

      final hawqalah = items.firstWhere((i) => i.id == 'dhikr_general_hawqalah_001');
      expect(hawqalah.textArabic, 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.');

      final greatIstighfar = items.firstWhere((i) => i.id == 'dhikr_general_istighfar_great_001');
      expect(greatIstighfar.textArabic, contains('أَسْتَغْفِرُ اللَّهَ العَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ'));
      expect(greatIstighfar.repetition.count, 3);
    });

    test('8. Forensic Cryptographic Integrity: 100% of all 179 items verify their SHA-256 hash', () {
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

    test('9. Search Engine: Discovery across all Batch 3 new keywords and occasions', () {
      const search = AdhkarSearchEngine();

      // Istikharah
      final resIstikharah = search.search(items: items, query: 'أستخيرك');
      expect(resIstikharah.any((i) => i.id == 'dhikr_prayer_istikharah_001'), isTrue);

      // Qunut
      final resQunut = search.search(items: items, query: 'قنوت');
      expect(resQunut.isNotEmpty, isTrue);

      // Debt
      final resDebt = search.search(items: items, query: 'بحلالك عن حرامك');
      expect(resDebt.any((i) => i.id == 'dhikr_difficulty_debt_001'), isTrue);

      // Funerals / Graves
      final resGraves = search.search(items: items, query: 'أهل الديار');
      expect(resGraves.any((i) => i.occasion == DhikrOccasion.funerals), isTrue);

      // Fasting
      final resIftar = search.search(items: items, query: 'ذهب الظمأ');
      expect(resIftar.any((i) => i.occasion == DhikrOccasion.fasting), isTrue);

      // Gatherings / Kaffarah
      final resKaffarah = search.search(items: items, query: 'سبحانك اللهم وبحمدك');
      expect(resKaffarah.any((i) => i.occasion == DhikrOccasion.gatherings), isTrue);

      // Market
      final resMarket = search.search(items: items, query: 'دخل السوق');
      expect(resMarket.any((i) => i.id == 'dhikr_travel_market_001'), isTrue);
    });

    test('10. Counter & Persistence in mod_adhkar for new Batch 3 items', () async {
      final witrItem = items.firstWhere((i) => i.id == 'dhikr_prayer_witr_after_001');
      expect(witrItem.repetition.count, 3);

      final initial = await module.getProgress(witrItem.id, 3);
      expect(initial.valueOrNull!.currentCount, 0);

      await module.incrementProgress(contentId: witrItem.id, targetCount: 3);
      await module.incrementProgress(contentId: witrItem.id, targetCount: 3);
      final after2 = await module.getProgress(witrItem.id, 3);
      expect(after2.valueOrNull!.currentCount, 2);
      expect(after2.valueOrNull!.isCompleted, isFalse);

      await module.incrementProgress(contentId: witrItem.id, targetCount: 3);
      final completed = await module.getProgress(witrItem.id, 3);
      expect(completed.valueOrNull!.currentCount, 3);
      expect(completed.valueOrNull!.isCompleted, isTrue);

      await module.resetProgress(contentId: witrItem.id, targetCount: 3);
      final reset = await module.getProgress(witrItem.id, 3);
      expect(reset.valueOrNull!.currentCount, 0);
    });
  });
}
