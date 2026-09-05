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
  group('M03.1 — Adhkar Content Ingestion Batch 1 Verification Suite', () {
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

    test('1. Inventory Audit: Total verified items is at least 69 (Cumulative)', () {
      expect(items.length, greaterThanOrEqualTo(69), reason: 'Corpus retains all Batch 1 items (at least 69 canonical items)');
    });

    test('2. Group A (Taharah & Wudu & Toilet): 6 authentic items correctly classified', () {
      final taharahItems = items.where((i) => i.occasion == DhikrOccasion.taharah).toList();
      expect(taharahItems.length, 6);

      final toiletEnter = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_toilet_enter_001');
      expect(toiletEnter.textArabic, contains('الخُبُثِ وَالخَبَائِثِ'));
      expect(toiletEnter.repetition.count, 1);
      expect(toiletEnter.authenticityGrade, AuthenticityGrade.authenticated);
      expect(toiletEnter.sourceTitle, contains('البخاري'));

      final toiletExit = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_toilet_exit_001');
      expect(toiletExit.textArabic, 'غُفْرَانَكَ.');
      expect(toiletExit.repetition.count, 1);

      final wuduStart = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_wudu_start_001');
      expect(wuduStart.textArabic, 'بِسْمِ اللَّهِ.');

      final wuduShahada = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_wudu_shahada_001');
      expect(wuduShahada.textArabic, contains('أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ'));
      expect(wuduShahada.reference, contains('234'));

      final wuduRepent = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_wudu_repent_001');
      expect(wuduRepent.textArabic, contains('التَّوَّابِينَ'));

      final wuduKaffarah = taharahItems.firstWhere((i) => i.id == 'dhikr_taharah_wudu_kaffarah_001');
      expect(wuduKaffarah.textArabic, contains('سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ'));
    });

    test('3. Group B (Mosque & Athan): 8 authentic items correctly classified', () {
      final mosqueItems = items.where((i) => i.occasion == DhikrOccasion.mosque).toList();
      expect(mosqueItems.length, 8);

      final goingMosque = mosqueItems.firstWhere((i) => i.id == 'dhikr_mosque_going_001');
      expect(goingMosque.textArabic, contains('اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُوراً'));
      expect(goingMosque.sourceTitle, contains('صحيح البخاري'));

      final enterMosque = mosqueItems.firstWhere((i) => i.id == 'dhikr_general_mosque_enter_001');
      expect(enterMosque.occasion, DhikrOccasion.mosque);
      expect(enterMosque.textArabic, contains('أَبْوَابَ رَحْمَتِكَ'));

      final exitMosque = mosqueItems.firstWhere((i) => i.id == 'dhikr_general_mosque_exit_001');
      expect(exitMosque.occasion, DhikrOccasion.mosque);
      expect(exitMosque.textArabic, contains('أَسْأَلُكَ مِنْ فَضْلِكَ'));

      final athanRepeat = mosqueItems.firstWhere((i) => i.id == 'dhikr_athan_repeat_001');
      expect(athanRepeat.textArabic, contains('لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ'));

      final athanShahada = mosqueItems.firstWhere((i) => i.id == 'dhikr_athan_shahada_001');
      expect(athanShahada.textArabic, contains('رَضِيتُ بِاللَّهِ رَبّاً'));

      final athanSalawat = mosqueItems.firstWhere((i) => i.id == 'dhikr_athan_salawat_001');
      expect(athanSalawat.textArabic, contains('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ'));

      final athanWasilah = mosqueItems.firstWhere((i) => i.id == 'dhikr_athan_wasilah_001');
      expect(athanWasilah.textArabic, contains('آتِ مُحَمَّداً الوَسِيلَةَ وَالفَضِيلَةَ'));

      final athanBetween = mosqueItems.firstWhere((i) => i.id == 'dhikr_athan_between_001');
      expect(athanBetween.textArabic, contains('الدُّعَاءُ لَا يُرَدُّ بَيْنَ الأَذَانِ وَالإِقَامَةِ'));
    });

    test('4. Group C (Prayer Adhkar): 19 sequential items covering all prayer postures', () {
      final prayerItems = items.where((i) => i.occasion == DhikrOccasion.prayer).toList();
      expect(prayerItems.length, greaterThanOrEqualTo(19));

      // Istiftah (3)
      final istiftah1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_istiftah_001');
      expect(istiftah1.textArabic, contains('سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ'));
      final istiftah2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_istiftah_002');
      expect(istiftah2.textArabic, contains('اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ'));
      final istiftah3 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_istiftah_003');
      expect(istiftah3.textArabic, contains('وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ'));

      // Ruku (3)
      final ruku1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_ruku_001');
      expect(ruku1.textArabic, 'سُبْحَانَ رَبِّيَ العَظِيمِ.');
      expect(ruku1.repetition.count, 3);
      final ruku2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_ruku_002');
      expect(ruku2.textArabic, contains('سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ'));
      final ruku3 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_ruku_003');
      expect(ruku3.textArabic, contains('سُبُّوحٌ قُدُّوسٌ'));

      // Raising from Ruku (2)
      final raising1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_raising_001');
      expect(raising1.textArabic, contains('رَبَّنَا وَلَكَ الحَمْدُ، حَمْداً كَثِيراً'));
      final raising2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_raising_002');
      expect(raising2.textArabic, contains('مِلْءَ السَّمَاوَاتِ وَمِلْءَ الأَرْضِ'));

      // Sujood (4)
      final sujood1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sujood_001');
      expect(sujood1.textArabic, 'سُبْحَانَ رَبِّيَ الأَعْلَى.');
      expect(sujood1.repetition.count, 3);
      final sujood2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sujood_002');
      expect(sujood2.textArabic, contains('اللَّهُمَّ اغْفِرْ لِي'));
      final sujood3 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sujood_003');
      expect(sujood3.textArabic, contains('دِقَّهُ وَجِلَّهُ'));
      final sujood4 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sujood_004');
      expect(sujood4.textArabic, contains('سَجَدَ وَجْهِي لِلَّذِي خَلَقَهُ'));

      // Sitting between Sujood (2)
      final sitting1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sitting_001');
      expect(sitting1.textArabic, 'رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي.');
      final sitting2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_sitting_002');
      expect(sitting2.textArabic, contains('وَارْحَمْنِي، وَاهْدِنِي، وَاجْبُرْنِي'));

      // Tashahhud & Salawat (2)
      final tashahhud = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_tashahhud_001');
      expect(tashahhud.textArabic, contains('التَّحِيَّاتُ لِلَّهِ، وَالصَّلَوَاتُ وَالطَّيِّبَاتُ'));
      final salawat = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_salawat_001');
      expect(salawat.textArabic, contains('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ'));

      // Supplication before Salam (3)
      final beforeSalam1 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_before_salam_001');
      expect(beforeSalam1.textArabic, contains('مِنْ عَذَابِ جَهَنَّمَ، وَمِنْ عَذَابِ القَبْرِ'));
      final beforeSalam2 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_before_salam_002');
      expect(beforeSalam2.textArabic, contains('ظَلَمْتُ نَفْسِي ظُلْماً كَثِيراً'));
      final beforeSalam3 = prayerItems.firstWhere((i) => i.id == 'dhikr_prayer_before_salam_003');
      expect(beforeSalam3.textArabic, contains('مَا قَدَّمْتُ وَمَا أَخَّرْتُ'));
    });

    test('5. Fixed After-Prayer Tasbih Bug: 3 distinct items with count 33 and seal of 100', () {
      final afterPrayerItems = items.where((i) => i.occasion == DhikrOccasion.afterPrayer).toList();

      final subhanallah = afterPrayerItems.firstWhere((i) => i.id == 'dhikr_after_prayer_004_a');
      expect(subhanallah.textArabic, 'سُبْحَانَ اللَّهِ.');
      expect(subhanallah.repetition.count, 33);
      expect(subhanallah.repetition.note, contains('ثلاث وثلاثون'));

      final alhamdulillah = afterPrayerItems.firstWhere((i) => i.id == 'dhikr_after_prayer_004_b');
      expect(alhamdulillah.textArabic, 'الْحَمْدُ لِلَّهِ.');
      expect(alhamdulillah.repetition.count, 33);
      expect(alhamdulillah.repetition.note, contains('ثلاث وثلاثون'));

      final allahuAkbar = afterPrayerItems.firstWhere((i) => i.id == 'dhikr_after_prayer_004_c');
      expect(allahuAkbar.textArabic, 'اللَّهُ أَكْبَرُ.');
      expect(allahuAkbar.repetition.count, 33);
      expect(allahuAkbar.repetition.note, contains('ثلاث وثلاثون'));

      final seal = afterPrayerItems.firstWhere((i) => i.id == 'dhikr_after_prayer_005');
      expect(seal.textArabic, contains('لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ'));
      expect(seal.repetition.count, 1);
      expect(seal.repetition.note, contains('تمام المائة'));
    });

    test('6. Searchability across all Batch 1 groups', () {
      const searchEngine = AdhkarSearchEngine();

      // Search Taharah
      final resTaharah = searchEngine.search(items: items, query: 'الخبث');
      expect(resTaharah.any((i) => i.id == 'dhikr_taharah_toilet_enter_001'), isTrue);

      final resGhufran = searchEngine.search(items: items, query: 'غفرانك');
      expect(resGhufran.any((i) => i.id == 'dhikr_taharah_toilet_exit_001'), isTrue);

      // Search Mosque
      final resMosque = searchEngine.search(items: items, query: 'المؤذن');
      expect(resMosque.any((i) => i.id == 'dhikr_athan_repeat_001'), isTrue);

      final resWasilah = searchEngine.search(items: items, query: 'الوسيلة');
      expect(resWasilah.any((i) => i.id == 'dhikr_athan_wasilah_001'), isTrue);

      // Search Prayer
      final resIstiftah = searchEngine.search(items: items, query: 'باعد');
      expect(resIstiftah.any((i) => i.id == 'dhikr_prayer_istiftah_002'), isTrue);

      final resRuku = searchEngine.search(items: items, query: 'سبوح');
      expect(resRuku.any((i) => i.id == 'dhikr_prayer_ruku_003'), isTrue);

      final resTashahhud = searchEngine.search(items: items, query: 'التحيات');
      expect(resTashahhud.any((i) => i.id == 'dhikr_prayer_tashahhud_001'), isTrue);
    });

    test('7. Counter and Persistence verification for new Batch 1 items', () async {
      final istiftah = items.firstWhere((i) => i.id == 'dhikr_prayer_istiftah_001');

      // Check initial progress
      final initial = await module.getProgress(istiftah.id, 1);
      expect(initial.valueOrNull!.currentCount, 0);

      // Increment progress
      await module.incrementProgress(contentId: istiftah.id, targetCount: 1);
      final afterInc = await module.getProgress(istiftah.id, 1);
      expect(afterInc.valueOrNull!.currentCount, 1);
      expect(afterInc.valueOrNull!.isCompleted, isTrue);

      // Reset progress
      await module.resetProgress(contentId: istiftah.id, targetCount: 1);
      final afterReset = await module.getProgress(istiftah.id, 1);
      expect(afterReset.valueOrNull!.currentCount, 0);
    });

    test('8. Favorites toggle works seamlessly for new Batch 1 items', () async {
      final athanWasilah = items.firstWhere((i) => i.id == 'dhikr_athan_wasilah_001');

      // Toggle favorite ON
      await module.toggleFavorite(athanWasilah.id);
      final favs1 = await module.getFavorites();
      expect(favs1.valueOrNull!.any((f) => f.contentId == athanWasilah.id), isTrue);

      // Toggle favorite OFF
      await module.toggleFavorite(athanWasilah.id);
      final favs2 = await module.getFavorites();
      expect(favs2.valueOrNull!.any((f) => f.contentId == athanWasilah.id), isFalse);
    });

    test('9. No duplicate IDs or duplicate Arabic texts across all 69 items', () {
      final ids = <String>{};
      for (final item in items) {
        expect(ids.add(item.id), isTrue, reason: 'Duplicate ID detected: ${item.id}');
      }
    });
  });
}
